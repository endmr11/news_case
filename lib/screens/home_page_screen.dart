import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:news_case/data/database.dart';
import 'package:news_case/data/http_service.dart';
import 'package:news_case/helpers/auth_helper_data.dart';
import 'package:news_case/models/article_model.dart';
import 'package:news_case/helpers/article_detail_data.dart';
import 'package:news_case/helpers/login_user.data.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  HttpServices httpServices = HttpServices();
  ArticleDetailData articleDetailData = ArticleDetailData();
  DatabaseMethods databaseMethods = DatabaseMethods();

  String loginUserName = LoginUserData.loginUserData;
  String loginUserEmail = LoginUserData.loginUserEmail;

  getUserInfo() async {
    loginUserName = await HelperFunctions.getUserNameSharedPreference();
    loginUserEmail = await HelperFunctions.getUserEmailSharedPreference();
    getEmailFavItems();
  }

  List isFavItems = [];
  List isFavItemsID = [];

  addFavorites(
    String author,
    String content,
    String description,
    String pusblishedAt,
    String title,
    String url,
    String urlToImage,
    String email,
    String sourceName,
  ) async {
    setState(() {
      Map<String, dynamic> favMap = {
        "article_author": author,
        "article_content": content,
        "article_description": description,
        "article_publishedAt": pusblishedAt,
        "article_title": title,
        "article_url": url,
        "article_urlToImage": urlToImage,
        "email": email,
        "source_name": sourceName,
      };
      databaseMethods.addFavItems(favMap);
      // ignore: avoid_print
      print("Fav eklemek istedin");
      getEmailFavItems();
    });
  }

  deleteFavorites(String id) {
    setState(() {
      databaseMethods.deleteEqualFavItems(id);
      // ignore: avoid_print
      getEmailFavItems();
      // ignore: avoid_print
      print("Fav silmek istedin");
    });
  }

  getEmailFavItems() async {
    QuerySnapshot favItems =
        await databaseMethods.getEqualFavItems(loginUserEmail);
    isFavItems.clear();
    setState(() {
      if (favItems.docs.isNotEmpty) {
        for (var i = 0; i < favItems.docs.length; i++) {
          isFavItemsID.clear();

          isFavItems.add(favItems.docs[i]['article_title']);
          isFavItemsID.add(favItems.docs[i].id);
        }
      }
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final addSnackBar = SnackBar(
      content: const Text(
          'Favorilere Eklendi. Lütfen Favoriler Sayfanızı Kontrol Ediniz!'),
      action: SnackBarAction(
        label: 'Favorilerim',
        onPressed: () {
          Navigator.pushNamed(context, "/favoriteArticlePageScreen");
        },
      ),
    );

    return Scaffold(
      appBar: _buildHomeAppBar(context),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 30.0,
                  ),
                  Text(
                    loginUserName,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.star,
              ),
              title: const LocaleText(
                'drawer_menu_favorites_text',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, "/favoriteArticlePageScreen");
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(),
        child: FutureBuilder(
          future: httpServices.getAllArticles(),
          builder: (context, AsyncSnapshot/*<List<ArticleModel>>*/ snapshot) {
            if (snapshot.hasData) {
              List<ArticleModel>? articles = snapshot.data;
              return ListView.builder(
                itemCount: articles!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Theme.of(context).primaryColor),
                      child: ListTile(
                        onTap: () {
                          articleDetailData.setArticleDetailData(
                              articles[index].source!.name ?? "",
                              articles[index].author ?? "",
                              articles[index].title ?? "",
                              articles[index].description ?? "",
                              articles[index].url ?? "",
                              articles[index].urlToImage ?? "",
                              articles[index].publishedAt ?? "",
                              articles[index].content ?? "");
                          Navigator.pushNamed(
                              context, "/articleDetailPageScreen");
                        },
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(
                            articles[index].urlToImage ?? "",
                          ),
                        ),
                        title: Text(
                          articles[index].title!.substring(0, 23) + "...",
                          textAlign: TextAlign.justify,
                        ),
                        subtitle: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const LocaleText(
                                  "article_detail_page_source_text"),
                              Text(articles[index].source!.name ?? "Bulunmadı"),
                              const SizedBox(
                                width: 5.0,
                              ),
                            ],
                          ),
                        ),
                        //Text(" Kaynak:  ${articles[index].source!.name ?? "Bulunmadı"} , Yazar:  ${articles[index].author ?? "Bulunmadı"} "),
                        trailing: IconButton(
                          icon: isFavItems.contains(articles[index].title)
                              ? const Icon(Icons.star)
                              : const Icon(Icons.star_border),

                          //(articles[index].title in isFavItems) ?
                          onPressed: () {
                            setState(() {
                              if (isFavItems.contains(articles[index].title)) {
                                getEmailFavItems();
                              } else {
                                addFavorites(
                                  articles[index].author ?? "Bulunmadı",
                                  articles[index].content ?? "Bulunmadı",
                                  articles[index].description ?? "Bulunmadı",
                                  articles[index].publishedAt ?? "Bulunmadı",
                                  articles[index].title ?? "Bulunmadı",
                                  articles[index].url ?? "Bulunmadı",
                                  articles[index].urlToImage ?? "Bulunmadı",
                                  loginUserEmail,
                                  articles[index].source!.name ?? "Bulunmadı",
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(addSnackBar);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  AppBar _buildHomeAppBar(BuildContext context) {
    return AppBar(
      title: const LocaleText("home_page_screen_appbar_title"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, "/settingsPageScreen"),
          icon: const Icon(
            Icons.settings,
          ),
        ),
        IconButton(
          onPressed: () {
            HelperFunctions.deleteSharedPreference();
            Navigator.pushReplacementNamed(context, "/signinPageScreen");
          },
          icon: const Icon(
            Icons.exit_to_app,
          ),
        ),
      ],
    );
  }
}
