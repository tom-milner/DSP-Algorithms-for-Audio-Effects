#pragma once

#include <juce_audio_processors/juce_audio_processors.h>

//==============================================================================
class DistortionAudioProcessor final : public juce::AudioProcessor {
 public:
  //==============================================================================
  DistortionAudioProcessor();
  ~DistortionAudioProcessor() override;

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
  juce::AudioProcessorValueTreeState parameters;
  std::atomic<float>* gainParam = nullptr;
  std::atomic<float>* rangeParam = nullptr;
  std::atomic<float>* mixParam = nullptr;
  std::atomic<float>* volumeParam = nullptr;

  juce::AudioProcessorValueTreeState::ParameterLayout createParameters();
  //==============================================================================
  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(DistortionAudioProcessor)
};
