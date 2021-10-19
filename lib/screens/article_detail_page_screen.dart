import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:news_case/data/database.dart';
import 'package:news_case/helpers/article_detail_data.dart';
import 'package:news_case/helpers/auth_helper_data.dart';
import 'package:news_case/helpers/login_user.data.dart';
import 'package:news_case/style/style_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailScreenPage extends StatefulWidget {
  const ArticleDetailScreenPage({Key? key}) : super(key: key);

  @override
  _ArticleDetailScreenPageState createState() =>
      _ArticleDetailScreenPageState();
}

class _ArticleDetailScreenPageState extends State<ArticleDetailScreenPage> {
  final formKey = GlobalKey<FormState>();
  ArticleDetailData articleDetailData = ArticleDetailData();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController commentController = TextEditingController();

  Stream? commentStream;

  String loginUserName = LoginUserData.loginUserData;
  String loginUserEmail = LoginUserData.loginUserEmail;

  getUserInfo() async {
    loginUserName = await HelperFunctions.getUserNameSharedPreference();
    loginUserEmail = await HelperFunctions.getUserEmailSharedPreference();
    getAllComment();
    getMyComments();
  }

  final deleteSnackBar = const SnackBar(
    content: Text('Yorumun Kaldırıldı.'),
  );
  var detailList = [];
  var isMyComments = [];
  var isMyCommentsID = [];

  final addCommentsSnackBar = const SnackBar(
    content: Text('Yorum Eklendi.'),
  );

  getAllComment() async {
    databaseMethods
        .getComments(articleDetailData.getArticleDetails[2])
        .then((value) {
      setState(() {
        commentStream = value;
      });
    });
  }

  addComments(
    String articleId,
    String comment,
  ) async {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(addCommentsSnackBar);
      setState(() {
        Map<String, dynamic> commentMap = {
          "article_id": articleId,
          "comment": comment,
          "email": loginUserEmail,
          "name": loginUserName,
        };
        databaseMethods.addComment(commentMap);
      });
    }
  }

  getMyComments() async {
    QuerySnapshot byEmailComments =
        await databaseMethods.getByEmailComments(loginUserEmail);
    isMyComments.clear();
    setState(() {
      if (byEmailComments.docs.isNotEmpty) {
        for (var i = 0; i < byEmailComments.docs.length; i++) {
          isMyComments.add(byEmailComments.docs[i]['email']);
        }
      }
    });
  }

  @override
  void initState() {
    detailList = articleDetailData.getArticleDetails;
    getUserInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          detailList[2],
        ),
        centerTitle: true,
      ),
      body: detailList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _BuildArticleDetailArea(detailList: detailList),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      validator: (val) {
                                        return val!.length < 6
                                            ? "10 Karakterden fazla gir"
                                            : null;
                                      },
                                      controller: commentController,
                                      style: simpleTextStyle(),
                                      decoration: const InputDecoration(
                                        hintText: ".....",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                addComments(
                                  detailList[2],
                                  commentController.text,
                                );
                              },
                              child: const LocaleText(
                                "article_detail_page_send_text",
                              ),
                            ),
                          ],
                        ),
                        StreamBuilder(
                          stream: commentStream,
                          builder: (context, AsyncSnapshot snapshot) {
                            return snapshot.data != null
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        onTap: () {},
                                        trailing: isMyComments.contains(snapshot
                                                .data.docs[index]["email"])
                                            ? IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.person,
                                                ),
                                              )
                                            : null,
                                        title: Text(
                                          snapshot.data.docs[index]["comment"],
                                        ),
                                        subtitle: Row(
                                          children: [
                                            const LocaleText(
                                              "article_detail_page_author_text",
                                            ),
                                            Text(
                                              snapshot.data.docs[index]["name"],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : const Center(
              child: Text("Boş Liste"),
            ),
    );
  }
}

class _BuildArticleDetailArea extends StatelessWidget {
  const _BuildArticleDetailArea({
    Key? key,
    required this.detailList,
  }) : super(key: key);

  final List detailList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 300.0,
          child: detailList[5].length != null
              ? Image.network(detailList[5])
              : const Text(
                  "Resim Yok",
                ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          detailList[2],
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 22.0,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          detailList[3],
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          detailList[7],
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        Row(
          children: [
            const LocaleText(
              "article_detail_page_more_text",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Flexible(
              child: TextButton(
                onPressed: () async {
                  await launch(detailList[4]);
                },
                child: Text(
                  detailList[4],
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const LocaleText(
              "article_detail_page_source_text",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Flexible(
              child: Text(
                detailList[0],
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Row(
          children: [
            const LocaleText(
              "article_detail_page_date_text",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Flexible(
              child: Text(
                detailList[6],
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
