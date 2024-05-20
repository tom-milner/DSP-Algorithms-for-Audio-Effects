#include "PluginProcessor.h"

#include "PluginEditor.h"

//==============================================================================
DelayPluginAudioProcessor::DelayPluginAudioProcessor()
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

  delayLengthParameter = parameters.getRawParameterValue("delay_length");
  gainParameter = parameters.getRawParameterValue("gain");
}

DelayPluginAudioProcessor::~DelayPluginAudioProcessor() {}

//==============================================================================
const juce::String DelayPluginAudioProcessor::getName() const {
  return JucePlugin_Name;
}

bool DelayPluginAudioProcessor::acceptsMidi() const {
#if JucePlugin_WantsMidiInput
  return true;
#else
  return false;
#endif
}

bool DelayPluginAudioProcessor::producesMidi() const {
#if JucePlugin_ProducesMidiOutput
  return true;
#else
  return false;
#endif
}

bool DelayPluginAudioProcessor::isMidiEffect() const {
#if JucePlugin_IsMidiEffect
  return true;
#else
  return false;
#endif
}

double DelayPluginAudioProcessor::getTailLengthSeconds() const { return 0.0; }

int DelayPluginAudioProcessor::getNumPrograms() {
  return 1;  // NB: some hosts don't cope very well if you tell them there are 0
             // programs, so this should be at least 1, even if you're not
             // really implementing programs.
}

int DelayPluginAudioProcessor::getCurrentProgram() { return 0; }

void DelayPluginAudioProcessor::setCurrentProgram(int index) {
  juce::ignoreUnused(index);
}

const juce::String DelayPluginAudioProcessor::getProgramName(int index) {
  juce::ignoreUnused(index);
  return {};
}

void DelayPluginAudioProcessor::changeProgramName(int index,
                                                  const juce::String& newName) {
  juce::ignoreUnused(index, newName);
}

//==============================================================================
void DelayPluginAudioProcessor::prepareToPlay(double sampleRate,
                                              int samplesPerBlock) {
  delayBufferLength = static_cast<int>(sampleRate) * MAX_DELAY_LENGTH_MS + 1;
  delayBuffer.setSize(2, delayBufferLength);
  delayBuffer.clear();

  delayWritePosition = 0;
  DBG("Delay Plugin Setup.");
}

void DelayPluginAudioProcessor::releaseResources() {
  // When playback stops, you can use this as an opportunity to free up any
  // spare memory, etc.
}

bool DelayPluginAudioProcessor::isBusesLayoutSupported(
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

void DelayPluginAudioProcessor::processBlock(juce::AudioBuffer<float>& buffer,
                                             juce::MidiBuffer& midiMessages) {
  juce::ignoreUnused(midiMessages);
  juce::ScopedNoDenormals noDenormals;

  int totalNumInputChannels = getTotalNumInputChannels();
  int totalNumOutputChannels = getTotalNumOutputChannels();
  int numSamples = buffer.getNumSamples();

  int sampleRateMs = getSampleRate() / 1000;
  int delayReadPosition =
      delayWritePosition - (*delayLengthParameter * sampleRateMs);
  if (delayReadPosition < 0) delayReadPosition += delayBufferLength;

  int dwp = 0, drp = 0;

  for (int channel = 0; channel < totalNumInputChannels; ++channel) {
    float* bufferData = buffer.getWritePointer(channel);
    float* delayBufferData = delayBuffer.getWritePointer(channel);

    drp = delayReadPosition;
    dwp = delayWritePosition;

    for (int i = 0; i < numSamples; i++) {
      delayBufferData[dwp] = bufferData[i];
      bufferData[i] += delayBufferData[drp] * *gainParameter;

      if (++drp >= delayBufferLength) drp = 0;
      if (++dwp >= delayBufferLength) dwp = 0;
    }
  }

  delayReadPosition = drp;
  delayWritePosition = dwp;

  // Clear samples in channels we're not using.
  for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i) {
    buffer.clear(i, 0, buffer.getNumSamples());
  }
}

//==============================================================================
bool DelayPluginAudioProcessor::hasEditor() const {
  return true;  // (change this to false if you choose to not supply an
                // editor)
}

juce::AudioProcessorEditor* DelayPluginAudioProcessor::createEditor() {
  return new DelayPluginAudioProcessorEditor(*this, parameters);
}

//==============================================================================
void DelayPluginAudioProcessor::getStateInformation(
    juce::MemoryBlock& destData) {
  // You should use this method to store your parameters in the memory block.
  // You could do that either as raw data, or use the XML or ValueTree classes
  // as intermediaries to make it easy to save and load complex data.
  juce::ignoreUnused(destData);
}

void DelayPluginAudioProcessor::setStateInformation(const void* data,
                                                    int sizeInBytes) {
  // You should use this method to restore your parameters from this memory
  // block, whose contents will have been created by the getStateInformation()
  // call.
  juce::ignoreUnused(data, sizeInBytes);
}

//==============================================================================
// This creates new instances of the plugin..
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter() {
  return new DelayPluginAudioProcessor();
}

juce::AudioProcessorValueTreeState::ParameterLayout
DelayPluginAudioProcessor::createParameters() {
  juce::AudioProcessorValueTreeState::ParameterLayout params;

  juce::NormalisableRange<float> delayRange(0, MAX_DELAY_LENGTH_MS, 1);
  delayRange.skew = 0.5;

  params.add(std::make_unique<juce::AudioParameterFloat>(
      juce::ParameterID("delay_length", 1), "Delay Length", delayRange, 50));

  params.add(std::make_unique<juce::AudioParameterFloat>(
      juce::ParameterID("gain", 1), "Gain", 0, 1, 0.5));

  return params;
}
