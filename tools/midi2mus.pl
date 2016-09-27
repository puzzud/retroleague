#!/usr/bin/perl -w

use Getopt::Long;

#====================================================
@::NoteIdNameList =
(
  "NOTE_C",
  "NOTE_CS",
  "NOTE_D",
  "NOTE_DS",
  "NOTE_E",
  "NOTE_F",
  "NOTE_FS",
  "NOTE_G",
  "NOTE_GS",
  "NOTE_A",
  "NOTE_AS",
  "NOTE_B"
);

$::NUMBER_OF_NOTES_IN_OCTAVE = scalar(@::NoteIdNameList);

#====================================================

$::Debug = ''; # Option variable with default value.
$::DurationScale = 1.0;
my @VoiceList = ();

my $inputFileName = "";
my $outputFileName = "";

GetOptions
(
  "debug" => \$::Debug,
  "ds=f" => \$::DurationScale,
  "voices=s" => \@VoiceList,
  "input=s" => \$inputFileName,
  "output=s" => \$outputFileName
);

$::Debug = $::Debug eq "" ? 0 : 1;
$::DurationScale = $::DurationScale eq "" ? 1.0 : $::DurationScale;

@VoiceList = split(',', join(',', @VoiceList));

if($inputFileName eq "")
{
  $inputFileName = "&STDIN";
}

if($outputFileName eq "")
{
  $outputFileName = "&STDOUT";
}

$::OutputFile = undef;

#====================================================

$::PreviousEventType = 0;

%::VoiceDataHash = ();

#====================================================

sub debug;
sub output;

sub ImportMidiFileData($);
sub GetVariableLengthValue;
sub ProcessTrackChunk($$);
sub ProcessEvent($$$$);
sub ProcessMetaEvent($);
sub ProcessSysExEvent($);
sub ProcessMidiEvent($$$$$);
sub RegisterNote($$$$);

sub GetVoiceKeys($$);
sub ProcessNote;
sub SortTrackChannelPairs;
sub ExtractTrackAndChannelFromPair;
sub GetAllTracksNoteDurationGcd($);
sub Gcd;
sub OutputMusicSourceBytes($$);

#=======================================================
# Main.
#=======================================================

#open my $fh, "<", $ARGV[0] or die $!;

my $inputFile;
open $inputFile, "<$inputFileName";
my %completeVoiceDataHash = ImportMidiFileData($inputFile);
close $inputFile;

my @voiceKeyList = GetVoiceKeys(\@VoiceList, \%completeVoiceDataHash);

debug "============================================================" . "\n";
debug "Processing imported MIDI data." . "\n";
debug "============================================================" . "\n";

open $::OutputFile, ">$outputFileName";

$::Gcd = GetAllTracksNoteDurationGcd(\@voiceKeyList);

my $voiceIndex = 0;
foreach my $voiceKey (@voiceKeyList)
{
  $voiceIndex++;
#   if($voiceIndex != 2)
#   {
#     next;
#   }
  
  debug "Processing MIDI channel $voiceKey as voice $voiceIndex." . "\n";
  
  if(!defined($::VoiceDataHash{$voiceKey}))
  {
    next;
  }
  
  my %voiceDataHash = %{$::VoiceDataHash{$voiceKey}};
  
  if(!defined($voiceDataHash{0}))
  {
    $voiceDataHash{0} = -1;
  }
  
  my @vTimeList = sort {$a <=> $b}(keys(%voiceDataHash));
  
  my @byteList = ();
  
  my $lastNoteDuration = 0;
  
  my $numberOfVTimes = scalar(@vTimeList);
  my $vTime;
  my $noteNumber;
  my $noteDuration;
  my $vTimeIndex = 0;
  for(; $vTimeIndex < $numberOfVTimes - 1; $vTimeIndex++)
  {
    $vTime = $vTimeList[$vTimeIndex];
    $noteNumber = $voiceDataHash{$vTime};
    $noteDuration = $vTimeList[$vTimeIndex + 1] - $vTime;
    
    ProcessNote($noteNumber, $noteDuration, \$lastNoteDuration, \@byteList);
  }
  
  # Process last byte.
  $vTime = $vTimeList[$vTimeIndex - 1];
  $noteNumber = $voiceDataHash{$vTime};
  $noteDuration = $vTime - $vTimeList[$vTimeIndex - 2];
  ProcessNote($noteNumber, $noteDuration, \$lastNoteDuration, \@byteList);
  
  OutputMusicSourceBytes($voiceIndex, \@byteList);
}

