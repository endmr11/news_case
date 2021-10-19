class ArticleDetailData {
  static List articleDetailDataList = [];

  void setArticleDetailData(
      String articleSource,
      String articleAuthor,
      String articleTitle,
      String articleDescription,
      String articleUrl,
      String articleUrlToImage,
      String articlePublishedAt,
      String articleContent) {
    articleDetailDataList.clear();
    articleDetailDataList.add(articleSource);
    articleDetailDataList.add(articleAuthor);
    articleDetailDataList.add(articleTitle);
    articleDetailDataList.add(articleDescription);
    articleDetailDataList.add(articleUrl);
    articleDetailDataList.add(articleUrlToImage);
    articleDetailDataList.add(articlePublishedAt);
    articleDetailDataList.add(articleContent);
  }

  List get getArticleDetails {
    return articleDetailDataList;
  }
}
