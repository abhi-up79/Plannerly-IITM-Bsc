// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plannerly_iitm_bsc/Screens/Dashboard.dart';

class NewProfile extends StatefulWidget {
  const NewProfile({Key? key}) : super(key: key);

  @override
  State<NewProfile> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  final GlobalKey<FormState> newProfileKey = new GlobalKey<FormState>();

  String? firstName;
  String? lastName;
  String? house;
  String? examCity;

  static List<String> houses = [
    'Corbett',
    'Namdhapa',
    'Kanha',
    'Kaziranga',
    'Bandipur'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff79201B),
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text(
          "Create New Profile",
          // ignore: prefer_const_constructors
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xffD7A74F)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Form(
              key: newProfileKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20),
                    child: Text(
                      'First Name',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xff79201B))),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xff79201B))),
                        hintText: 'Harry',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'First name is mandatory';
                        }
                        return null;
                      },
                      onSaved: (firstName) {
                        this.firstName = firstName!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20),
                    child: Text(
                      'Last Name',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xff79201B))),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xff79201B))),
                        hintText: 'Potter',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Last name is mandatory';
                        }
                        return null;
                      },
                      onSaved: (lastName) {
                        this.lastName = lastName!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      'House',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return houses.where((String option) {
                          return option
                              .toLowerCase()
                              .startsWith(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        debugPrint('You just selected $selection');
                        house = selection;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20),
                    child: Text(
                      'Exam City',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xff79201B))),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xff79201B))),
                        hintText: 'Delhi',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Exam City is Mandatory';
                        }
                        return null;
                      },
                      onSaved: (city) {
                        this.examCity = city!;
                      },
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xffD7A74F)),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                          ),
                          onPressed: () async {
                            newProfileKey.currentState!.save();
                            if (newProfileKey.currentState!.validate()) {
                              //
                              FirebaseFirestore firebaseFirestore =
                                  FirebaseFirestore.instance;
                              String? email =
                                  FirebaseAuth.instance.currentUser!.email;
                              debugPrint("Successfully Form validated");
                              var udata = {
                                "firstName": firstName,
                                "lastName": lastName,
                                "house": house,
                                "examCity": examCity,
                                "email": email,
                              };
                              await firebaseFirestore
                                  .collection('Users')
                                  .doc(email)
                                  .set(udata);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Dashboard()));
                            } else {
                              debugPrint("Please fill the form again");
                            }
                          },
                          child: const Text("Create Profile",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
