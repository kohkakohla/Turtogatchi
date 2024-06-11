import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turtogatchi/inventory/components/card.dart';

const String TURTLE_COLLECTION_REF = 'Turtle';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _turtleCollection;

  DatabaseService() {
    _turtleCollection =
        _firestore.collection(TURTLE_COLLECTION_REF).withConverter<CardTurt>(
              fromFirestore: (snapshots, _) => CardTurt.fromJson(
                snapshots.data()!,
              ),
              toFirestore: (card, _) => card.toJson(),
            );
  }

  Stream<QuerySnapshot> getCards() {
    return _turtleCollection.snapshots();
  }
}
