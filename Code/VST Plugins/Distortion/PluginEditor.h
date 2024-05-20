#pragma once

#include "PluginProcessor.h"

typedef juce::AudioProcessorValueTreeState::SliderAttachment SliderAttachment;

//==============================================================================
class DistortionAudioProcessorEditor final : public juce::AudioProcessorEditor {
 public:
  explicit DistortionAudioProcessorEditor(DistortionAudioProcessor&,
                                          juce::AudioProcessorValueTreeState&);
  ~DistortionAudioProcessorEditor() override;

  //==============================================================================
  void paint(juce::Graphics&) override;
  void resized() override;

 private:
  // This reference is provided as a quick way for your editor to
  // access the processor object that created it.
  DistortionAudioProcessor& processorRef;
  juce::AudioProcessorValueTreeState& processorState;

  juce::Slider gainSlider;
  juce::Label gainLabel;
  std::unique_ptr<SliderAttachment> gainAttachment;

  juce::Slider rangeSlider;
  juce::Label rangeLabel;
  std::unique_ptr<SliderAttachment> rangeAttachment;

  juce::Slider volumeSlider;
  juce::Label volumeLabel;
  std::unique_ptr<SliderAttachment> volumeAttachment;

  juce::Slider mixSlider;
  juce::Label mixLabel;
  std::unique_ptr<SliderAttachment> mixAttachment;

  void setupSlider(const juce::String& labelText, const juce::String& paramId,
                   juce::Slider& slider, juce::Label& label,
                   std::unique_ptr<SliderAttachment>& attachment);

  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(DistortionAudioProcessorEditor)
};
