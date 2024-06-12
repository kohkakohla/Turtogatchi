import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turtogatchi/inventories/components/card.dart';
import 'package:turtogatchi/inventories/components/card_acc.dart';
import 'package:turtogatchi/inventories/encyclopedia/components/turtle_card.dart';
import 'package:turtogatchi/inventories/inventory/accessory_card_switchable.dart';
import 'package:turtogatchi/inventories/services/turtle_database_service.dart';

import '../../components/footer.dart';

class TurtleEncyclopediaPage extends StatefulWidget {
  const TurtleEncyclopediaPage({super.key});

  @override
  TurtleEncyclopediaPageState createState() => TurtleEncyclopediaPageState();
}

class TurtleEncyclopediaPageState extends State<TurtleEncyclopediaPage> {
  final TurtleDatabaseService _databaseService = TurtleDatabaseService();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(211, 244, 255, 1.0),
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
                          // TODO MAKE FROM DB.
                          StreamBuilder(
                            builder: (context, snapshot) {
                              List cards = snapshot.data?.docs ?? [];
                              if (cards.isEmpty) {
                                return const Text('No cards found');
                              }
                              return Container(
                                height: 400,
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
                                    CardTurt card = cards[index].data();
                                    String id = cards[index].id;
                                    print(id);
                                    return TurtleCard(
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
                                  },
                                ),
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

              // FOOTER
              //const Footer()
            ],
          ),
        ),
      ),
    );
  }
}
