// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff79201B),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                child: Image.asset(
                  "assets/Icons/logo.png",
                  scale: 6,
                )),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.37,
                child: Text(
                  "IIT Madras Bsc Degree",
                  style: TextStyle(
                      color: Color(0xffD5A54E),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Merriweather'),
                )),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.52,
                child: Text(
                  "Welcome to Plannerly",
                  style: TextStyle(
                      color: Color(0xffFFB5B5),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Merriweather'),
                )),
            Positioned(
                bottom: MediaQuery.of(context).size.height * 0.2,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: null,
                    child: Text(
                      "Sign In with Google",
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ))),
          ],
        ),
      ),
    );
  }
}
