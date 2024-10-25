import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:new_wall_paper_app/speech-to-text/bloc/text-to-audio-bloc/event.dart';
import 'package:new_wall_paper_app/speech-to-text/bloc/text-to-audio-bloc/state.dart';
// import 'audio_event.dart';
// import 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioBloc() : super(AudioInitial()) {
    on<ConvertTextToAudio>(_onConvertTextToAudio);
    on<PlayAudio>(_onPlayAudio);
    on<StopAudio>(_onStopAudio);
  }

  Future<void> _onConvertTextToAudio(ConvertTextToAudio event, Emitter<AudioState> emit) async {
    emit(AudioLoading());

    try {
      final response = await http.post(
        Uri.parse("https://wetransfer.pk/Rm4EX9Hk"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "text": event.text,
        }),
      );

      if (response.statusCode == 200) {
        final audioUrl = json.decode(response.body)['audio_url'];
        emit(AudioLoaded(audioUrl));
      } else {
        emit(AudioError("Failed to convert text to audio"));
      }
    } catch (e) {
      emit(AudioError("An error occurred: $e"));
    }
  }

  Future<void> _onPlayAudio(PlayAudio event, Emitter<AudioState> emit) async {
    if (state is AudioLoaded) {
      final audioUrl = (state as AudioLoaded).audioUrl;

      try {
        await _audioPlayer.setUrl(audioUrl);
        await _audioPlayer.play();
        emit(AudioPlaying());
      } catch (e) {
        emit(AudioError("Failed to play audio: $e"));
      }
    }
  }

  Future<void> _onStopAudio(StopAudio event, Emitter<AudioState> emit) async {
    await _audioPlayer.stop();
    emit(AudioStopped());
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
