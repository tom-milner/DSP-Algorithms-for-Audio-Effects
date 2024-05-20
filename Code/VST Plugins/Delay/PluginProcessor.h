#pragma once
#include <juce_audio_processors/juce_audio_processors.h>

//==============================================================================
class DelayPluginAudioProcessor final : public juce::AudioProcessor {
 public:
  //==============================================================================
  DelayPluginAudioProcessor();
  ~DelayPluginAudioProcessor() override;

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

  static constexpr float MAX_DELAY_LENGTH_MS = 400;

 private:
  juce::AudioBuffer<float> delayBuffer;
  int delayWritePosition;
  int delayBufferLength;

  juce::AudioProcessorValueTreeState parameters;
  std::atomic<float>* delayLengthParameter = nullptr;
  std::atomic<float>* gainParameter = nullptr;

  juce::AudioProcessorValueTreeState::ParameterLayout createParameters();

  //==============================================================================
  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(DelayPluginAudioProcessor)
};
