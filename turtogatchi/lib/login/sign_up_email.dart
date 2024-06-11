import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turtogatchi/home.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this line to import the cloud_firestore package
import 'package:turtogatchi/popups/museum_popup.dart';

class SignUpEmailPage extends StatefulWidget {
  const SignUpEmailPage({super.key});

  @override
  SignUpEmailPageState createState() => SignUpEmailPageState();
}

class SignUpEmailPageState extends State<SignUpEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    // Function to add user to database
    Future<void> addToDatabase() async {
      // add user to firestore
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': _emailController.text,
        'userId': uid,
        'coins': 100,
        'inventory': ["T01", "T02"],
        'adCount': 0
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('turtleState')
          .doc('turtle')
          .set({
        'current': 'T01',
        'hunger': 5,
      });
    }

    //Sign up function here

    Future<void> _signUp() async {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
            .then((res) => addToDatabase());

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } on FirebaseAuthException catch (e) {
        var errormsg = e.code;
        if (errormsg == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The password provided is too weak.'),
            ),
          );
        } else if (errormsg == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The account already exists for that email.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating account: $errormsg'),
            ),
          );
        }
      }
    }

    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage("https://i.imgur.com/nFTIczm.png"),
            ),
          ),
        ),
        GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 72, 0, 0),
                      child:

                          // Login box container
                          Opacity(
                        opacity: 0.9,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ), // LOGIN PAGE COLUMN
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Big welcome text
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //back button
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 15, 0),
                                          child: IconButton(
                                              icon: Icon(Icons.arrow_back),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 45, 10),
                                            child: Text(
                                                'Email is the \nway to go!',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "MarioRegular",
                                                  fontSize: 24,
                                                )))
                                      ]),

                                  // Subtext for login page
                                  Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 12, 0, 12),
                                      child: Text(
                                        "Join the family today!",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.pressStart2p(
                                            textStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 8,
                                        )),
                                      )),

                                  // Email text field
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 8, 10, 8),
                                    child: TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Email',
                                          labelStyle: GoogleFonts.pressStart2p(
                                              textStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 8,
                                          ))),
                                    ),
                                  ),

                                  // Password text field
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 8, 10, 8),
                                    child: TextFormField(
                                      controller: _passwordController,
                                      obscureText:
                                          _isObscured, // Use the _isObscured flag to toggle text visibility
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Password',
                                        labelStyle: GoogleFonts.pressStart2p(
                                          textStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 8,
                                          ),
                                        ),
                                        // Add a visibility toggle icon
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            // Change the icon based on the state of _isObscured
                                            _isObscured
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            print(
                                                'Visibility button pressed'); // Debug print statement
                                            // Update the state to toggle text visibility
                                            setState(() {
                                              _isObscured = !_isObscured;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Login button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      minimumSize: Size(328, 50),
                                    ),
                                    onPressed: () {
                                      _signUp();
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: GoogleFonts.pressStart2p(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // Button at bottom right
              floatingActionButton: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SizedBox(
                        width: 100,
                        child: Text(
                          "",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.pressStart2p(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Lil icon on bottom right
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: FloatingActionButton(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const MuseumPopup();
                            },
                          );
                        },
                        child: Image.asset(
                          "assets/images/gachapage/Collaboration.png",
                          height: 200,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
