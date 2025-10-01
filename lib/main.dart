import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/firebase_options.dart';
import 'package:meal_app/screens.dart/meal_items.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signInAnonymously();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF6A994E),
          onPrimary: Colors.white,
          secondary: Color(0xFFF2E8CF),
          onSecondary: Color(0xFF38302E),
          error: Colors.red,
          onError: Colors.white,
          surface: Color(0xFFFEFAE0),
          onSurface: Colors.black,
        ),
      ),
      home: MealItems(),
    );
  }
}
