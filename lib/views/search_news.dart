import 'package:url_launcher/url_launcher.dart';

import 'package:cached_network_image/cached_network_image.dart';
import '../helper/newsdata.dart';
import '../model/newsmodel.dart';

import 'package:flutter/material.dart';

class SearchNews extends StatefulWidget {
  @override
  _SearchNewsState createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  TextEditingController _searchController = TextEditingController();
List<ArticleModel> articles = [];
  getNews(String query) async {
    News newsdata = News();
    await newsdata.searchNews(query);

    setState(() {
      articles = newsdata.datatobesavedin;
  if (articles.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "no results found!"),
                                              ),
                                            );
return;
}

    });
}
  @override
  Widget build(BuildContext context) {
print('riham$articles');
    return Scaffold(
      appBar: AppBar(
        title: Text('Search News'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter your search term',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {

                String searchTerm = _searchController.text;
if (searchTerm.isNotEmpty) {
getNews(searchTerm);
}
else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "the field can not be empty!"),
                                              ),
                                            );

}

              },
              child: Text('Search'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return NewsTemplate(
                    urlToImage: articles[index].urlToImage,
                    title: articles[index].title,
                    description: articles[index].description,
      url: articles[index].url,
              
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class NewsTemplate extends StatelessWidget {

  String title, description, url, urlToImage;
  NewsTemplate({ this.title = 'default title', this.description = 'default',  this.urlToImage = 'default url', this.url = 'default'});
  void launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url, mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(imageUrl: urlToImage, width: 380, height: 200, fit: BoxFit.cover,),
          ),

          SizedBox(height: 8),

          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black)),

          SizedBox(height: 8),

          Text(description, style: TextStyle(fontSize: 15.0, color: Colors.grey[800])),

          SizedBox(height: 16),

          TextButton(
            onPressed: () {
              launchURL(url);
            },
            child: Text("Read More", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),         
 ),

        ],
      ),
    );
  }
}
