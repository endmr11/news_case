import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {
  Future getUserByUserName(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  Future getUserByUserEmail(String useremail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: useremail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      debugPrint(e.toString());
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }

  Future addFavItems(favMap) async {
    FirebaseFirestore.instance
        .collection("favorites")
        .add(favMap)
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }

  Future getByEmailFavItems(String email) async {
    // ignore: avoid_print
    print("getByEmailFavItems:" + email);
    return FirebaseFirestore.instance
        .collection("favorites")
        .where("email", isEqualTo: email)
        .snapshots();
  }

  Future getEqualFavItems(String email) async {
    // ignore: avoid_print
    print("getEqualFavItems:" + email);
    return FirebaseFirestore.instance
        .collection("favorites")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }

  Future deleteEqualFavItems(String favoriteID) async {
    FirebaseFirestore.instance.collection("favorites").doc(favoriteID).delete();
  }

  Future getComments(String articleId) async {
    return FirebaseFirestore.instance
        .collection("comments")
        .where("article_id", isEqualTo: articleId)
        .snapshots();
  }

  Future addComment(commentMap) async {
    FirebaseFirestore.instance
        .collection("comments")
        .add(commentMap)
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }

  Future getByEmailComments(String email) async {
    return FirebaseFirestore.instance
        .collection("comments")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }

  Future getEqualMyComments(String email) async {
    // ignore: avoid_print
    print("getEqualFavItems:" + email);
    return FirebaseFirestore.instance
        .collection("comments")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }

  Future deleteComment(String commentId) async {
    FirebaseFirestore.instance.collection("comments").doc(commentId).delete();
  }
}
