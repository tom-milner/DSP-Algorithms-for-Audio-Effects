#include "PluginEditor.h"

#include "PluginProcessor.h"

//==============================================================================
DelayPluginAudioProcessorEditor::DelayPluginAudioProcessorEditor(
    DelayPluginAudioProcessor& p, juce::AudioProcessorValueTreeState& vts)
    : AudioProcessorEditor(&p), processorRef(p), processorState(vts) {
  juce::ignoreUnused(processorRef);

  setSize(400, 100);

  // Delay Gain.
  delayGainSlider.setSliderStyle(juce::Slider::LinearHorizontal);
  addAndMakeVisible(delayGainSlider);

  // Delay Gain Label.
  delayGainLabel.setText("Delay Gain", juce::dontSendNotification);
  delayGainLabel.attachToComponent(&delayGainSlider, true);
  addAndMakeVisible(delayGainLabel);
  gainAttachment.reset(
      new SliderAttachment(processorState, "gain", delayGainSlider));

  // delay length slider.
  delayLengthSlider.setSliderStyle(juce::Slider::LinearHorizontal);
  addAndMakeVisible(delayLengthSlider);

  // delay length label.
  delayLengthLabel.setText("Delay Length (ms)", juce::dontSendNotification);
  delayLengthLabel.attachToComponent(&delayLengthSlider, true);
  addAndMakeVisible(delayLengthLabel);

  delayLengthAttachment.reset(
      new SliderAttachment(processorState, "delay_length", delayLengthSlider));
}

DelayPluginAudioProcessorEditor::~DelayPluginAudioProcessorEditor() {}

//==============================================================================
void DelayPluginAudioProcessorEditor::paint(juce::Graphics& g) {
  // (Our component is opaque, so we must completely fill the background with a
  // solid colour)
  g.fillAll(
      getLookAndFeel().findColour(juce::ResizableWindow::backgroundColourId));

  g.setColour(juce::Colours::white);
  g.setFont(15.0f);
}

void DelayPluginAudioProcessorEditor::resized() {
  auto labelWidth = 100;
  auto sliderWidth = getWidth() - labelWidth;
  auto sliderHeight = 30;

  delayGainSlider.setBounds(labelWidth, 0, sliderWidth, sliderHeight);
  delayLengthSlider.setBounds(labelWidth, sliderHeight, sliderWidth,
                              sliderHeight);
}
