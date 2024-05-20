#include "WavetableOscillator.h"

#include <math.h>

WavetableOscillator::WavetableOscillator() {
  // Create the wavetable.
  generateSineSquaredTable();
}

void WavetableOscillator::generateSineSquaredTable() {
  wavetable.setSize(1, (int)tableSize + 1);
  auto samples = wavetable.getWritePointer(0);
  auto angleDelta = juce::MathConstants<double>::pi / (double)(tableSize - 1);
  auto currentAngle = 0.0;
  for (int i = 0; i < tableSize; i++) {
    samples[i] = pow(std::sin(currentAngle), 2);
    currentAngle += angleDelta;
  }

  // To avoid doing a wrap around check when interpolating between the last and
  // first sample, append the first sample to the very end.
  samples[tableSize] = samples[0];
}

void WavetableOscillator::setFrequency(float frequency, float sampleRate) {
  // The increment that will do 1 cycle of the table in one second.
  auto oneCyclePerSecond = tableSize / sampleRate;

  // Scale it up to our frequency.
  tableDelta = frequency * oneCyclePerSecond;
}

float WavetableOscillator::getNextSample() {
  // Cast the current position into an index in the table.
  auto indexA = static_cast<unsigned int>(currentPos);
  auto indexB = indexA + 1;

  // Interpolate.
  float frac = currentPos - indexA;

  auto* table = wavetable.getReadPointer(0);
  float valA = table[indexA];
  float valB = table[indexB];

  float out = valA + frac * (valB - valA);

  // Wrap round the table if we have to.
  currentPos += tableDelta;
  if (currentPos > tableSize) currentPos -= tableSize;

  return out;
}