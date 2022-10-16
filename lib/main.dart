import 'package:flutter/material.dart';
import 'package:kanakku_book/login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(136, 48, 143, 100),
        ).copyWith(
          secondary: Color.fromRGBO(136, 48, 143, 100),
        ),
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
      ),
      title: 'Kanaku Book',
      home: Login(),
    );
  }
}
