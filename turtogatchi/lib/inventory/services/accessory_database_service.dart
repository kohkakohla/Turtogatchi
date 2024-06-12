import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turtogatchi/inventory/components/card_acc.dart';

const String ACCESSORY_COLLECTION_REF = 'Accessory';

class AccessoryDatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _accessoryCollection;

  AccessoryDatabaseService() {
    _accessoryCollection =
        _firestore.collection(ACCESSORY_COLLECTION_REF).withConverter<CardAcc>(
              fromFirestore: (snapshots, _) => CardAcc.fromJson(
                snapshots.data()!,
              ),
              toFirestore: (card, _) => card.toJson(),
            );
  }

  Stream<QuerySnapshot> getAccessoryCards() {
    return _accessoryCollection.snapshots();
  }
}
