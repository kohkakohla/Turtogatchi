import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turtogatchi/inventories/components/card.dart';
import 'package:turtogatchi/inventories/encyclopedia/components/turtle_card.dart';
import 'package:turtogatchi/inventories/inventory/turtle_card_switchable.dart';
import 'package:turtogatchi/inventories/services/turtle_database_service.dart';

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
                            List cardsInInventory = cards
                                .where((card) => inventory.contains(card.id))
                                .toList();
                            return SizedBox(
                                height: 400,
                                child: GridView.builder(
                                  itemCount: cardsInInventory.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // number of columns
                                    crossAxisSpacing:
                                        10, // spacing between columns
                                    mainAxisSpacing: 12, // spacing between rows
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    CardTurt card =
                                        cardsInInventory[index].data();
                                    String id = cardsInInventory[index].id;
                                    if (card != null) {
                                      // assuming inventory is a list of ids
                                      return TurtleCardSwitchable(
                                        id: id,
                                        img: card.img,
                                        name: card.name,
                                        origin: card.origin,
                                        rarity: card.rarity,
                                        species: card.species,
                                        type: card.type,
                                        conservationText: card.conservationText,
                                        vulnerable: card.vulnerable,
                                      );
                                    }
                                  },
                                ));
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
