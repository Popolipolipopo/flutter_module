
import 'dart:typed_data';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

class FirebaseInteractions {

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return {
        "status": true,
        "message": "Account successfully created",
        "userInfo": FirebaseAuth.instance.currentUser
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return {
          "status": false,
          "message": "The provided password is too weak"
        };
      } else if (e.code == 'email-already-in-use') {
        return {
          "status": false,
          "message": "This email is already used"
        };
      }
      return {
        "status": false,
        "message": "An error has occured"
      };
    } catch (e) {
      return {
        "status": false,
        "message": e.toString()
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return {
        "status": true,
        "message": "Successfully logged in",
        "userId": FirebaseAuth.instance.currentUser.uid,
        "username": FirebaseAuth.instance.currentUser.email
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return {
          "status": false,
          "message": "User not found"
        };
      } else if (e.code == 'wrong-password') {
        return {
          "status": false,
          "message": "Wrong password"
        };
      }
      return {
        "status": false,
        "message": e.toString()
      };
    } catch (e) {
      return {
        "status": false,
        "message": e.toString()
      };
    }
  }

  User getCurrentUserInfo() {
    return FirebaseAuth.instance.currentUser;
  }

  static Future<Map<String, dynamic>> getDocument(String collection, String document) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .doc(document)
        .get()
        .then((DocumentSnapshot documentSnapshot) => documentSnapshot.data());
  }

  static Future<List<QueryDocumentSnapshot>> getDocumentWithQuery(String collection, String field, String value) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .where(field, isEqualTo: value)
        .get()
        .then((QuerySnapshot querySnapshot) => querySnapshot.docs.toList());
  }

  static Future<List<QueryDocumentSnapshot>> getDocumentsList(String collection) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .get()
        .then((QuerySnapshot querySnapshot) => querySnapshot.docs.toList());
  }

  static Future<void> createDocument(String collection, String document, Map<String, dynamic> content) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(document)
        .set(content);
  }

  static Future<dynamic> createDocumentWithoutId(String collection, Map<String, dynamic> content) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .add(content)
        .then((DocumentReference value) => value.id);
  }


  static Future<void> addFieldToArray(String collection, String document, String key, String value) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(document)
        .set({key: FieldValue.arrayUnion([value])}, SetOptions(merge: true));
  }

  static Future<void> uploadPhoto(File file, String name) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('profile_picture/' + name + ".jpg")
          .putFile(file);
    } on firebase_core.FirebaseException catch (e) {
/*
            print(e.toString());
*/
      // e.g, e.code == 'canceled'
    }
  }

  static Future<void> updateDocument(String collection, String document, Map<String, dynamic> content) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .doc(document)
        .update(content)
        .then((value) => value);
  }

  static Future<List<String>> listFiles(String path) async {
    List<String> res = List<String>();
    firebase_storage.ListResult result =
    await firebase_storage.FirebaseStorage.instance.ref(path).listAll();
    for (int i = 0; i < result.items.length; i++) {
      res.add(await result.items[i].getDownloadURL());
    }
    return res;
  }
}
