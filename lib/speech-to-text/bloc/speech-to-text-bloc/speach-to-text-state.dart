// ignore_for_file: non_constant_identifier_names

abstract class SpeechTextState {}

class SpeechTextInitial extends SpeechTextState {}

class FanListening extends SpeechTextState {}

class FanRecording extends SpeechTextState {} 

class FanTranscriptionUpdated extends SpeechTextState {
  final String transcription;
  final int SpeechTextState;
  final bool isValid;
  FanTranscriptionUpdated(this.transcription, this.SpeechTextState, this.isValid);
}

class FanToggled extends SpeechTextState {
  final int SpeechTextState;
  FanToggled(this.SpeechTextState);
}

class SpeechTextError extends SpeechTextState {
  final String error;
  SpeechTextError(this.error);
}
