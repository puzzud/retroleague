using namespace std;

#include <iostream>
#include <string>

#define NUMBER_OF_PITCH_FREQUENCIES    72

double pitchFrequencies[] =
{
  32.70, // C-1
  34.65,
  36.71,
  38.89,
  41.20,
  43.65,
  46.25,
  49.00,
  51.91,
  55.00,
  58.27,
  61.74,
  65.41,
  69.30,
  73.42,
  77.78,
  82.41,
  87.31,
  92.50,
  98.00,
  103.83,
  110.00,
  116.54,
  123.47,
  130.81,
  138.59,
  146.83,
  155.56,
  164.81,
  174.61,
  185.00,
  196.00,
  207.65,
  220.00,
  233.08,
  246.94,
  261.63,
  277.18,
  293.66,
  311.13,
  329.63,
  349.23,
  369.99,
  392.00,
  415.30,
  440.00,
  466.16,
  493.88,
  523.25,
  554.37,
  587.33,
  622.25,
  659.25,
  698.46,
  739.99,
  783.99,
  830.61,
  880.00,
  932.33,
  987.77,
  1046.50,
  1108.73,
  1174.66,
  1244.51,
  1318.51,
  1396.91,
  1479.98,
  1567.98,
  1661.22,
  1760.00,
  1864.66,
  1975.53  // B-6
};

#define NUMBER_OF_NOTES    12

const char* noteLabelNames[12] =
{
  "C ",
  "CS",
  "D ",
  "DS",
  "E ",
  "F ",
  "FS",
  "G ",
  "GS",
  "A ",
  "AS",
  "B "
};

const char* noteNames[12] =
{
  "C",
  "C#",
  "D",
  "D#",
  "E",
  "F",
  "F#",
  "G",
  "G#",
  "A",
  "A#",
  "B"
};

//#define TARGET_C64
#define TARGET_NES

int main()
{
  for(int i = 0; i < NUMBER_OF_PITCH_FREQUENCIES; ++i)
  {
    int octaveIndex = (i / NUMBER_OF_NOTES) + 1;
    int noteIndex   = i % NUMBER_OF_NOTES;

    double pitchFrequency = pitchFrequencies[i];

    int noteWordValue = 0;

    #if defined(TARGET_NES)
    const double ntscFrequency = 1789773.0;

    int timingWord = int((ntscFrequency / (16.0 * pitchFrequency) ) - 1);

    noteWordValue = timingWord;
    #endif

    #if defined(TARGET_C64)
    double const ntscPhi = 1022727.0; // This is for machines with 6567R8 VIC. 6567R56A is slightly different.
    double const constant = (256.0 * 256.0 * 256.0) / ntscPhi;
    
    int sidFrequency = int(constant * pitchFrequency);

    noteWordValue = sidFrequency;
    #endif

    cout << "NOTE_FREQ_" << octaveIndex << "_" << noteLabelNames[noteIndex] << " = " << noteWordValue << " ; " << noteNames[noteIndex] << "-" << octaveIndex << endl;
  }

  return 0;
}
