import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app_07_july_2023/Models/SearchNewsModal.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_07_july_2023/Pages/detail.dart';
class SearchNews extends StatefulWidget{
  final news;
  SearchNews(this.news);

  @override
  State<SearchNews> createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  TextEditingController searchController=TextEditingController();

 late String query=widget.news;

  bool isLoading=false;

  Future<SearchNewsModal> getSearchedNews()async{
    isLoading=false;
    final response=await http.get(Uri.parse('https://newsapi.org/v2/everything?q=$query&from=2023-08-31&sortBy=popularity&apiKey=cbd7634ef9d44d7eae393c496b2e0ae3'));
    var data=jsonDecode(response.body.toString());
    isLoading=true;
    if(response.statusCode==200){
      return SearchNewsModal.fromJson(data);
    }else{
      return throw Exception('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context).size;
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: Container(
          height: mediaQuery.height,
          width: mediaQuery.width,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: mediaQuery.height*0.02,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: searchController,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                  hintText: 'Search News Here',
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                          IconButton(onPressed: (){
                              query=searchController.text.toString();
                              setState(() {
                              searchController.clear();
                              });
                          }, icon: Icon(Icons.search,size: 35,))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: mediaQuery.height*0.02,),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    alignment: Alignment.centerLeft,
                    child: Text('${query.toUpperCase()} HEADLINES',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 1,),
                  ),
                  SizedBox(height: mediaQuery.height*0.02,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                    height: mediaQuery.height*0.78,
                    child: FutureBuilder(
                      future: getSearchedNews(),
                      builder: (context,snapshot){
                        return !isLoading? Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ) :  ListView.builder(
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: snapshot.data!.articles!.length,
                            itemBuilder: (context,index){
                              return  InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Detail(snapshot.data!.articles![index].url.toString())));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 16.0),
                                  height: mediaQuery.height*0.3,
                                  width: mediaQuery.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(snapshot.data!.articles![index].urlToImage.toString()),fit: BoxFit.cover
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 8.0,bottom: 8.0),
                                        alignment: Alignment.bottomLeft,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter
                                            ),
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Positioned(
                                          child: Text(snapshot.data!.articles![index].title.toString(),style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}