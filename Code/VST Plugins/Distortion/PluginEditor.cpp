#include "PluginEditor.h"

#include "PluginProcessor.h"

//==============================================================================
DistortionAudioProcessorEditor::DistortionAudioProcessorEditor(
    DistortionAudioProcessor& p, juce::AudioProcessorValueTreeState& vts)
    : AudioProcessorEditor(&p), processorRef(p), processorState(vts) {
  juce::ignoreUnused(processorRef);
  // Make sure that before the constructor has finished, you've set the
  // editor's size to whatever you need it to be.
  setSize(400, 150);

  setupSlider("Gain", "gain", gainSlider, gainLabel, gainAttachment);
  setupSlider("Range", "range", rangeSlider, rangeLabel, rangeAttachment);
  setupSlider("Volume", "volume", volumeSlider, volumeLabel, volumeAttachment);
  setupSlider("Mix", "mix", mixSlider, mixLabel, mixAttachment);
}

void DistortionAudioProcessorEditor::setupSlider(
    const juce::String& labelText, const juce::String& paramId,
    juce::Slider& slider, juce::Label& label,
    std::unique_ptr<SliderAttachment>& attachment) {
  slider.setSliderStyle(juce::Slider::LinearHorizontal);
  addAndMakeVisible(slider);

  label.setText(labelText, juce::dontSendNotification);
  label.attachToComponent(&slider, true);
  addAndMakeVisible(label);
  attachment.reset(new SliderAttachment(processorState, paramId, slider));
}

DistortionAudioProcessorEditor::~DistortionAudioProcessorEditor() {}

//==============================================================================
void DistortionAudioProcessorEditor::paint(juce::Graphics& g) {
  // (Our component is opaque, so we must completely fill the background with a
  // solid colour)
  g.fillAll(
      getLookAndFeel().findColour(juce::ResizableWindow::backgroundColourId));

  g.setColour(juce::Colours::white);
  g.setFont(15.0f);
}

void DistortionAudioProcessorEditor::resized() {
  auto labelWidth = 100;
  auto sliderWidth = getWidth() - labelWidth;
  auto sliderHeight = 30;

  gainSlider.setBounds(labelWidth, 0, sliderWidth, sliderHeight);
  rangeSlider.setBounds(labelWidth, sliderHeight, sliderWidth, sliderHeight);
  volumeSlider.setBounds(labelWidth, 2 * sliderHeight, sliderWidth,
                         sliderHeight);
  mixSlider.setBounds(labelWidth, 3 * sliderHeight, sliderWidth, sliderHeight);
}
