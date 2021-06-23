class Article {
  String source;
  String title;
  String url;
  String urlToImage;
  String id;
  int like;

  Article({
    this.source,
    this.title,
    this.url,
    this.urlToImage,
    this.id,
    this.like = 0,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: json['source'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      urlToImage: json['urlToImage'] as String,
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'source': source,
      'title': title,
      'url': url,
      'urlToImage': urlToImage,
      'id': id,
    };
  }
}
