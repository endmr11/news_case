class FavArticleModel {
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  FavArticleModel({
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory FavArticleModel.fromJson(Map<String, dynamic> json) =>
      FavArticleModel(
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"] as String,
        urlToImage: json["urlToImage"] as String,
        publishedAt: json["publishedAt"] as String,
        content: json["content"] as String,
      );

  /*Map<String, dynamic> toJson() => {

        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
        "content": content,
      };*/
}
