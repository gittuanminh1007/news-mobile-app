import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/services/api_path.dart';
import 'package:news_app/services/firestore_service.dart';

abstract class Database {
  Future<void> saveLink(Article article);
  Future<void> deleteLink(Article article);
  Stream<List<Article>> repoStream();
}

// DateTime documentIdFromCurrentDate() => DateTime.now();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> saveLink(Article article) => _service.setData(
        path: APIPath.article(uid, article.id),
        data: article.toMap(),
      );

  @override
  Future<void> deleteLink(Article article) => _service.deleteData(
        path: APIPath.article(uid, article.id),
      );

  @override
  Stream<List<Article>> repoStream() => _service.collectionStream(
        path: APIPath.repo(uid),
        builder: (data) => Article.fromJson(data),
      );
}
