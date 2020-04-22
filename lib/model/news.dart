class News {
  String newsId;

  String title;

  String body;

  String imageUrl;

  String publishedAtUtc;

  News();

  factory News.fromJson(Map<String, dynamic> json) {
    var news = News();
    news.newsId = json['newsId'];
    news.title = json['title'];
    news.body = json['body'];
    news.imageUrl = json['imageUrl'];
    news.publishedAtUtc = json['publishedAtUtc'];

    return news;
  }
}
