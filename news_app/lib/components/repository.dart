import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/app/pages/articles_detail_page.dart';
import 'package:news_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:news_app/components/slidable.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/detail_article_model.dart';
import 'package:news_app/services/api_service.dart';
import 'package:news_app/services/database.dart';
import 'package:provider/provider.dart';

class Repository extends StatelessWidget {
  const Repository({Key key}) : super(key: key);

  Future<void> _deleteArticle(BuildContext context, Article article) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteLink(article);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final ApiService client = ApiService();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Repository',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<List<Article>>(
        stream: database.repoStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final repo = snapshot.data;
            final children = repo
                .map(
                  (article) => SlidableWidget(
                    delete: () => _deleteArticle(context, article),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(
                            builder: (context) => FutureBuilder(
                              future: client.getNewsByUrl(
                                  article.source, article.url),
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
                                    image: NetworkImage(article.urlToImage),
                                    fit: BoxFit.cover),
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList();
            return ListView(
              children: children,
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Some error occured'));
          }
          return Center(child: CircularProgressIndicator());
        },
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
