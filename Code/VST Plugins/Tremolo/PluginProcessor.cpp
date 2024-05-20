#include "PluginProcessor.h"

#include <cmath>
#include <cstdio>

#include "Parameters.h"
#include "PluginEditor.h"

//==============================================================================
TremoloAudioProcessor::TremoloAudioProcessor()
    : AudioProcessor(
          BusesProperties()
#if !JucePlugin_IsMidiEffect
#if !JucePlugin_IsSynth
              .withInput("Input", juce::AudioChannelSet::stereo(), true)
#endif
              .withOutput("Output", juce::AudioChannelSet::stereo(), true)
#endif
              ),
      parameters(*this, nullptr, "PARAMETERS", createParameters()) {

  depthParam = parameters.getRawParameterValue(Parameters::TREM_DEPTH);
  speedParam = parameters.getRawParameterValue(Parameters::TREM_SPEED);

  parameters.addParameterListener(Parameters::TREM_SPEED, this);
}

TremoloAudioProcessor::~TremoloAudioProcessor() {}

//==============================================================================
const juce::String TremoloAudioProcessor::getName() const {
  return JucePlugin_Name;
}

bool TremoloAudioProcessor::acceptsMidi() const {
#if JucePlugin_WantsMidiInput
  return true;
#else
  return false;
#endif
}

bool TremoloAudioProcessor::producesMidi() const {
#if JucePlugin_ProducesMidiOutput
  return true;
#else
  return false;
#endif
}

bool TremoloAudioProcessor::isMidiEffect() const {
#if JucePlugin_IsMidiEffect
  return true;
#else
  return false;
#endif
}

double TremoloAudioProcessor::getTailLengthSeconds() const { return 0.0; }

int TremoloAudioProcessor::getNumPrograms() {
  return 1;  // NB: some hosts don't cope very well if you tell them there are 0
             // programs, so this should be at least 1, even if you're not
             // really implementing programs.
}

int TremoloAudioProcessor::getCurrentProgram() { return 0; }

void TremoloAudioProcessor::setCurrentProgram(int index) {
  juce::ignoreUnused(index);
}

const juce::String TremoloAudioProcessor::getProgramName(int index) {
  juce::ignoreUnused(index);
  return {};
}

void TremoloAudioProcessor::changeProgramName(int index,
                                              const juce::String& newName) {
  juce::ignoreUnused(index, newName);
}

//==============================================================================
void TremoloAudioProcessor::prepareToPlay(double sampleRate,
                                          int samplesPerBlock) {
  this->sampleRate = sampleRate;

  trem.setFrequency(*speedParam, sampleRate);

  std::cout << trem.getNextSample() << std::endl;
}

void TremoloAudioProcessor::releaseResources() {
  // When playback stops, you can use this as an opportunity to free up any
  // spare memory, etc.
}

bool TremoloAudioProcessor::isBusesLayoutSupported(
    const BusesLayout& layouts) const {
#if JucePlugin_IsMidiEffect
  juce::ignoreUnused(layouts);
  return true;
#else
  // This is the place where you check if the layout is supported.
  // In this template code we only support mono or stereo.
  // Some plugin hosts, such as certain GarageBand versions, will only
  // load plugins that support stereo bus layouts.
  if (layouts.getMainOutputChannelSet() != juce::AudioChannelSet::mono() &&
      layouts.getMainOutputChannelSet() != juce::AudioChannelSet::stereo())
    return false;

    // This checks if the input layout matches the output layout
#if !JucePlugin_IsSynth
  if (layouts.getMainOutputChannelSet() != layouts.getMainInputChannelSet())
    return false;
#endif

  return true;
#endif
}

void TremoloAudioProcessor::processBlock(juce::AudioBuffer<float>& buffer,
                                         juce::MidiBuffer& midiMessages) {
  juce::ignoreUnused(midiMessages);

  juce::ScopedNoDenormals noDenormals;
  auto totalNumInputChannels = getTotalNumInputChannels();
  auto totalNumOutputChannels = getTotalNumOutputChannels();
  auto numSamples = buffer.getNumSamples();

  // Clear samples in channels we're not using.
  for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
    buffer.clear(i, 0, buffer.getNumSamples());

  for (int i = 0; i < numSamples; i++) {
    float sin_value = trem.getNextSample();
    float modulation = (1 - *depthParam) + *depthParam * sin_value;

    // Modulate values in each channel (assuming channels have same number of
    // samples).
    for (int channel = 0; channel < totalNumInputChannels; ++channel) {
      auto* channelData = buffer.getWritePointer(channel);
      auto x = channelData[i];
      channelData[i] = x * modulation;
    }
  }
}

//==============================================================================
bool TremoloAudioProcessor::hasEditor() const {
  return true;  // (change this to false if you choose to not supply an
                // editor)
}

juce::AudioProcessorEditor* TremoloAudioProcessor::createEditor() {
  return new TremoloAudioProcessorEditor(*this, parameters);
}

//==============================================================================
void TremoloAudioProcessor::getStateInformation(juce::MemoryBlock& destData) {
  // You should use this method to store your parameters in the memory block.
  // You could do that either as raw data, or use the XML or ValueTree classes
  // as intermediaries to make it easy to save and load complex data.
  juce::ignoreUnused(destData);
}

void TremoloAudioProcessor::setStateInformation(const void* data,
                                                int sizeInBytes) {
  // You should use this method to restore your parameters from this memory
  // block, whose contents will have been created by the getStateInformation()
  // call.
  juce::ignoreUnused(data, sizeInBytes);
}

juce::AudioProcessorValueTreeState::ParameterLayout
TremoloAudioProcessor::createParameters() {
  juce::AudioProcessorValueTreeState::ParameterLayout params;

  params.add(std::make_unique<juce::AudioParameterFloat>(
      juce::ParameterID(Parameters::TREM_DEPTH, 1), "Depth", 0, 1, 0.5));

  params.add(std::make_unique<juce::AudioParameterFloat>(
      juce::ParameterID(Parameters::TREM_SPEED, 1), "Speed", 0, 20, 1));

  return params;
}

void TremoloAudioProcessor::parameterChanged(const juce::String& parameterID,
                                             float newValue) {
  if (parameterID == Parameters::TREM_SPEED) {
    trem.setFrequency(newValue, sampleRate);
  }
}

//==============================================================================
// This creates new instances of the plugin..
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter() {
  return new TremoloAudioProcessor();
}
