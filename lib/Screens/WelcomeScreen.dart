// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plannerly_iitm_bsc/Screens/Dashboard.dart';
import 'package:plannerly_iitm_bsc/Screens/NewProfile.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = new GoogleSignIn();
  GoogleSignInAccount? signedInAccount;

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
                            MaterialStateProperty.all(const Color(0xffD7A74F)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                        side: MaterialStateProperty.all(
                            const BorderSide(width: 2, color: Colors.white))),
                    onPressed: () async {
                      await googleSignIn.signOut();
                      try {
                        signedInAccount = await googleSignIn.signIn();
                        if (signedInAccount != null) {
                          debugPrint("Authentication Successful");
                          debugPrint(
                              "Signed in from ${signedInAccount!.email}");
                          GoogleSignInAuthentication gauth =
                              await signedInAccount!.authentication;
                          final AuthCredential credential =
                              GoogleAuthProvider.credential(
                            accessToken: gauth.accessToken,
                            idToken: gauth.idToken,
                          );
                          UserCredential login =
                              await auth.signInWithCredential(credential);
                          if (login != null) {
                            //Query
                            FirebaseAuth auth = FirebaseAuth.instance;
                            FirebaseFirestore firestore =
                                FirebaseFirestore.instance;
                            await firestore
                                .collection('Users')
                                .where('email',
                                    isEqualTo: auth.currentUser!.email)
                                .get()
                                .then((value) {
                              debugPrint(value.docs.length.toString());
                              if (value.docs.length == 0) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NewProfile()));
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Dashboard()));
                              }
                            });
                          } else {
                            await googleSignIn.signOut();
                            await auth.signOut();
                          }
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    child: Text(
                      "Sign In with Google",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ))),
          ],
        ),
      ),
    );
  }
}
