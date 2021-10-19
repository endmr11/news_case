import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_case/data/database.dart';
import 'package:news_case/helpers/article_detail_data.dart';
import 'package:news_case/helpers/auth_helper_data.dart';
import 'package:news_case/helpers/login_user.data.dart';

class FavoriteArticlePageScreen extends StatefulWidget {
  const FavoriteArticlePageScreen({Key? key}) : super(key: key);

  @override
  _FavoriteArticlePageScreenState createState() =>
      _FavoriteArticlePageScreenState();
}

class _FavoriteArticlePageScreenState extends State<FavoriteArticlePageScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  ArticleDetailData articleDetailData = ArticleDetailData();

  final deleteSnackBar = const SnackBar(
    content: Text('Favorilerden Kaldırıldı.'),
  );

  String loginUserName = LoginUserData.loginUserData;
  String loginUserEmail = LoginUserData.loginUserEmail;

  getUserInfo() async {
    loginUserName = await HelperFunctions.getUserNameSharedPreference();
    loginUserEmail = await HelperFunctions.getUserEmailSharedPreference();
    getEmailFavItems();
    getEmailFavItemsID();
  }

  List isFavItemsID = [];

  Stream? favoriteStream;

  getEmailFavItems() async {
    databaseMethods.getByEmailFavItems(loginUserEmail).then((value) {
      setState(() {
        favoriteStream = value;
      });
    });
  }

  getEmailFavItemsID() async {
    QuerySnapshot favItems =
        await databaseMethods.getEqualFavItems(loginUserEmail);
    if (favItems.docs.isNotEmpty) {
      for (var i = 0; i < favItems.docs.length; i++) {
        isFavItemsID.clear();
        isFavItemsID.add(favItems.docs[i].id);
      }
      // ignore: avoid_print
      print(isFavItemsID);
    }
  }

  deleteFavorites(String id) {
    setState(() {
      databaseMethods.deleteEqualFavItems(id);
      getEmailFavItemsID();
    });
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites",
        ),
      ),
      body: StreamBuilder(
        stream: favoriteStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.data != null
              ? snapshot.data.docs.length > 0
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            articleDetailData.setArticleDetailData(
                                snapshot.data.docs[index]["source_name"] ?? "",
                                snapshot.data.docs[index]["article_author"] ??
                                    "",
                                snapshot.data.docs[index]["article_title"] ??
                                    "",
                                snapshot.data.docs[index]
                                        ["article_description"] ??
                                    "",
                                snapshot.data.docs[index]["article_url"] ?? "",
                                snapshot.data.docs[index]
                                        ["article_urlToImage"] ??
                                    "",
                                snapshot.data.docs[index]
                                        ["article_publishedAt"] ??
                                    "",
                                snapshot.data.docs[index]["article_content"] ??
                                    "");
                            Navigator.pushNamed(
                                context, "/articleDetailPageScreen");
                          },
                          title:
                              Text(snapshot.data.docs[index]["article_title"]),
                          subtitle: Text(
                              "Kaynak:  ${snapshot.data.docs[index]["source_name"] ?? ""} , Yazar:  ${snapshot.data.docs[index]["article_author"] ?? ""} "),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(deleteSnackBar);
                                deleteFavorites(isFavItemsID[index]);
                              });
                            },
                            icon: const Icon(
                              Icons.remove,
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("Favorilerin Boş!"),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
