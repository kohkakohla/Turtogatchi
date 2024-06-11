import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turtogatchi/inventory/components/turtle_card_generator.dart';

import 'components/footer.dart';

class EnyclopediaPage extends StatefulWidget {
  const EnyclopediaPage({super.key});

  @override
  EnyclopediaPageState createState() => EnyclopediaPageState();
}

class EnyclopediaPageState extends State<EnyclopediaPage> {
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  final user = FirebaseAuth.instance.currentUser;
  var inventory = <dynamic>[];
  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() async {
    if (user != null) {
      _userDataSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          setState(() {
            inventory = snapshot.data()?['inventory'] ?? [];
          });
          print("Inventory: $inventory");
          _convertStringToInt();
        } else {
          print("Document does not exist");
        }
      }, onError: (error) {
        // Handle any errors
        print("Error listening to user data changes: $error");
      });
    }
  }

  void _convertStringToInt() async {
    for (var i = 0; i < inventory.length; i++) {
      print("converting now!");
      print(int.parse(inventory[i].substring(1)));
      inventory[i] = int.parse(inventory[i].substring(1));
    }
  }

  Widget _initInventory(int id) {
    print(inventory);
    if (inventory.contains(id)) {
      return cardGenerator(true, id);
    } else {
      return cardGenerator(false, id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(211, 244, 255, 1.0),

      // APPBAR
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(211, 244, 255, 1.0),
        title: Row(
          children: [
            const Text(
              'Enclyopedia',
              style: TextStyle(
                color: Colors.black,
                fontFamily: "MarioRegular",
                fontSize: 28,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Image.asset("assets/images/Book.png"),
            ),
          ],
        ),
      ),

      // INVENTORY CARD DISPLAY
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ROW 1
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 20,
                        runSpacing: 15,
                        children: [
                          for (var i = 1; i < 21; i++) _initInventory(i)
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // FOOTER
              const Footer()
            ],
          ),
        ),
      ),
    );
  }
}
