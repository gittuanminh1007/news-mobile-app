import 'dart:convert';

import 'package:http/http.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/detail_article_model.dart';

class ApiService {
  final endPointUrl = 'http://192.168.13.105:5000/';

  Future<List<Article>> getNewsByType(type, source) async {
    if (source == 'All') {
      Response res = await get(endPointUrl + 'get-all-news/' + type);

      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);

        List<dynamic> body = json['news'];

        List<Article> news =
            body.map((dynamic item) => Article.fromJson(item)).toList();

        return news;
      } else {
        throw ("Can't get the News");
      }
    } else if (source == 'Tuổi trẻ') {
      Response res = await get(endPointUrl + 'get-tuoi-tre/' + type);

      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);

        List<dynamic> body = json['news'];

        List<Article> news =
            body.map((dynamic item) => Article.fromJson(item)).toList();

        return news;
      } else {
        throw ("Can't get the News");
      }
    } else if (source == 'VNExpress') {
      Response res = await get(endPointUrl + 'get-vnexpress/' + type);

      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);

        List<dynamic> body = json['news'];

        List<Article> news =
            body.map((dynamic item) => Article.fromJson(item)).toList();

        return news;
      } else {
        throw ("Can't get the News");
      }
    } else if (source == 'Zing News') {
      Response res = await get(endPointUrl + 'get-zing/' + type);

      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);

        List<dynamic> body = json['news'];

        List<Article> news =
            body.map((dynamic item) => Article.fromJson(item)).toList();

        return news;
      } else {
        throw ("Can't get the News");
      }
    }
  }

  Future<DetailArticle> getNewsByUrl(source, url) async {
    Response res =
        await get(endPointUrl + 'get-new-by-url/' + source + "/" + url);

    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      DetailArticle news = DetailArticle.fromJson(json);

      return news;
    } else {
      throw ("Can't get the News");
    }
  }

  Future<List<String>> getListTitle() async {
    Response res = await get(endPointUrl + 'get-all-news/new');

    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> body = json['news'];

      List<Article> news =
          body.map((dynamic item) => Article.fromJson(item)).toList();

      List<String> titles = news.map((item) => item.title);

      return titles;
    } else {
      throw ("Can't get the News");
    }
  }
}
