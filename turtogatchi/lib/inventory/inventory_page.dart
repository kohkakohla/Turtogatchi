import 'package:flutter/material.dart';
import 'package:turtogatchi/inventory/components/card.dart';
import 'package:turtogatchi/inventory/components/turtle_card.dart';
import 'package:turtogatchi/inventory/services/database_service.dart';

import 'components/footer.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final DatabaseService _databaseService = DatabaseService();

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
              'Inventory',
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
                              return Container(
                                height: 600,
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // number of columns
                                    crossAxisSpacing:
                                        10, // spacing between columns
                                    mainAxisSpacing: 12, // spacing between rows
                                  ),
                                  itemCount: cards.length + 8,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index < cards.length) {
                                      CardTurt card = cards[index].data();
                                      print(cards.length);
                                      return TurtleCard(
                                        img: card.img,
                                        name: card.name,
                                        origin: card.origin,
                                        rarity: card.rarity,
                                        species: card.species,
                                        type: card.type,
                                        conservationText: card.conservationText,
                                      );
                                    } else {
                                      return Card.outlined(
                                          elevation: 4,
                                          color: const Color.fromRGBO(
                                              152, 228, 255, 1.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  78, 152, 180, 1.0),
                                              width: 2,
                                            ),
                                          ),
                                          child: const SizedBox(
                                            // TODO implement not unlocked yet card
                                            width: 100,
                                            height: 100,
                                            child: Center(
                                              child: Icon(
                                                Icons.question_mark_sharp,
                                                color: Color.fromRGBO(
                                                    78, 152, 180, 1.0),
                                              ),
                                            ),
                                          ));
                                    }
                                  },
                                ),
                              );
                            },
                            stream: _databaseService.getCards(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // FOOTER
              const Expanded(
                child: Footer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