close $::OutputFile;

exit 0;

#===========================================================================================
sub debug
{
  if($::Debug)
  {
    my $output = shift;
    print $output;
  }
}

sub output
{
  my $output = shift;
  print $::OutputFile $output;
}

sub ImportMidiFileData($)
{
  my ($input) = @_;

  my $chunkType;
  my $chunkLength;

  read($input, $chunkType, 4);
  if($chunkType ne "MThd")
  {
    debug "Error:  The input file is not a standard MIDI file." . "\n";
    exit 1;
  }

  debug "==========================================================" . "\n";
  debug "Header" . "\n";

  # Process header.
  my $format;
  my $numberOfTrackChunks;
  my $division;

  read($input, $chunkLength, 4);
  $chunkLength = unpack('N', $chunkLength);

  read($input, $format, 2);
  $format = unpack('n', $format);
  if($format == 2)
  {
    # Do not support multiple song MIDI files.
    debug "Error:  Standard MIDI file format 2 is not supported." . "\n";
    exit 2;
  }

  read($input, $numberOfTrackChunks, 2);
  $numberOfTrackChunks = unpack('n', $numberOfTrackChunks);
  debug "numberOfTrackChunks:$numberOfTrackChunks" . "\n";

  read($input, $division, 2);
  $division = unpack('n', $division);
  debug "division:$division" . "\n";

  for(my $trackIndex = 0; $trackIndex < $numberOfTrackChunks; $trackIndex++)
  {
    ProcessTrackChunk($input, $trackIndex);
  }
  
  return %::VoiceDataHash;
}

sub GetVariableLengthValue
{
  my $input = shift;
  my $output = shift;
  
  my $byteLength = 0;

  my $byte;

  read($input, $$output, 1);
  $$output = unpack('C', $$output);
  $byteLength++;
  
  if(($$output & 0x80) > 0)
  {
    $$output &= 0x7f;
    do
    {
      $$output <<= 7;
      
      read($input, $byte, 1);
      $byte = unpack('C', $byte);
      
      $$output += $byte & 0x7f;
      
      $byteLength++;
    }
    while(($byte & 0x80) > 0);
  }
  
  return $byteLength;
}

sub ProcessTrackChunk($$)
{
  my ($input, $trackIndex) = @_; 
  
  my $chunkType;
  my $chunkLength;

  # Process track chunk.
  read($input, $chunkType, 4);
  if($chunkType ne "MTrk")
  {
    # Must not be a track chunk.
    debug "Error: Must not be a track chunk." . "\n";
    exit 3;
  }
  
  debug "==========================================================" . "\n";
  debug "Track #:$trackIndex" . "\n";
  
  read($input, $chunkLength, 4);
  $chunkLength = unpack('N', $chunkLength);
  debug "chunkLength:$chunkLength" . "\n";
  
  my $runningTime = 0;
  
  for(my $i = 0; $i < $chunkLength;)
  {
    debug "---------------------------" . "\n";
  
    my $vtime;
    $i += GetVariableLengthValue($input, \$vtime);
    debug "VTime:$vtime" . "\n";

    $runningTime += $vtime;
    
    $i += ProcessEvent($input, $trackIndex, $vtime, $runningTime);
    
    #debug "ENDING OFFSET: $i" . "\n";
  }
  
  return 0;
}

