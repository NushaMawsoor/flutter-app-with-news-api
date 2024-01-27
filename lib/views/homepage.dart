import 'package:url_launcher/url_launcher.dart';

import 'search_news.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../helper/categorydata.dart';
import '../helper/newsdata.dart';
import '../model/categorymodel.dart';
import '../model/newsmodel.dart';
import '../views/categorypage.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

List<CategoryModel> categories = [];
List<ArticleModel> articles = [];
  bool _loading = true;

  getNews()  async {
    News newsdata = News();
    await newsdata.getNews();
    articles = newsdata.datatobesavedin;
    setState(() {
      _loading = false;
    });


  }


  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // this is to bring the row text in center
          children: <Widget>[

            Text("News",
              style: TextStyle(
                  color: Colors.blueAccent
              ),
            ),

          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'option1',
                  child: ListTile(
                    leading: Icon(Icons.search),
                    title: Text('brows articles'),
                  ),
                ),
                PopupMenuDivider(),
              ];
            },
            onSelected: (String value) {
              // Handle the selected option
              switch (value) {
                case 'option1':
                  // Perform delete operation
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => SearchNews(),
                    ),
                  );

                  break;
              }
            },
          ),
        ],

      ),


      // category widgets
       body: _loading ? Center(
         child: CircularProgressIndicator(

         ),

       ): SingleChildScrollView(
           child: Container(
             color: Colors.white,
             child: Column(

               children: <Widget>[
                Container(
                  height: 70.0,
                  padding: EdgeInsets.symmetric(horizontal: 12.0),

                  child: ListView.builder(

                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CategoryTile(
                        imageUrl: categories[index].imageUrl,
                        categoryName: categories[index].categoryName,
                      );
                      },

                  ),
                ),

                 Container(
                   child: ListView.builder(
                     itemCount:  articles.length,
                     physics: ClampingScrollPhysics(),
                     shrinkWrap: true, // add this otherwise an error
                     itemBuilder: (context, index) {

                       return NewsTemplate(
                         urlToImage: articles[index].urlToImage,
                         title: articles[index].title,
                         description: articles[index].description,
                       );


                     } ,
                   ),
                 ),



               ],
             ),
           ),
         ),
       );

  }
}


class CategoryTile extends StatelessWidget {
  final String categoryName, imageUrl;
  CategoryTile({ this.categoryName = 'default', this.imageUrl = 'default'});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        Navigator.push(context, MaterialPageRoute(
        builder: (context) => CategoryFragment(
          category: categoryName.toLowerCase(),
        ),
        ));

      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[


            ClipRRect(
              borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(imageUrl: imageUrl, width: 170, height: 90, fit: BoxFit.cover,)),


            Container(
              alignment: Alignment.center,
              width: 170, height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,


              ),
              child: Text(categoryName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),),
            ),

          ],
        ),
      ),
    );
  }
}

// creating template for news

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
