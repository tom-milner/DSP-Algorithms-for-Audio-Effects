#pragma once

#include <juce_audio_processors/juce_audio_processors.h>

typedef juce::AudioProcessorValueTreeState::SliderAttachment SliderAttachment;
class AttachedSlider {
 public:
  AttachedSlider(const juce::String& labelText, const juce::String& paramId,
                 juce::AudioProcessorValueTreeState& vts) {
    slider.setSliderStyle(juce::Slider::LinearHorizontal);
    label.setText(labelText, juce::dontSendNotification);
    label.attachToComponent(&slider, true);
    attachment.reset(new SliderAttachment(vts, paramId, slider));
  }

  juce::Slider slider;
  juce::Label label;
  std::unique_ptr<SliderAttachment> attachment;
};