

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/speech-to-text/bloc/speech-to-text-bloc/speach-to-text-bloc.dart';
import 'package:new_wall_paper_app/speech-to-text/bloc/speech-to-text-bloc/speach-to-text-event.dart';
import 'package:new_wall_paper_app/speech-to-text/bloc/speech-to-text-bloc/speach-to-text-state.dart';
import 'package:new_wall_paper_app/speech-to-text/pages/text-to-audio-screen.dart';
class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({super.key});

  @override
  _SpeechToTextScreenState createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpeechTextBloc()..add(InitializeSpeech()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Speech to Text'),
        ),
        body: BlocConsumer<SpeechTextBloc, SpeechTextState>(
          listener: (context, state) {
            if (state is FanListening) {
              setState(() {
                _isRecording = true;
              });
            } else if (state is SpeechTextInitial) {
              setState(() {
                _isRecording = false;
              });
            }
          },
          builder: (context, state) {
            int fanState = 0;

            if (state is FanTranscriptionUpdated) {
              _controller.text = state.transcription;
              fanState = state.SpeechTextState;
            } else if (state is FanToggled) {
              fanState = state.SpeechTextState;
            } else if (state is SpeechTextError) {
              return Center(child: Text('Error: ${state.error}'));
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _controller,
                      enabled: fanState == 1,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Transcription',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        context.read<SpeechTextBloc>().add(UpdateTranscription(value));
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  // Record and Stop buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (!_isRecording) {
                            context.read<SpeechTextBloc>().add(StartListening());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: _isRecording ? Colors.green : null,
                        ),
                        child: const Text("Record"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_isRecording) {
                            context.read<SpeechTextBloc>().add(StopListening());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: !_isRecording ? Colors.red : null,
                        ),
                        child: const Text("Stop"),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AudioView()),
                      );
                    },
                    child: Text("Txt to Audio"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


///////////////////////////// tayyab page //////////////////////////
///
///



///////////////////////////// tayyab page //////////////////////////
///
///




class VoiceToTextApp extends StatelessWidget {
  const VoiceToTextApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice to Text Converter'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<VoiceToTextBloc, VoiceToTextState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state is VoiceToTextListening ? Colors.blue : Colors.grey,
                          ),
                          onPressed: state is VoiceToTextListening ? null : () {
                            context.read<VoiceToTextBloc>().add(StartListeningss());
                          },
                          child: const Text('Record'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state is VoiceToTextListening ? Colors.red : Colors.grey,
                          ),
                          onPressed: state is VoiceToTextListening ? () {
                            context.read<VoiceToTextBloc>().add(StopListenings());
                          } : null,
                          child: const Text('Stop'),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 150, // Fixed height for the text area
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SingleChildScrollView( 
                    child: Text(
                      'Real-time Transcribed Text', 
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      onPressed: () => print('Saving as PDF...'),
                      child: const Text('Save as PDF'),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      onPressed: () => print('Saving as Word...'),
                      child: const Text('Save as Word'),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      onPressed: () => print('Saving as Text...'),
                      child: const Text('Save as Text'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}







class VoiceToTextBloc extends Bloc<VoiceToTextEvent, VoiceToTextState> {
  VoiceToTextBloc() : super(VoiceToTextInitial());

  @override
  Stream<VoiceToTextState> mapEventToState(VoiceToTextEvent event) async* {
    if (event is StartListening) {
      yield VoiceToTextListening();
    } else if (event is StopListening) {
      yield VoiceToTextStopped();
    }
  }
}







abstract class VoiceToTextEvent extends Equatable {
  const VoiceToTextEvent();

  @override
  List<Object> get props => [];
}

class StartListeningss extends VoiceToTextEvent {}

class StopListenings extends VoiceToTextEvent {}







abstract class VoiceToTextState extends Equatable {
  const VoiceToTextState();

  @override
  List<Object> get props => [];
}

class VoiceToTextInitial extends VoiceToTextState {}

class VoiceToTextListening extends VoiceToTextState {}

class VoiceToTextStopped extends VoiceToTextState {}









///////////////////////////// tayyab page //////////////////////////
///
///


