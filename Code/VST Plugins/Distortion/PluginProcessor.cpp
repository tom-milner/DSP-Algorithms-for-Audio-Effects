#include "PluginProcessor.h"

#include <cmath>

#include "PluginEditor.h"

//==============================================================================
DistortionAudioProcessor::DistortionAudioProcessor()
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

  gainParam = parameters.getRawParameterValue("gain");
  rangeParam = parameters.getRawParameterValue("range");
  volumeParam = parameters.getRawParameterValue("volume");
  mixParam = parameters.getRawParameterValue("mix");
}

DistortionAudioProcessor::~DistortionAudioProcessor() {}

//==============================================================================
const juce::String DistortionAudioProcessor::getName() const {
  return JucePlugin_Name;
}

bool DistortionAudioProcessor::acceptsMidi() const {
#if JucePlugin_WantsMidiInput
  return true;
#else
  return false;
#endif
}

bool DistortionAudioProcessor::producesMidi() const {
#if JucePlugin_ProducesMidiOutput
  return true;
#else
  return false;
#endif
}

bool DistortionAudioProcessor::isMidiEffect() const {
#if JucePlugin_IsMidiEffect
  return true;
#else
  return false;
#endif
}

double DistortionAudioProcessor::getTailLengthSeconds() const { return 0.0; }

int DistortionAudioProcessor::getNumPrograms() {
  return 1;  // NB: some hosts don't cope very well if you tell them there are 0
             // programs, so this should be at least 1, even if you're not
             // really implementing programs.
}

int DistortionAudioProcessor::getCurrentProgram() { return 0; }

void DistortionAudioProcessor::setCurrentProgram(int index) {
  juce::ignoreUnused(index);
}

const juce::String DistortionAudioProcessor::getProgramName(int index) {
  juce::ignoreUnused(index);
  return {};
}

void DistortionAudioProcessor::changeProgramName(int index,
                                                 const juce::String& newName) {
  juce::ignoreUnused(index, newName);
}

//==============================================================================
void DistortionAudioProcessor::prepareToPlay(double sampleRate,
                                             int samplesPerBlock) {
  // Use this method as the place to do any pre-playback
  // initialisation that you need..
  juce::ignoreUnused(sampleRate, samplesPerBlock);
}

void DistortionAudioProcessor::releaseResources() {
  // When playback stops, you can use this as an opportunity to free up any
  // spare memory, etc.
}

bool DistortionAudioProcessor::isBusesLayoutSupported(
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

void DistortionAudioProcessor::processBlock(juce::AudioBuffer<float>& buffer,
                                            juce::MidiBuffer& midiMessages) {
  juce::ignoreUnused(midiMessages);

  juce::ScopedNoDenormals noDenormals;
  auto totalNumInputChannels = getTotalNumInputChannels();
  auto totalNumOutputChannels = getTotalNumOutputChannels();
  auto numSamples = buffer.getNumSamples();

  for (int channel = 0; channel < totalNumInputChannels; ++channel) {
    auto* channelData = buffer.getWritePointer(channel);

    /*
     Distortion Formula:
      t(n) = x/|x| (AKA -ign(x))
      y(n) = t(n)*(1-e^(-r*g*|x|)
    */

    for (int i = 0; i < numSamples; i++) {
      auto x = channelData[i];

      auto t = (0 <= x) - (x < 0);  // Get the sign of x.

      auto z = t * (1 - exp(-*rangeParam * *gainParam * t * x));
      //   Formula.

      // Mix.
      auto wet = (z * *mixParam);
      auto dry = (x * (1 - *mixParam));
      auto y = wet + dry;

      // Apply volume.
      y *= *volumeParam;

      channelData[i] = y;
    }
  }

  // Clear samples in channels we're not using.
  for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
    buffer.clear(i, 0, buffer.getNumSamples());
}

//==============================================================================
bool DistortionAudioProcessor::hasEditor() const {
  return true;  // (change this to false if you choose to not supply an editor)
}

juce::AudioProcessorEditor* DistortionAudioProcessor::createEditor() {
  return new DistortionAudioProcessorEditor(*this, parameters);
}

//==============================================================================
void DistortionAudioProcessor::getStateInformation(
    juce::MemoryBlock& destData) {
  // You should use this method to store your parameters in the memory block.
  // You could do that either as raw data, or use the XML or ValueTree classes
  // as intermediaries to make it easy to save and load complex data.
  juce::ignoreUnused(destData);
}

void DistortionAudioProcessor::setStateInformation(const void* data,
                                                   int sizeInBytes) {
  // You should use this method to restore your parameters from this memory
  // block, whose contents will have been created by the getStateInformation()
  // call.
  juce::ignoreUnused(data, sizeInBytes);
}

juce::AudioProcessorValueTreeState::ParameterLayout
DistortionAudioProcessor::createParameters() {
  juce::AudioProcessorValueTreeState::ParameterLayout params;

  juce::NormalisableRange<float> range(0, 50, 1);
  range.skew = 0.5;

  params.add(std::make_unique<juce::AudioParameterFloat>(
      juce::ParameterID("range", 1), "Range", range, 5));

  params.add(std::make_unique<juce::AudioParameterFloat>(
      juce::ParameterID("gain", 1), "Gain", 0, 1, 1));

  juce::NormalisableRange<float> volume(0, 2, 0.01f);
  volume.skew = 0.5;
  params.add(std::make_unique<juce::AudioParameterFloat>(
      juce::ParameterID("volume", 1), "Volume", volume, 1));

  params.add(std::make_unique<juce::AudioParameterFloat>(
      juce::ParameterID("mix", 1), "Mix", 0, 1, 1));

  return params;
}

//==============================================================================
// This creates new instances of the plugin..
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter() {
  return new DistortionAudioProcessor();
}
