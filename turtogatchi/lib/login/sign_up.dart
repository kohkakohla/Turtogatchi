import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart' as google_sign_in;
import 'package:turtogatchi/home.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:turtogatchi/popups/museum_popup.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override

  //TODO ADD BACKGROUND MUSIC HERE
  Widget build(BuildContext context) {
    Future<void> addToDatabase(String id) async {
      // add user to firestore
      await FirebaseFirestore.instance.collection('users').doc(id).set({
        'email': _emailController.text,
        'userId': id,
        'coins': 15,
        'inventory': ["T01"],
        'adCount': 0
      });
    }

    //Firebase sign up with google function
    Future<dynamic> _signUpWithGoogle() async {
      // firebase sign up with google mobile app code
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((res) => addToDatabase(googleUser!.id.toString()));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          print('The account already exists with a different credential.');
        } else if (e.code == 'invalid-credential') {
          print('Error occurred while accessing credentials. Try again.');
        }
      } catch (e) {
        print(e);
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
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 108, 0, 0),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //back button
                                    IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                    const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 35, 10),
                                        child: Text('Get Started!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: "MarioRegular",
                                              fontSize: 24,
                                            )))
                                  ]),

                              // Subtext for login page
                              Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
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

                              // Login with email button
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      minimumSize: const Size(328, 50),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/sign_up_email');
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/email.png",
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(
                                            10,
                                            0,
                                            0,
                                            0,
                                          ),
                                          child: Text(
                                            'Sign up with Email',
                                            style: GoogleFonts.pressStart2p(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),

                              // Google sign up button
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  minimumSize: const Size(328, 50),
                                ),
                                onPressed: () {
                                  _signUpWithGoogle();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/google8bit.png",
                                      height: 20,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 0, 0, 0),
                                      child: Text(
                                        'Sign up with Google',
                                        style: GoogleFonts.pressStart2p(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
        ),
      ],
    );
  }
}
