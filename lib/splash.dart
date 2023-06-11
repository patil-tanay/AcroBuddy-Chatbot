


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:acrobuddy/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5)).then((value) {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => const Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage('assets/logo.png'),
              width: 450,
            ),

            SizedBox(
              height: 50,
            ),
            SpinKitFadingCircle(
              color: Color.fromRGBO(28, 82, 126, 1),
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
