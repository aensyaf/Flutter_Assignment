import 'dart:async';

import 'package:flutter/material.dart';

import 'cryptcurrent.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cryptCurrent App',
      theme: ThemeData(
        primarySwatch:Colors.amber,
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

class _SplashPageState extends State<SplashPage>{
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.pushReplacement(context, 
        MaterialPageRoute(builder: (content) => const ConverterPage())
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset('assets/images/cryptLogo.gif')],
        )
      )
    );
  }

}