import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:toi_invite/firebase_options.dart';
import 'package:toi_invite/pages/my_home_page.dart';
import 'package:toi_invite/theme.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setUrlStrategy(PathUrlStrategy());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мадияр & Венера үйлену тойы',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const MyHomePage(),

    );
  }
}


