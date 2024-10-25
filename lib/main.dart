
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/speech-to-text/bloc/speech-to-text-bloc/speach-to-text-bloc.dart';
import 'package:new_wall_paper_app/speech-to-text/bloc/speech-to-text-bloc/speach-to-text-event.dart';
import 'package:new_wall_paper_app/speech-to-text/bloc/text-to-audio-bloc/bloc.dart';
import 'package:new_wall_paper_app/speech-to-text/pages/speech-to-text-screen.dart';
// import 'audio_bloc.dart'; // import your AudioBloc
// import 'fan_bloc.dart';   // import your FanBloc

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SpeechTextBloc>(
          create: (context) => SpeechTextBloc()..add(InitializeSpeech()),
        ),
        BlocProvider<AudioBloc>(
          create: (context) => AudioBloc(),
        ),
 BlocProvider<VoiceToTextBloc>(
          create: (context) => VoiceToTextBloc(),
        ),
        
        BlocProvider<SpeechTextBloc>(
          create: (context) => SpeechTextBloc()..add(InitializeSpeech()),
        ),
      ],
      child: MaterialApp(
        title: 'Fan Control App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SpeechToTextScreen(),
      ),
    );
  }
}
