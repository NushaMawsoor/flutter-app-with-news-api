import 'dart:convert';

import '../model/newsmodel.dart';
import 'package:http/http.dart' as http;

class News {

  // save json data inside this
  List<ArticleModel> datatobesavedin = [];


  Future<void> getNews() async {
String url = 'http://newsapi.org/v2/top-headlines?country=us&apiKey=ca8eb0178645429daae22fb15cd427ee';
      Uri uri = Uri.parse(url);
      http.Response response  = await http.get(uri);

    var jsonData = jsonDecode(response.body);


    if (jsonData['status'] == 'ok') {

      jsonData['articles'].forEach((element) {


        if (element['urlToImage']!=null && element['description']!=null) {

          // initliaze our model class

          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            url: element['url'],
          );
          datatobesavedin.add(articleModel);
        }

      });

    }
  }
  Future<void> searchNews(String keyword) async {
String url = 'http://newsapi.org/v2/top-headlines?country=us&q=$keyword&apiKey=ca8eb0178645429daae22fb15cd427ee';
      Uri uri = Uri.parse(url);
      http.Response response  = await http.get(uri);

    var jsonData = jsonDecode(response.body);


    if (jsonData['status'] == 'ok') {

      jsonData['articles'].forEach((element) {


        if (element['urlToImage']!=null && element['description']!=null) {

          // initliaze our model class

          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            url: element['url'],
          );


          datatobesavedin.add(articleModel);


        }


      });

    }




  }

}




// fetching news by  category
class CategoryNews {

  List<ArticleModel> datatobesavedin = [];


  Future<void> getNews(String category) async {
String url = 'http://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=ca8eb0178645429daae22fb15cd427ee';
      Uri uri = Uri.parse(url);
      http.Response response  = await http.get(uri);

    var jsonData = jsonDecode(response.body);


    if (jsonData['status'] == 'ok') {

      jsonData['articles'].forEach((element) {


        if (element['urlToImage']!=null && element['description']!=null) {

          // initliaze our model class

          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            url: element['url'],
          );


          datatobesavedin.add(articleModel);


        }


      });

    }




  }

}