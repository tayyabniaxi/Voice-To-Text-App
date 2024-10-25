
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/services/ESP_services.dart';
import 'package:new_wall_paper_app/speech-to-text/bloc/speech-to-text-bloc/speach-to-text-event.dart';
import 'package:new_wall_paper_app/speech-to-text/bloc/speech-to-text-bloc/speach-to-text-state.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechTextBloc extends Bloc<SpeechTextEvent, SpeechTextState> {
  late stt.SpeechToText _speech;
  int _fanState = 0;
  bool _isValid = true;bool _isRecording = false;

  SpeechTextBloc() : super(SpeechTextInitial()) {
    _speech = stt.SpeechToText();

    on<InitializeSpeech>(_onInitializeSpeech);
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening); 
    on<UpdateTranscription>(_onUpdateTranscription);
    on<ToggleFanState>(_onToggleFanState);
  }

  Future<void> _onInitializeSpeech(InitializeSpeech event, Emitter<SpeechTextState> emit) async {
    bool available = await _speech.initialize();
    if (!available) {
      emit(SpeechTextError("Speech recognition not available"));
    }
  }

 Future<void> _onStartListening(StartListening event, Emitter<SpeechTextState> emit) async {
  if (_speech.isListening) return; 

  await _speech.listen(
    onResult: (result) {
      add(UpdateTranscription(result.recognizedWords.toLowerCase()));
    },
    listenFor: Duration(hours: 1),
    pauseFor: Duration(minutes: 1), 
    partialResults: true, 
  );

  _speech.statusListener = (status) {
    if (status == "notListening" && _isRecording) { 
      add(StartListening()); 
    }
  };

  emit(FanListening());
}


  Future<void> _onStopListening(StopListening event, Emitter<SpeechTextState> emit) async {
    if (_speech.isListening) {
      await _speech.stop();
    }
    emit(SpeechTextInitial());
  }

  void _onUpdateTranscription(UpdateTranscription event, Emitter<SpeechTextState> emit) {
    String transcription = event.transcription;

    if (transcription == 'turn off fan') {
      _fanState = 0;
      _isValid = true;
    } else if (transcription == 'turn on fan') {
      _fanState = 1;
      _isValid = true;
    } else {
      _isValid = false;
    }

    if (_isValid) _handleSwitch();

    emit(FanTranscriptionUpdated(transcription, _fanState, _isValid));
  }

  void _onToggleFanState(ToggleFanState event, Emitter<SpeechTextState> emit) {
    _fanState = event.isOn ? 1 : 0;
    _handleSwitch();
    emit(FanToggled(_fanState));
  }

  void _handleSwitch() {
    ESPServices espServices = ESPServices();
    if (_fanState == 1) {
      espServices.turnOnLed('fan1');
    } else {
      espServices.turnOffLed('fan1');
    }
  }
}
