import 'package:flutter/material.dart';
import 'package:news_app/models/detail_article_model.dart';

class ArticlePage extends StatelessWidget {
  final DetailArticle article;

  ArticlePage({this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(article.urlToImage), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(
              article.title,
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            article.publishedAt,
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            article.description,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            child: Text(
              article.content,
              style: TextStyle(fontSize: 16.0, letterSpacing: 1.0, height: 2.0),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                article.author,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              Text(
                'Nguồn: ' + article.source,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              )
            ],
          ),
        ],
      ),
    );
  }
}