sub ProcessEvent($$$$)
{
  my ($input, $trackIndex, $vtime, $runningTime) = @_; 
  
  my $numberOfBytes = 0;

  my $eventType;
  read($input, $eventType, 1); $numberOfBytes++;
  $eventType = unpack('C', $eventType);
  
  if($eventType == 0xff)
  {
    $numberOfBytes += ProcessMetaEvent($input);
  }
  elsif(($eventType == 0xf0) ||
         ($eventType == 0xf7))
  {
    $numberOfBytes += ProcessSysExEvent($input);
  }
  else
  {
    $numberOfBytes += ProcessMidiEvent($input, $trackIndex, $vtime, $runningTime, $eventType);
  }
  
  return $numberOfBytes;
}

sub ProcessMetaEvent($)
{
  my $input = $_[0];
  
  my $numberOfBytes = 0;
  
  # Meta event.
  my $metaType;
  read($input, $metaType, 1); $numberOfBytes++;
  $metaType = unpack('C', $metaType);
  debug "metaType:" . sprintf("0x%x", $metaType) . "\n";
  
  my $eventLength;
  $numberOfBytes += GetVariableLengthValue($input, \$eventLength);
  debug "eventLength:$eventLength" . "\n";
  
  # 0x00 Sequence number
  # 0x01 Text event
  # 0x02 Copyright notice
  # 0x03 Sequence or track name
  # 0x04 Instrument name
  # 0x05 Lyric text
  # 0x06 Marker text
  # 0x07 Cue point
  #   
  # 0x20 MIDI channel prefix assignment
  # 0x2F End of track
  # 0x51 Tempo setting
  # 0x54 SMPTE offset
  # 0x58 Time signature
  # 0x59 Key signature
  # 0x7F Sequencer specific event
  
  my $supported = 0;
  
  if($metaType == 0x03)
  {
    # Sequence or track name.
    my $trackName;
    read($input, $trackName, $eventLength);
    debug "trackName:$trackName" . "\n";
    
    $supported = 1;
  }
  elsif($metaType == 0x06)
  {
    # Marker text.
    my $markerText;
    read($input, $markerText, $eventLength);
    debug "markerText:$markerText" . "\n";
    
    $supported = 1;
  }
  elsif($metaType == 0x2f)
  {
    # End of track.
    debug "*End of track." . "\n";
    
    # NOTE: This event does not have a length, it just has a
    # null byte which has been consumed by the eventLength variable.
    
    $supported = 1;
  }
  elsif($metaType == 0x51)
  {
    # Tempo setting. NOTE: Ignored for now.
    #read($input, $temp, $eventLength);
  }
  elsif($metaType == 0x58)
  {
    # Time signature. NOTE: Ignored for now.
    #read($input, $temp, $eventLength);
  }
  elsif($metaType == 0x59)
  {
    # Key signature. NOTE: Ignored for now.
    #read($input, $temp, $eventLength);
  }
  
  if($supported == 0)
  {
    # TODO: Change to use seek.
    my $temp;
    read($input, $temp, $eventLength);
  }
  
  $numberOfBytes += $eventLength;
  return $numberOfBytes;
}

sub ProcessSysExEvent($)
{
  my $input = $_[0];
  
  debug "!!!SYSEX EVENT!!!" . "\n";
  
  my $numberOfBytes = 0;
  
  # Sysex event.
  
  my $eventLength;
  $numberOfBytes += GetVariableLengthValue($input, \$eventLength);
  debug "eventLength:$eventLength" . "\n";
  
  # TODO: Change to use seek.
  my $temp;
  read($input, $temp, $eventLength);
  
  $numberOfBytes += $eventLength;
  return $numberOfBytes;
}

