import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turtogatchi/forgot_password.dart';
import 'package:turtogatchi/home.dart';
import 'dart:async';
import 'home.dart';
import 'sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override

  //TODO ADD BACKGROUND MUSIC HERE
  Widget build(BuildContext context) {
    //Sign in function here
    Future<void> _signIn() async {
      //firebase sign in function
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Sign in successful, navigate to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        // Sign in failed, show error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sign In Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }

    //firebase sign in with google function
    Future<void> _signInWithGoogle() async {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            googleUser?.authentication as GoogleSignInAuthentication?;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sign In Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
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
                  padding: EdgeInsets.fromLTRB(0, 36, 0, 0),
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
                              const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('Welcome',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "MarioRegular",
                                        fontSize: 24,
                                      ))),

                              // Subtext for login page
                              Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 12, 0, 12),
                                  child: Text(
                                    "Let's get to turtogatching!",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.pressStart2p(
                                        textStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 8,
                                    )),
                                  )),

                              // Email text field
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 8, 10, 8),
                                child: TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Password',
                                      labelStyle: GoogleFonts.pressStart2p(
                                          textStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 8,
                                      ))),
                                ),
                              ),
                              // Login button
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  minimumSize: Size(328, 50),
                                ),
                                onPressed: () {
                                  _signIn();
                                },
                                child: Text(
                                  'Sign In',
                                  style: GoogleFonts.pressStart2p(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),

                              // or sign in with text
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 12, 0, 12),
                                child: Text(
                                  "Or sign in with",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.pressStart2p(
                                      textStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 8,
                                  )),
                                ),
                              ),

                              // Google sign in button
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  minimumSize: Size(328, 50),
                                ),
                                onPressed: () {
                                  _signInWithGoogle();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/google.png",
                                      height: 20,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 0, 0, 0),
                                      child: Text(
                                        'Continue with Google',
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

                              Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .start, // Adjusts the space between Rows
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(36, 0, 0, 0),
                                        child: Text(
                                          "Don't have an account?",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.pressStart2p(
                                            textStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/sign_up');
                                          },
                                          child: Text(
                                            'Sign Up Here',
                                            style: GoogleFonts.pressStart2p(
                                              textStyle: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Row for forget password
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(36, 0, 0, 0),
                                        child: Text(
                                          "Forgot your password?",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.pressStart2p(
                                            textStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        child: TextButton(
                                          onPressed: () {
                                            //route to reset password page
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ForgotPasswordPage()));
                                          },
                                          child: Text(
                                            'Reset It Here',
                                            style: GoogleFonts.pressStart2p(
                                              textStyle: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
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
                      // Your onPressed code here
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
