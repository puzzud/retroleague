#!/usr/bin/perl -w

use Getopt::Long;

no warnings 'redefine';

sub Main();

# Mapping routines.
sub BuildMappingFromParameter;
sub BuildMappingFromMapFile;
sub GetByteHashFromBytes;
sub GetBytesFromMapFile;
sub GetBytesFromLine($);
sub EvaluateBytes;
sub EvaluateByte;
sub RemapMappings;
sub SaveMapFromParameter;
sub SaveMap;

# Character data routines.
sub MergeCharacterDataFromFile;
sub CopySingleCharacterData;
sub LoadCharacterDataFromParameter;
sub LoadCharacterDataFromFile;
sub SaveCharacterData;

# Misc. routines.
sub Trim;

# Execution.
#perl merge_chr.pl -t=nes -m=map1.map map2.map -c=chr1.chr chr2.chr -mo=map1.map map2b.map -co=chr3.chr
exit Main();

#--------------------------------------------------------------------
# Main
#--------------------------------------------------------------------
sub Main()
{
  my $result = 1;

  my
  (
    $characterFileType,
    @mapFileNameList,
    @characterFileNameList,
    @outputMapFileNameList,
    $outputCharacterFileName,
    @preserveMapFileNameList
  );
  
  GetOptions
  (
    "t=s"     => \$characterFileType,
    "m=s{2}"  => \@mapFileNameList,
    "c=s{2}"  => \@characterFileNameList,
    "mo=s{2}" => \@outputMapFileNameList,
    "co=s"    => \$outputCharacterFileName,
    "pm=s"    => \@preserveMapFileNameList
  );
  
  my
  (
    $primaryMapFileName,
    %primaryByteHash,
    @primaryCharacterData,
    
    $secondaryMapFileName,
    %secondaryByteHash,
    @secondaryCharacterData,
  );
  
  # Read in mapping files.
  $result = BuildMappingFromParameter(0, \@mapFileNameList, \%primaryByteHash);
  if($result != 0)
  {
    return $result;
  }
  
  $result = BuildMappingFromParameter(1, \@mapFileNameList, \%secondaryByteHash);
  if($result != 0)
  {
    return $result;
  }
  
  # Update the secondary map to fill the space not used by the primary map.
  # TODO: Get last parameter from @preserveMapFileNameList.
  $result = RemapMappings(\%primaryByteHash, \%secondaryByteHash, 1);
  if($result != 0)
  {
    return $result;
  }
  
  # Save remapped mapping file.
  $result = SaveMapFromParameter(1, \@mapFileNameList, \%secondaryByteHash, \@outputMapFileNameList);
  if($result != 0)
  {
    return $result;
  }
  
  # Read character data files.
  $result = LoadCharacterDataFromParameter(0, \@characterFileNameList, \@primaryCharacterData);
  if($result != 0)
  {
    return $result;
  }
  
  $result = LoadCharacterDataFromParameter(1, \@characterFileNameList, \@secondaryCharacterData);
  if($result != 0)
  {
    return $result;
  }
  
  # Merge secondary character data into primary,
  # but with a copy of the primary--a working copy.
  my @workingCharacterData = @primaryCharacterData;
  $result = MergeCharacterDataFromFile(\%secondaryByteHash, \@secondaryCharacterData, \@workingCharacterData, $characterFileType);
  if($result != 0)
  {
    return $result;
  }
  
  # Save merged character data file.
  if(!defined($outputCharacterFileName))
  {
    $outputCharacterFileName = "merge.chr";
  }
  
  $result = SaveCharacterData($outputCharacterFileName, \@workingCharacterData, $characterFileType);
  
  return 0;
}

#--------------------------------------------------------------------
# BuildMappingFromParameter
#--------------------------------------------------------------------
sub BuildMappingFromParameter
{
  my
  (
    $mapIndex,
    $mapFileNameListRef,
    $byteHashRef
  ) = @_;
  
  my $mapFileName = ${$mapFileNameListRef}[$mapIndex];
  if(!defined($mapFileName))
  {
    print "Error: Map $mapIndex (map file) should be provided." . "\n";
    return 1;
  }

  my $result = BuildMappingFromMapFile($mapFileName, $byteHashRef);
  if($result != 0)
  {
    print "Error: Did not successfully read map file '$mapFileName'." . "\n";
    return $result;
  }
  
  return 0;
}

