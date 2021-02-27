import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(studentData) async {
    if (isLoggedIn()) {
      FirebaseFirestore.instance
          .collection("testcrud")
          .add(studentData)
          .catchError((e) {
        print(e);
      });
    } else {
      print("You need to be logged in");
    }
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("testcrud").get();
  }

  updateData(selectedDoc, newValues) {
    FirebaseFirestore.instance
        .collection("testcrud")
        .doc(selectedDoc)
        .update(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(docId) {
    FirebaseFirestore.instance
        .collection("testcrud")
        .doc(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
