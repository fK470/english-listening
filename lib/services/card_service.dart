import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CardService {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<String> getImage(String imageUrl) async {
    final ref = _storage.ref().child(imageUrl);
    return await ref.getDownloadURL();
  }

  Future<Map<String, dynamic>> loadCard(int cardId) async {
    // 次のカードのIDを0埋め4桁で生成
    String cardIdString = 'cefr_a1${cardId.toString().padLeft(4, '0')}';
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("assets").doc(cardIdString).get();

    if (snapshot.exists) {
      Map<String, dynamic> cardData = snapshot.data()!;
      // String image = await getImage(cardData['imageUrl'] as String);
      // cardData['imageUrl'] = image;
      return cardData;
    } else {
      return {};
    }
  }
}
