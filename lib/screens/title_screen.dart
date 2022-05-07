import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testbook/screens/new_home.dart';

class TitleSceen extends StatefulWidget {
  const TitleSceen({Key? key}) : super(key: key);

  @override
  State<TitleSceen> createState() => _TitleSceenState();
}

class _TitleSceenState extends State<TitleSceen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const NewHomePage()));
    });
    // Navigator.push(context, MaterialPageRoute(builder: (_) => MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Lottie.asset("assets/json/book.json"),
        ));
  }
}
