import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turtogatchi/home.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:turtogatchi/popups/museum_popup.dart';
import 'package:turtogatchi/login/sign_up.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  bool _isObscured = true; // Flag to toggle text visibility

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _emailFocusNode.unfocus();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    print("Login page initialized");
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override

  //TODO ADD BACKGROUND MUSIC HERE
  Widget build(BuildContext context) {
    void resetState() {
      setState(() {
        _emailController.clear();
        _passwordController.clear();
        _isObscured = true;
      });

      FocusScope.of(context).unfocus();
    }

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
          MaterialPageRoute(builder: (context) => const HomePage()),
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

    Future<bool> checkIfUserExists(String googleUserId) async {
      print("google user");
      print(googleUserId);
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(googleUserId)
          .get();
      print(userSnapshot.exists);
      return userSnapshot.exists;
    }

    //firebase sign in with google function
    Future<void> _signInWithGoogle() async {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          // Check if the user already exists in your app's database
          // User already exists, proceed with sign-in
          final OAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign in with Google successful!'),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } catch (e) {
        // Handle sign-in error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sign In Error'),
            content: Text("No account found for this user."),
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
                    padding: EdgeInsets.fromLTRB(0, 128, 0, 0),
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
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
                                    focusNode: _emailFocusNode,
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
                                        "assets/images/google8bit.png",
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 0, 0, 0),
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
                                              .fromSTEB(26, 0, 0, 0),
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
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignUpPage()),
                                              ).then((value) => resetState());
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
                                              .fromSTEB(26, 0, 0, 0),
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
                                              Navigator.pushNamed(
                                                  context, '/forgot_password');
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
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const MuseumPopup();
                          },
                        );
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
        )
      ],
    );
  }
}