#--------------------------------------------------------------------
# BuildMappingFromMapFile
#--------------------------------------------------------------------
sub BuildMappingFromMapFile
{
  my
  (
    $mapFileName,
    $byteHashRef
  ) = @_;
  
  print "Building mapping for $mapFileName." . "\n";
  
  my
  (
    $result,
    
    @bytes
  );
  
  $result = GetBytesFromMapFile($mapFileName, \@bytes);
  if($result != 0)
  {
    return $result;
  }
  
  $result = GetByteHashFromBytes(\@bytes, $byteHashRef);
  if($result != 0)
  {
    return $result;
  }

  return 0;
}

#--------------------------------------------------------------------
# GetByteHashFromBytes
#
# Populate a hash out of a of bytes where hash values are
# the same as the key.
#--------------------------------------------------------------------
sub GetByteHashFromBytes
{
  my
  (
    $bytesRef,
    $byteHashRef
  ) = @_;
  
  # found in this file.
  %{$byteHashRef} = ();
  
  foreach my $byte (@{$bytesRef})
  {
    $$byteHashRef{$byte} = $byte;
  }

  return 0;
}

#--------------------------------------------------------------------
# GetBytesFromMapFile
#--------------------------------------------------------------------
sub GetBytesFromMapFile
{
  my
  (
    $mapFileName,
    $bytesRef
  ) = @_;
  
  unless(open FILE, "<", $mapFileName)
  {
    print "Failed to open map file: $mapFileName." . "\n";
    return 1;
  }
  
  my
  (
    $line,
    $lineNumber
  );
  
  @{$bytesRef} = ();
  
  $lineNumber = 0;
  while($line = <FILE>)
  {
    if($line =~ m/^\s*[\.\!]+byte\s*(.*)$/i)
    {
      my $byteSequenceLine = $1;
      push(@{$bytesRef}, GetBytesFromLine($byteSequenceLine));
    }
    else
    {
      print "Skipping line:  $lineNumber" . "\n";
    }
    
    ++$lineNumber;
  }

  close(FILE);
  
  return 0;
}

#--------------------------------------------------------------------
# GetBytesFromLine
#--------------------------------------------------------------------
sub GetBytesFromLine($)
{
  my $byteSequenceLine = Trim($_[0]);
  
  my @bytes = ();
  my $byte;
  
  my $commaIndex;
  my $lastTokenCharIndex;
  do
  {
    # Reset this value in case it does not get set during loop.
    $lastTokenCharIndex = length($byteSequenceLine) - 1;
  
    $commaIndex = index($byteSequenceLine, ',');
  
    my $singleQuoteIndex1 = index($byteSequenceLine, '\'');
    if($singleQuoteIndex1 > -1 &&
       ($commaIndex < 0 || $commaIndex > $singleQuoteIndex1))
    {
      # Handle single quoted data.
      my $singleQuoteIndex2 = index($byteSequenceLine, '\'', $singleQuoteIndex1 + 1);
      if($singleQuoteIndex2 > -1)
      {
        my $backSlashIndex = index($byteSequenceLine, '\\', $singleQuoteIndex1);
        if($backSlashIndex > 0 && $backSlashIndex < $singleQuoteIndex2)
        {
          # Handle escaped characters (including a single quote).
          $singleQuoteIndex2 = index($byteSequenceLine, '\'', $backSlashIndex + 2);
        }
      
        $byte = Trim(substr($byteSequenceLine, $singleQuoteIndex1, $singleQuoteIndex2 - $singleQuoteIndex1 + 1));
        push(@bytes, $byte);
        
        $lastTokenCharIndex = $singleQuoteIndex2;
      }
    }
    else
    {
      # Handle other data (decimals, hex, labels?).
      if($commaIndex > -1)
      {
        $byte = Trim(substr($byteSequenceLine, 0, $commaIndex));
        $lastTokenCharIndex = $commaIndex;
      }
      else
      {
        $lastTokenCharIndex = length($byteSequenceLine);
      
        $byte = Trim(substr($byteSequenceLine, 0, $lastTokenCharIndex));
        $lastTokenCharIndex--;
      }
      
      push(@bytes, $byte);
    }
    
    # Remove byte token prefix from byte line string.
    $commaIndex = index($byteSequenceLine, ',', $lastTokenCharIndex);
    if($commaIndex > -1)
    {
      $byteSequenceLine = substr($byteSequenceLine, $commaIndex + 1);
    }
    else
    {
      $byteSequenceLine = substr($byteSequenceLine, $lastTokenCharIndex + 1);
    }
  }
  while($commaIndex > -1);
  
  EvaluateBytes(\@bytes);
  
  return @bytes;
}

#--------------------------------------------------------------------
# EvaluateBytes
#
# Convert an array of strings to their individual actual byte values.
#--------------------------------------------------------------------
sub EvaluateBytes
{
  my
  (
    $bytesRef
  ) = @_;

  my $numberOfBytes = scalar(@${bytesRef});
  
  my $index;
  for($index = 0; $index < $numberOfBytes; ++$index)
  {
    $$bytesRef[$index] = EvaluateByte($$bytesRef[$index]);
  }
}

