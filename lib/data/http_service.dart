import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_case/models/article_model.dart';

class HttpServices {
  Future<List<ArticleModel>> getAllArticles() async {
    var response = await http.get(
      Uri.parse(
          "https://newsapi.org/v2/top-headlines?country=tr&category=business"),
      headers: {
        'authorization': 'apikey f004edbb0aad4e319ae8f93c010eb5bf',
        'content-type': 'application/json',
      },
    );
    var status = jsonDecode(response.statusCode.toString());

    // ignore: avoid_print
    print("STATUS: $status");

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> articlesBody = jsonData['articles'];
    List<ArticleModel> articles =
        articlesBody.map((dynamic val) => ArticleModel.fromJson(val)).toList();
    return articles;
  }
}


//488687100f2044bfb01f22270a018930