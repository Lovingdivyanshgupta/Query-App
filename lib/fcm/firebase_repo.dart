import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FireBaseDataBaseRepo {
  final FirebaseFirestore _fire = FirebaseFirestore.instance;
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> myData = [];

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDocsList(
      String collectionPath) async {
    try {
      QuerySnapshot<Map<String, dynamic>> collection =
          await _fire.collection(collectionPath).get();
      myData = collection.docs;
      //print('collection FirebaseFirestore : $myData');
      //print('collection FirebaseFirestore : ${myData[0].data()['image']}');
      return myData;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('catch FirebaseException : ${e.message}');
      }
    }
    return myData;
  }

}