#--------------------------------------------------------------------
# EvaluateByte
#
# Convert a string to its actual byte value.
#--------------------------------------------------------------------
sub EvaluateByte
{
  my
  (
    $byte
  ) = @_;
  
  if($byte =~ m/^\$(.*)$/i)
  {
    $byte = hex($1);
  }
  elsif($byte =~ m/^'(.*)'$/i)
  {
    $byte = $1;
    if($byte =~ m/^(\\.*)$/i)
    {
      # Character is escaped.
      $byte = eval("'$1'");
    }
    
    $byte = ord($byte);
  }
  elsif($byte =~ m/^(\w+)$/i)
  {
    $byte = $1;
    print "Error: Found label '$byte' as byte. Not supported." . "\n";
    
    $byte = 0;
  }
  
  $byte &= 0xff;
  
  return $byte;
}

#--------------------------------------------------------------------
# RemapMappings
#
# Take two mappings (byte hashes) and remap them to fill the first
# available spaces sequentially from 1 (0 is reserved).
#
# inputs:
#   - primaryByteHashRef:      Reference to first mapping.
#   - secondaryByteHashRef:    Reference to second mapping.
#   - preservePrimaryMapping:  Boolean to indicate to not remap
#                              the primary mapping.
#--------------------------------------------------------------------
sub RemapMappings
{
  my
  (
    $primaryByteHashRef,
    $secondaryByteHashRef,
    $preservePrimaryMapping
  ) = @_;
  
  print "Remapping map files." . "\n";
  
  if($preservePrimaryMapping != 1)
  {
    print "Error: Remapping both primary and secondary map files is not supported." . "\n";
    return 2;
  }
  
  my @sortedPrimaryBytes   = sort {$a <=> $b} keys(%{$primaryByteHashRef});
  my @sortedSecondaryBytes = sort {$a <=> $b} keys(%{$secondaryByteHashRef});
  
  my $numberOfSourceBytes = scalar(@sortedSecondaryBytes);
  
  my $mergeIndex = 1; # NOTE: Index 0 is preserved.
  my $sourceIndex;
  for($sourceIndex = 0; $sourceIndex < $numberOfSourceBytes; ++$sourceIndex)
  {
    while(defined(${$primaryByteHashRef}{$mergeIndex}))
    {
      ++$mergeIndex;
    }
    
    if($mergeIndex > 255)
    {
      print "Error: Output mapping goes beyond 255 characters.";
      return 1;
    }
    
    # Update the source's mapping for this byte.
    my $byte = $sortedSecondaryBytes[$sourceIndex];
    ${$secondaryByteHashRef}{$byte} = $mergeIndex;
    
    ++$mergeIndex;
  }
  
  return 0;
}

#--------------------------------------------------------------------
# SaveMapFromParameter
#--------------------------------------------------------------------
sub SaveMapFromParameter
{
  my
  (
    $mapIndex,
    $mapFileNameListRef,
    $byteHashRef,
    $outputMapFileNameListRef
  ) = @_;
  
  my $inputMapFileName = ${$mapFileNameListRef}[$mapIndex];
  if(!defined($inputMapFileName))
  {
    return 1;
  }
  
  my $outputMapFileName = ${$outputMapFileNameListRef}[$mapIndex];
  if(!defined($outputMapFileName))
  {
    print "Error: Map 1 (output map file) should be provided." . "\n";
    return 2;
  }
  
  my @inputBytes;
  my $result = GetBytesFromMapFile($inputMapFileName, \@inputBytes);
  if($result != 0)
  {
    return $result;
  }
  
  my @outputBytes = ();
  my $byte;
  my $numberOfInputBytes = scalar(@inputBytes);
  my $index;
  for($index = 0; $index < $numberOfInputBytes; ++$index)
  {
    push(@outputBytes, ${$byteHashRef}{$inputBytes[$index]});
  }
  
  return SaveMap($outputMapFileName, \@outputBytes);
}

#--------------------------------------------------------------------
# SaveMap
#--------------------------------------------------------------------
sub SaveMap
{
  my
  (
    $outputMapFileName,
    $bytesRef
  ) = @_;
  
  print "Saving updated map data to $outputMapFileName" . "\n";
  
  my $file;
  
  unless(open $file, ">", "$outputMapFileName")
  {
    print "Failed to create and open map file: $outputMapFileName." . "\n";
    return 1;
  }
  
  my $byte;
  foreach my $byte (@{$bytesRef})
  {
    $byte = lc(sprintf("\$%X", $byte));
  
    print $file "  .byte $byte" . "\n";
  }
  
  close $file;
  
  return 0;
}