sub ProcessMidiEvent($$$$$)
{
  my ($input, $trackIndex, $vtime, $runningTime, $eventType) = @_;
  
  # MIDI event.
  my $midiChannel;
  
  # First backup eventType (first byte), in the event of a
  # running status.
  my $firstByte = $eventType;
  
  my $runningStatus = 0;

  my $supported = 0;
  my $eventLength = 2;
  
  if(($eventType & 0x80) == 0)
  {
    # Running Status.
    $runningStatus = 1;
    debug "(Running Status...)" . "\n";
   
    $eventType = $::PreviousEventType;
    
    $eventLength--; # NOTE: Hack to report 1 less byte.
  }
  else
  {
    $::PreviousEventType = $eventType;
  }
  
  # Strip out MIDI channel 
  $midiChannel = $eventType & 0x0f;
  $eventType = $eventType >> 4;
  
  debug "eventType:" . sprintf("0x%x", $eventType) . "\n";
  debug "midiChannel:$midiChannel" . "\n";
  
  # 0x8 Note Off
  # 0x9 Note On
  # 0xA Note Aftertouch
  # 0xB Controller
  # 0xC Program Change
  # 0xD Channel Aftertouch
  # 0xE Pitch Bend
  
  if($eventType == 0x8)
  {
    # Note Off.
    my $noteNumber;
    if($runningStatus == 0)
    {
      read($input, $noteNumber, 1);
      $noteNumber = unpack('C', $noteNumber);
    }
    else
    {
      $noteNumber = $firstByte;
    }
    debug "noteNumber:$noteNumber" . "\n";
    
    my $velocity;
    read($input, $velocity, 1);
    $velocity = unpack('C', $velocity);
    debug "velocity:$velocity" . "\n";
    
    RegisterNote($trackIndex, $midiChannel, $runningTime, -1);
    
    $supported = 1; # NOTE: Not really supported at this point.
  }
  elsif($eventType == 0x9)
  {
    # Note On.
    my $noteNumber;
    if($runningStatus == 0)
    {
      read($input, $noteNumber, 1);
      $noteNumber = unpack('C', $noteNumber);
    }
    else
    {
      $noteNumber = $firstByte;
    }
    debug sprintf("noteNumber:%d (0x%x) ", $noteNumber, $noteNumber) . ($::NoteIdNameList[$noteNumber % $::NUMBER_OF_NOTES_IN_OCTAVE]) . "\n";
    
    my $velocity;
    read($input, $velocity, 1);
    $velocity = unpack('C', $velocity);
    debug "velocity:$velocity" . "\n";
    
    RegisterNote($trackIndex, $midiChannel, $runningTime, $noteNumber);
    
    $supported = 1; # NOTE: Not really supported at this point.
  }
  elsif($eventType == 0xa)
  {
    # Note Aftertouch.
    my $noteNumber;
    if($runningStatus == 0)
    {
      read($input, $noteNumber, 1);
      $noteNumber = unpack('C', $noteNumber);
    }
    else
    {
      $noteNumber = $firstByte;
    }
    debug "noteNumber:$noteNumber" . "\n";
    
    my $amount;
    read($input, $amount, 1);
    $amount = unpack('C', $amount);
    debug "amount:$amount" . "\n";
    
    $supported = 1; # NOTE: Not really supported at this point.
  }
  elsif($eventType == 0xb)
  {
    # Controller.
    my $controllerType;
    if($runningStatus == 0)
    {
      read($input, $controllerType, 1);
      $controllerType = unpack('C', $controllerType);
    }
    else
    {
      $controllerType = $firstByte;
    }
    debug "controllerType:$controllerType" . "\n";
    
    my $value;
    read($input, $value, 1);
    $value = unpack('C', $value);
    debug "value:$value" . "\n";
    
    $supported = 1; # NOTE: Not really supported at this point.
  }
  elsif($eventType == 0xc)
  {
    # Program Change.
    $eventLength--; # Down 1 from base (default: 2).
    
    my $programNumber;
    if($runningStatus == 0)
    {
      read($input, $programNumber, 1);
      $programNumber = unpack('C', $programNumber);
    }
    else
    {
      $programNumber = $firstByte;
    }
    debug "programNumber:$programNumber" . "\n";
    
    $supported = 1; # NOTE: Not really supported at this point.
  }
  elsif($eventType == 0xd)
  {
    # Channel Aftertouch.
    $eventLength--; # Down 1 from base (default: 2).
    
    my $amount;
    if($runningStatus == 0)
    {
      read($input, $amount, 1);
      $amount = unpack('C', $amount);
    }
    else
    {
      $amount = $firstByte;
    }
    debug "amount:$amount" . "\n";
    
    $supported = 1; # NOTE: Not really supported at this point.
  }
  elsif($eventType == 0xe)
  {
    # Pitch Bend.
    my $valueLow;
    if($runningStatus == 0)
    {
      read($input, $valueLow, 1);
      $valueLow = unpack('C', $valueLow);
    }
    else
    {
      $valueLow = $firstByte;
    }
    debug "valueLow:$valueLow" . "\n";
    
    my $valueHigh;
    read($input, $valueHigh, 1);
    $valueHigh = unpack('C', $valueHigh);
    debug "valueHigh:$valueHigh" . "\n";
    
    $supported = 1; # NOTE: Not really supported at this point.
  }
  
  if($supported == 0)
  {
    # TODO: Change to use seek.
    my $temp;
    read($input, $temp, $eventLength);
  }
  
  my $numberOfBytes = $eventLength;
  return $numberOfBytes;
}

