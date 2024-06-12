import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turtogatchi/inventory/components/turtle_card.dart';
import 'package:turtogatchi/inventory/components/turtle_card_switchable.dart';
import 'package:turtogatchi/inventory/services/turtle_database_service.dart';

class TurtleInventoryPage extends StatefulWidget {
  const TurtleInventoryPage({Key? key}) : super(key: key);

  @override
  State<TurtleInventoryPage> createState() => _TurtleInventoryPageState();
}

class _TurtleInventoryPageState extends State<TurtleInventoryPage> {
  final TurtleDatabaseService _databaseService = TurtleDatabaseService();
  final user = FirebaseAuth.instance.currentUser;
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  var inventory = [];

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
            inventory = snapshot.data()?['inventory'] ?? ["T01"];
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
                                      String turtleId = cards[index].id;
                                      if (inventory.contains(turtleId)) {
                                        return TurtleCardSwitchable(
                                          id: turtleId,
                                          img: card.img,
                                          name: card.name,
                                          origin: card.origin,
                                          rarity: card.rarity,
                                          species: card.species,
                                          type: card.type,
                                          conservationText:
                                              card.conservationText,
                                          vulnerable: card.vulnerable,
                                        );
                                      }
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  }),
                            );
                          },
                          stream: _databaseService.getTurtleCards(),
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
