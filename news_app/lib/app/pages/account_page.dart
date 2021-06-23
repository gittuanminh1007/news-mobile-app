import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/common_widgets/avatar.dart';
import 'package:news_app/common_widgets/show_alert_dialog.dart';
import 'package:news_app/components/repository.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/detail_article_model.dart';
import 'package:news_app/services/api_service.dart';
import 'package:news_app/services/auth.dart';
import 'package:news_app/services/database.dart';
import 'package:provider/provider.dart';

import 'articles_detail_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionContext: 'Logout',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  _openRepository(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => Repository(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: Text(
          'Account',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _confirmSignOut(context),
            color: Colors.black,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(auth.currentUser),
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _openRepository(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.bookmark,
                  color: Colors.greenAccent,
                ),
                Text('Repository'),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: <Widget>[
        Avatar(
          photoUrl: user.photoURL,
          radius: 50,
        ),
        SizedBox(height: 8),
        if (user.displayName != null)
          Text(
            user.displayName,
            style: TextStyle(color: Colors.white),
          ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final ApiService client = ApiService();
    return StreamBuilder<List<Article>>(
      stream: database.repoStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final repo = snapshot.data;
          final children = repo
              .map(
                (article) => InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
                        builder: (context) => FutureBuilder(
                          future:
                              client.getNewsByUrl(article.source, article.url),
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
                          child: Text(
                            article.source,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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
    );
  }
}