sub RegisterNote($$$$)
{
  my $trackIndex  = $_[0];
  my $midiChannel = $_[1];
  my $time        = $_[2];
  my $noteNumber  = $_[3];

  my $voiceKey = "$trackIndex.$midiChannel";
  
  $::VoiceDataHash{$voiceKey}{$time} = $noteNumber;
  
  return 0;
}

sub GetVoiceKeys($$)
{
  my ($voiceListRef, $completeVoiceDataHashRef) = @_;
  
  my @voiceList = @{$voiceListRef};
  my %completeVoiceDataHash = %{$completeVoiceDataHashRef};

  my @voiceKeyList = ();
  if(scalar(@VoiceList) == 0)
  {
    @voiceKeyList = sort SortTrackChannelPairs keys(%completeVoiceDataHash);
  }
  else
  {
    @voiceKeyList = @VoiceList;
  }
  
  return @voiceKeyList;
}

sub ProcessNote
{
  my $noteNumber       = shift;
  my $noteDuration     = shift;
  my $lastNoteDuration = shift;
  my $byteListRef      = shift;
  
  #print @byteList;
  
  if($noteNumber < 0)
  {
    $noteNumber = 0 | 0x40;
  }
  else
  {
    $noteNumber -= ($::NUMBER_OF_NOTES_IN_OCTAVE * 2);
    while($noteNumber < 0)
    {
      $noteNumber += $::NUMBER_OF_NOTES_IN_OCTAVE;
    }
  }
  
#     if($noteNumber >= 64)
#     {
#       output "\n" . ";BAD NOTE NUMBER: $noteNumber" . "\n";
#       $noteNumber &= 0xff;
#     }

  $noteDuration /= $::Gcd;
  $noteDuration = int($noteDuration * $::DurationScale);
  
  if(($noteDuration != $$lastNoteDuration) ||
      ($$lastNoteDuration > 255))
  {
    $$lastNoteDuration = $noteDuration;

    $noteNumber |= 0x80;
    
    my $d = $noteDuration;
    while($d > 255)
    {
      push(@{$byteListRef}, $noteNumber);
      push(@{$byteListRef}, 255);
      
      $d -= 255;
    }
    
    push(@{$byteListRef}, $noteNumber);
    push(@{$byteListRef}, $noteDuration % 255);
  }
  else
  {
    push(@{$byteListRef}, $noteNumber);
  }
  
  return 0;
}

sub ExtractTrackAndChannelFromPair
{
  my $input = shift;
  if($input =~ /\s*(\d+)\.(\d+)\s*/)
  {
    my $trackNumber = shift;
    my $channelNumber = shift;
    
    $$trackNumber = $1;
    $$channelNumber = $2;
    
    return 0;
  }
  
  return 1;
}

sub SortTrackChannelPairs
{
  my $aTrackNumber;
  my $aChannelNumber;
  my $aResult = ExtractTrackAndChannelFromPair($a, \$aTrackNumber, \$aChannelNumber);
  
  my $bTrackNumber;
  my $bChannelNumber;
  my $bResult = ExtractTrackAndChannelFromPair($b, \$bTrackNumber, \$bChannelNumber);
  
  if(($aResult != 0) || ($bResult != 0))
  {
    return $a cmp $b;
  }
  
  my $result;
  $result = $aTrackNumber <=> $bTrackNumber;
  if($result != 0)
  {
    return $result;
  }
  
  $result = $aChannelNumber <=> $bChannelNumber;
  if($result != 0)
  {
    return $result;
  }
  
  return 0;
}

