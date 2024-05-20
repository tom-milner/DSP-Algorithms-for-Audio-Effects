#include "PluginEditor.h"

#include "PluginProcessor.h"

//==============================================================================
TremoloAudioProcessorEditor::TremoloAudioProcessorEditor(
    TremoloAudioProcessor& p, juce::AudioProcessorValueTreeState& vts)
    : AudioProcessorEditor(&p), processorRef(p), processorState(vts) {
  juce::ignoreUnused(processorRef);
  // Make sure that before the constructor has finished, you've set the
  // editor's size to whatever you need it to be.
  setSize(400, 150);

  addAndMakeVisible(depthSlider.slider);
  addAndMakeVisible(depthSlider.label);

  addAndMakeVisible(speedSlider.slider);
  addAndMakeVisible(speedSlider.label);
}

TremoloAudioProcessorEditor::~TremoloAudioProcessorEditor() {}

//==============================================================================
void TremoloAudioProcessorEditor::paint(juce::Graphics& g) {
  // (Our component is opaque, so we must completely fill the background with a
  // solid colour)
  g.fillAll(
      getLookAndFeel().findColour(juce::ResizableWindow::backgroundColourId));

  g.setColour(juce::Colours::white);
  g.setFont(15.0f);
}

void TremoloAudioProcessorEditor::resized() {
  auto labelWidth = 100;
  auto sliderWidth = getWidth() - labelWidth;
  auto sliderHeight = 30;

  depthSlider.slider.setBounds(labelWidth, 0, sliderWidth, sliderHeight);
  speedSlider.slider.setBounds(labelWidth, sliderHeight, sliderWidth,
                               sliderHeight);
}
