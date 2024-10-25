abstract class AudioEvent {}

class ConvertTextToAudio extends AudioEvent {
  final String text;
  ConvertTextToAudio(this.text);
}

class PlayAudio extends AudioEvent {}

class StopAudio extends AudioEvent {}
