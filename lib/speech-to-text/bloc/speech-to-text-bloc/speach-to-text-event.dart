abstract class SpeechTextEvent {}

class InitializeSpeech extends SpeechTextEvent {}

class StartListening extends SpeechTextEvent {}

class StopListening extends SpeechTextEvent {} 

class UpdateTranscription extends SpeechTextEvent {
  final String transcription;
  UpdateTranscription(this.transcription);
}

class ToggleFanState extends SpeechTextEvent {
  final bool isOn;
  ToggleFanState(this.isOn);
}
