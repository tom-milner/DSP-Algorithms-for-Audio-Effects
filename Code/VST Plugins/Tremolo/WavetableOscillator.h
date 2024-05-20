#include <juce_audio_basics/juce_audio_basics.h>

class WavetableOscillator {
 public:
  WavetableOscillator();

  void setFrequency(float freq, float sampleRate);
  float getNextSample();

 private:
  juce::AudioSampleBuffer wavetable;
  const int tableSize = 128;

  // How quickly to move through the table in order to get the desired
  // frequency.
  float tableDelta;

  // The currnt position in the wave table.
  float currentPos = 0;
  void generateSineSquaredTable();
};
