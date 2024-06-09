import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();

  ForgotPasswordPage({super.key});
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  //TODO ADD BACKGROUND MUSIC HERE
  Widget build(BuildContext context) {
    //firebase reset password function
    Future<void> resetPassword(String email) async {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent!'),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error sending password reset email'),
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
                                        IconButton(
                                          icon: Icon(Icons.arrow_back),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                40, 10, 55, 10),
                                            child: Text('Forgot \nPassword!?',
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
                                        "Let's get back to turtogotching!",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.pressStart2p(
                                            textStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 8,
                                        )),
                                      )),
                                  // Description text for forgot password reset
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 0, 10),
                                      child: Text(
                                        "Enter your email address and we'll send you a link to reset your password so you can get back on track turtogotching with us!",
                                        textAlign: TextAlign.left,
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
                                            10, 8, 10, 28),
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
                                      _emailController.text.isNotEmpty
                                          ? resetPassword(_emailController.text)
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Please enter an email'),
                                            ));
                                    },
                                    child: Text(
                                      'Reset Password',
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
            )),
      ],
    );
  }
}
