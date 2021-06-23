class DetailArticle {
  String author;
  String source;
  String title;
  String description;
  String urlToImage;
  String publishedAt;
  String content;

  DetailArticle({
    this.author,
    this.source,
    this.title,
    this.description,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory DetailArticle.fromJson(Map<String, dynamic> json) {
    return DetailArticle(
      source: json['source'] as String,
      author: json['author'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      urlToImage: json['urlToImage'] as String,
      publishedAt: json['publishedAt'] as String,
      content: json['content'] as String,
    );
  }
}
