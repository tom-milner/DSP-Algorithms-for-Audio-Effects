#pragma once

#include "AttachedSlider.h"
#include "PluginProcessor.h"

//==============================================================================
class TremoloAudioProcessorEditor final : public juce::AudioProcessorEditor {
 public:
  explicit TremoloAudioProcessorEditor(TremoloAudioProcessor&,
                                       juce::AudioProcessorValueTreeState&);
  ~TremoloAudioProcessorEditor() override;

  //==============================================================================
  void paint(juce::Graphics&) override;
  void resized() override;

 private:
  // This reference is provided as a quick way for your editor to
  // access the processor object that created it.
  TremoloAudioProcessor& processorRef;
  juce::AudioProcessorValueTreeState& processorState;

  AttachedSlider depthSlider{"Depth", "depth", processorState};
  AttachedSlider speedSlider{"Speed", "speed", processorState};

  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(TremoloAudioProcessorEditor)
};
