import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turtogatchi/inventory/components/accessory_card.dart';
import 'package:turtogatchi/inventory/services/accessory_database_service.dart';

class AccessoryInventoryPage extends StatefulWidget {
  const AccessoryInventoryPage({Key? key}) : super(key: key);

  @override
  State<AccessoryInventoryPage> createState() => _AccessoryInventoryPageState();
}

class _AccessoryInventoryPageState extends State<AccessoryInventoryPage> {
  final AccessoryDatabaseService _databaseService = AccessoryDatabaseService();
  final user = FirebaseAuth.instance.currentUser;
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  var accessory = [];

  Stream<QuerySnapshot> getAccessoryCards() {
    return FirebaseFirestore.instance.collection(" Accessory").snapshots();
  }

  @override
  void initState() {
    super.initState();
    _getUserInventory();
  }

  void _getUserInventory() async {
    if (user != null) {
      _userDataSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          setState(() {
            accessory = (snapshot.data()?['inventory'] as List<dynamic>)
                    .cast<String>() ??
                [];
          });
        }
      }, onError: (error) {
        // Handle any errors
        ///print("Error listening to user data changes: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
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
                        // TODO MAKE FROM DB.
                        StreamBuilder(
                          builder: (context, snapshot) {
                            List cards = snapshot.data?.docs ?? [];
                            if (cards.isEmpty) {
                              return const Text('No cards found');
                            }
                            return SizedBox(
                              height: 511,
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // number of columns
                                    crossAxisSpacing:
                                        10, // spacing between columns
                                    mainAxisSpacing: 12, // spacing between rows
                                  ),
                                  itemCount: cards.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var card = cards[index].data();
                                    if (card != null) {
                                      var accessoryId = cards[index].id;
                                      print(accessoryId);
                                      print(accessory.toString());
                                      if (accessory.contains(accessoryId)) {
                                        return AccessoryCard(
                                          id: accessoryId,
                                          img: card.img,
                                          name: card.name,
                                          description: card.description,
                                        );
                                      }
                                    } else {
                                      print("no stream");
                                      return const SizedBox.shrink();
                                    }
                                  }),
                            );
                          },
                          stream: _databaseService.getAccessoryCards(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