sub GetAllTracksNoteDurationGcd($)
{
  my @voiceKeyList = @{$_[0]};
  
  my %durationHash = ();
    
  foreach my $voiceKey (@voiceKeyList)
  {
    if(!defined($::VoiceDataHash{$voiceKey}))
    {
      next;
    }
    
    my %voiceDataHash = %{$::VoiceDataHash{$voiceKey}};
    
    if(!defined($voiceDataHash{0}))
    {
      $voiceDataHash{0} = -1;
    }
    
    my @vTimeList = sort {$a <=> $b}(keys(%voiceDataHash));
    
    my $numberOfVTimes = scalar(@vTimeList);
    my $vTime;
    my $vTimeIndex = 0;
    for(; $vTimeIndex < $numberOfVTimes - 1; $vTimeIndex++)
    {
      $vTime = $vTimeList[$vTimeIndex];
      $noteDuration = $vTimeList[$vTimeIndex + 1] - $vTime;
      $durationHash{$noteDuration} = 1;
    }
    
    # Process last byte.
    $vTime = $vTimeList[$vTimeIndex - 1];
    $noteDuration = $vTime - $vTimeList[$vTimeIndex - 2];
    $durationHash{$noteDuration} = 1;
  }
  
  my @durationList = sort {$a <=> $b} keys(%durationHash);
#   foreach my $d (@durationList)
#   {
#     print $d . "\n";
#   }
#   print "+++" . "\n";
  
  my $lowestDuration = 0;
  my $numberOfDurations = scalar(@durationList);
  if($numberOfDurations > 0)
  {
    $lowestDuration = $durationList[0];
  }
  else
  {
    return 1;
  }
  
  if($lowestDuration == 0)
  {
    return 1;
  }
  
  my %gcdHash = ();
  
  for(my $di = 1; $di < $numberOfDurations; $di++)
  {
    $gcdHash{ Gcd($lowestDuration, $durationList[$di]) } = 1;
  }
  
  my @gcdList = keys(%gcdHash);
  my $numberOfGcds = scalar(@gcdList);
  if($numberOfGcds != 1)
  {
    return 1;
  }
  
  return $gcdList[0];
}

sub Gcd
{
  my ($a, $b) = @_;
  ($a,$b) = ($b,$a) if $a > $b;
  while ($a) {
    ($a, $b) = ($b % $a, $a);
  }
  return $b;
}

sub OutputMusicSourceBytes($$)
{
  my ($voiceIndex, $byteListRef) = @_;
  my @byteList = @{$byteListRef};
  
  debug "Outputing voice $voiceIndex." . "\n";
  
  #output "  .byte " . join("\n  .byte ", @byteList) . "\n";
  #output "  .byte " . join(", ", @byteList) . "\n";
  
  my $startLabel = "VOICE_$voiceIndex\_START_1";
  output ".export $startLabel" . "\n";
  output "$startLabel:" . "\n";
  #output "VOICE_$voiceIndex\_START_2" . "\n";
  #output "VOICE_$voiceIndex\_START_3" . "\n";
  
  my $nb = scalar(@byteList);
  while($nb > 0)
  {
    output "  .byte ";
  
    my $bpl = ($nb < 16) ? $nb : 16;
    for(my $i = 0; $i < $bpl; $i++)
    {
      my $b = shift @byteList;
      if($i > 0)
      {
        output ", ";
      }
      output $b;
    }
    
    output "\n";
  
    $nb = scalar(@byteList);
  }
  
  my $endLabel = "VOICE_$voiceIndex\_END_1";
  output ".export $endLabel" . "\n";
  output "$endLabel:" . "\n";
  
  #output "VOICE_$voiceIndex\_END_2" . "\n";
  output "  .byte 0" . "\n";
  output "\n";
  output ";=====================================================\n";
}

