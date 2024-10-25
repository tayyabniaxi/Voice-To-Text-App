import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/speech-to-text/bloc/text-to-audio-bloc/bloc.dart';
import 'package:new_wall_paper_app/speech-to-text/bloc/text-to-audio-bloc/event.dart';
import 'package:new_wall_paper_app/speech-to-text/bloc/text-to-audio-bloc/state.dart';
// import 'audio_bloc.dart';
// import 'audio_event.dart';
// import 'audio_state.dart';

class AudioView extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text to Audio Converter"),
      ),
      body: BlocProvider(
        create: (context) => AudioBloc(),
        child: BlocBuilder<AudioBloc, AudioState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: "Enter text to convert",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final text = _textController.text;
                      if (text.isNotEmpty) {
                        context.read<AudioBloc>().add(ConvertTextToAudio(text));
                      }
                    },
                    child: Text("Convert Text to Audio"),
                  ),
                  SizedBox(height: 16),
                  if (state is AudioLoading) CircularProgressIndicator(),
                  if (state is AudioLoaded) ...[
                    Text("Audio ready!"),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AudioBloc>().add(PlayAudio());
                      },
                      child: Text("Play Audio"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AudioBloc>().add(StopAudio());
                      },
                      child: Text("Stop Audio"),
                    ),
                  ],
                  if (state is AudioPlaying) Text("Audio is playing..."),
                  if (state is AudioStopped) Text("Audio stopped."),
                  if (state is AudioError) Text("Error: ${state.message}"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
