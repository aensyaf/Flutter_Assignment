import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor_app/views/loginscreen.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MY Tutor App',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255,155,36,36),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme.apply(),
        )
      ),
      home: const SplashPage()
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
   @override
  void initState() {
    super.initState();
    
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (content) => const LoginScreen(
        )))
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splashlogo.png'),
          ],
        )
      )
    );
  }
}