#pragma once

#include "PluginProcessor.h"

typedef juce::AudioProcessorValueTreeState::SliderAttachment SliderAttachment;

//==============================================================================
class DelayPluginAudioProcessorEditor final
    : public juce::AudioProcessorEditor {
 public:
  explicit DelayPluginAudioProcessorEditor(DelayPluginAudioProcessor&,
                                           juce::AudioProcessorValueTreeState&);
  ~DelayPluginAudioProcessorEditor() override;

  //==============================================================================
  void paint(juce::Graphics&) override;
  void resized() override;

 private:
  // This reference is provided as a quick way for your editor to
  // access the processor object that created it.
  DelayPluginAudioProcessor& processorRef;

  juce::AudioProcessorValueTreeState& processorState;

  // Components.
  juce::Slider delayGainSlider;
  juce::Label delayGainLabel;

  juce::Slider delayLengthSlider;
  juce::Label delayLengthLabel;

  std::unique_ptr<SliderAttachment> delayLengthAttachment;
  std::unique_ptr<SliderAttachment> gainAttachment;

  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(DelayPluginAudioProcessorEditor)
};
