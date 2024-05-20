#pragma once

#include <juce_audio_processors/juce_audio_processors.h>
#include <juce_dsp/juce_dsp.h>

#include "WavetableOscillator.h"

//==============================================================================
class TremoloAudioProcessor final
    : public juce::AudioProcessor,
      public juce::AudioProcessorValueTreeState::Listener {
 public:
  //==============================================================================
  TremoloAudioProcessor();
  ~TremoloAudioProcessor() override;

  //==============================================================================
  void prepareToPlay(double sampleRate, int samplesPerBlock) override;
  void releaseResources() override;

  bool isBusesLayoutSupported(const BusesLayout& layouts) const override;

  void processBlock(juce::AudioBuffer<float>&, juce::MidiBuffer&) override;
  using AudioProcessor::processBlock;

  //==============================================================================
  juce::AudioProcessorEditor* createEditor() override;
  bool hasEditor() const override;

  //==============================================================================
  const juce::String getName() const override;

  bool acceptsMidi() const override;
  bool producesMidi() const override;
  bool isMidiEffect() const override;
  double getTailLengthSeconds() const override;

  //==============================================================================
  int getNumPrograms() override;
  int getCurrentProgram() override;
  void setCurrentProgram(int index) override;
  const juce::String getProgramName(int index) override;
  void changeProgramName(int index, const juce::String& newName) override;

  //==============================================================================
  void getStateInformation(juce::MemoryBlock& destData) override;
  void setStateInformation(const void* data, int sizeInBytes) override;

 private:
  void parameterChanged(const juce::String& parameterID,
                        float newValue) override;

  juce::AudioProcessorValueTreeState parameters;
  std::atomic<float>* depthParam = nullptr;
  std::atomic<float>* speedParam = nullptr;

  juce::AudioProcessorValueTreeState::ParameterLayout createParameters();

  float sampleRate;

  WavetableOscillator trem;

  //==============================================================================
  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(TremoloAudioProcessor)
};
