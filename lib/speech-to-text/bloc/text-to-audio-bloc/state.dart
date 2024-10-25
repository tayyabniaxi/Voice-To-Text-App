abstract class AudioState {}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {}

class AudioLoaded extends AudioState {
  final String audioUrl;
  AudioLoaded(this.audioUrl);
}

class AudioPlaying extends AudioState {}

class AudioStopped extends AudioState {}

class AudioError extends AudioState {
  final String message;
  AudioError(this.message);
}