#--------------------------------------------------------------------
# LoadCharacterDataFromParameter
#--------------------------------------------------------------------
sub LoadCharacterDataFromParameter
{
  my
  (
    $characterIndex,
    $characterFileNameListRef,
    $characterDataRef
  ) = @_;
  
  my $characterFileName = ${$characterFileNameListRef}[$characterIndex];
  if(!defined($characterFileName))
  {
    print "Error: Character $characterIndex (character data file) should be provided." . "\n";
  
    return 2;
  }
  
  $result = LoadCharacterDataFromFile($characterFileName, $characterDataRef);
  if($result != 0)
  {
    return $result;
  }
  
  return 0;
}

#--------------------------------------------------------------------
# LoadCharacterDataFromFile
#--------------------------------------------------------------------
sub LoadCharacterDataFromFile
{
  my
  (
    $characterFileName,
    $characterDataRef
  ) = @_;
  
  print "Loading character data from $characterFileName" . "\n";
  
  my $file;
  
  unless(open $file, "<:raw", "$characterFileName")
  {
    print "Failed to open character file: $characterFileName." . "\n";
    return 1;
  }
  
  my $byte;
  my $bytesRead;
  do
  {
    $bytesRead = read($file, $byte, 1);
    if(!defined(eof))
    {
      $bytesRead = 0;
    }
      
    if($bytesRead > 0)
    {
      $byte = unpack('C', $byte);
      
      push(@{$characterDataRef}, $byte);
    }
  }
  while($bytesRead > 0);
  
  close $file;

  return 0;
}

#--------------------------------------------------------------------
# SaveCharacterData
#--------------------------------------------------------------------
sub SaveCharacterData
{
  my
  (
    $characterFileName,
    $characterDataRef,
    $characterFileType
  ) = @_;
  
  print "Saving character data to $characterFileName" . "\n";
  
  my $file;
  
  unless(open $file, ">:raw", "$characterFileName")
  {
    print "Failed to create and open character file: $characterFileName." . "\n";
    return 1;
  }
  
  my $byte;
  foreach my $byte (@{$characterDataRef})
  {
    print $file pack('C', $byte);
  }
  
  close $file;

  return 0;
}

#--------------------------------------------------------------------
# MergeCharacterDataFromFile
#--------------------------------------------------------------------
sub MergeCharacterDataFromFile
{
  my
  (
    $sourceByteHashRef,
    $sourceCharacterDataRef,
    $destinationCharacterDataRef,
    $characterFileType
  ) = @_;
  
  my $result;
  
  my @sortedSourceBytes = sort {$a <=> $b} keys(%{$sourceByteHashRef});
  foreach my $byte (@sortedSourceBytes)
  {
    $result = CopySingleCharacterData($byte, ${$sourceByteHashRef}{$byte},
                                      $sourceCharacterDataRef, $destinationCharacterDataRef,
                                      $characterFileType);
    if($result != 0)
    {
      print "Error: Encountered a problem when copying character data." . "\n";
      return $result;
    }
  }
  
  return 0;
}

#--------------------------------------------------------------------
# CopySingleCharacterData
#--------------------------------------------------------------------
sub CopySingleCharacterData
{
  my
  (
    $sourceCharacterIndex,
    $destinationCharacterIndex,
    $sourceCharacterDataRef,
    $destinationCharacterDataRef,
    $characterFileType
  ) = @_;
  
  my $bytesPerCharacter = 0;
  
  if($characterFileType eq "nes")
  {
    # NES
    $bytesPerCharacter = 16;
  }
  elsif($characterFileType eq "c64")
  {
    # C64
    $bytesPerCharacter = 8;
  }
  
  if($bytesPerCharacter < 1)
  {
    return 1;
  }
  
  my $sourceDataOffset      = $sourceCharacterIndex * $bytesPerCharacter;
  my $destinationDataOffset = $destinationCharacterIndex * $bytesPerCharacter;
  
  # TODO: Error if out of boundes.
  
  my $index;
  for($index = 0; $index < $bytesPerCharacter; ++$index)
  {
    ${$destinationCharacterDataRef}[$destinationDataOffset + $index] =
      ${$sourceCharacterDataRef}[$sourceDataOffset + $index];
  }

  return 0;
}

#--------------------------------------------------------------------
# Trim
#--------------------------------------------------------------------
sub Trim
{
  my $s = shift;
  $s =~ s/^\s+|\s+$//g;
  
  return $s
}
