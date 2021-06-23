import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:news_app/app/pages/articles_detail_page.dart';
import 'package:news_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/detail_article_model.dart';
import 'package:news_app/services/api_service.dart';
import 'package:news_app/services/database.dart';
import 'package:provider/provider.dart';

Future<void> _saveLink(BuildContext context, Article article) async {
  try {
    final database = Provider.of<Database>(context, listen: false);
    await database.saveLink(article);
  } on FirebaseException catch (e) {
    showExceptionAlertDialog(
      context,
      title: 'Openration failed',
      exception: e,
    );
  }
}

Widget customListTile(
    Article article, BuildContext context, ApiService client) {
  if (article.urlToImage != null) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(
            builder: (context) => FutureBuilder(
              future: client.getNewsByUrl(article.source, article.url),
              builder: (BuildContext context,
                  AsyncSnapshot<DetailArticle> snapshot) {
                if (snapshot.hasData) {
                  DetailArticle detailArticle = snapshot.data;
                  return ArticlePage(
                    article: detailArticle,
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(12.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3.0,
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(height: 8.0),
            Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30.0)),
                child: _getSource(article)),
            SizedBox(height: 8.0),
            Text(
              article.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                LikeButton(
                  size: 30,
                  circleColor: CircleColor(
                    start: Colors.redAccent,
                    end: Colors.red,
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.thumb_up_alt,
                      color: isLiked ? Colors.red : Colors.grey,
                      size: 30,
                    );
                  },
                  likeCount: article.like,
                  countBuilder: (int count, bool isLiked, String text) {
                    var color = isLiked ? Colors.red : Colors.grey;
                    Widget result;
                    if (count == 0) {
                      result = Text(
                        "Like",
                        style: TextStyle(color: color),
                      );
                    } else
                      result = Text(
                        text,
                        style: TextStyle(color: color),
                      );
                    return result;
                  },
                ),
                TextButton(
                  onPressed: () => _saveLink(context, article),
                  child: Icon(
                    Icons.bookmark,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  } else {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FutureBuilder(
              future: client.getNewsByUrl(article.source, article.url),
              builder: (BuildContext context,
                  AsyncSnapshot<DetailArticle> snapshot) {
                if (snapshot.hasData) {
                  DetailArticle detailArticle = snapshot.data;
                  return ArticlePage(
                    article: detailArticle,
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(12.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3.0,
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(30.0)),
              child: Text(
                article.source,
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              article.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }
}

Widget _getSource(Article article) {
  if (article.source == 'ttr')
    return Text(
      "Tuổi Trẻ",
      style: TextStyle(color: Colors.white),
    );
  if (article.source == 'vne')
    return Text(
      "VNEpress",
      style: TextStyle(color: Colors.white),
    );
  if (article.source == 'zn')
    return Text(
      "Zing News",
      style: TextStyle(color: Colors.white),
    );
}
