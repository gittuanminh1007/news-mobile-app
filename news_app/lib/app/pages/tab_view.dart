import 'package:flutter/material.dart';
import 'package:news_app/components/custom_list_title.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/services/api_service.dart';

class TabView extends StatelessWidget {
  const TabView({
    Key key,
    @required this.client,
    @required this.type,
    @required this.selectedItem,
  }) : super(key: key);

  final ApiService client;
  final String type;
  final String selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: client.getNewsByType(type, selectedItem),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          if (snapshot.hasData) {
            List<Article> articles = snapshot.data;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) =>
                  customListTile(articles[index], context, client),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
