import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app_07_july_2023/Models/CountryNewsModal.dart';
import 'package:news_app_07_july_2023/Pages/SearchNews.dart';
import 'package:news_app_07_july_2023/Pages/detail.dart';
import 'package:news_app_07_july_2023/Widgets/CustomAppBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
class Home extends StatelessWidget{
  TextEditingController searchController=TextEditingController();
  bool isLoading=false;
  Future<CountryNewsModal> getCountryNews()async{
    isLoading=false;
    final response=await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?country=in&apiKey=cbd7634ef9d44d7eae393c496b2e0ae3'));
    var data=jsonDecode(response.body.toString());
    isLoading=true;
    if(response.statusCode==200){
      return CountryNewsModal.fromJson(data);
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: CustomAppBar(),
        ),
        body: Container(
          height: mediaQuery.height,
          width: mediaQuery.width,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: mediaQuery.height*0.015,),
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
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SearchNews(searchController.text.toString())));
                          }, icon: Icon(Icons.search,size: 35,))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: mediaQuery.height*0.01,),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    alignment: Alignment.centerLeft,
                    child: Text('Top Headlines',style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: mediaQuery.height*0.02,),
                  FutureBuilder(
                    future: getCountryNews(),
                      builder: (context,snapshot){
                      return !isLoading ? Container(
                        height: 150,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator()) : CarouselSlider(
                          items: snapshot.data!.articles!.map((e){
                            return Builder(
                                builder: (BuildContext context){
                                  return InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Detail(e.url.toString())));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(e.urlToImage.toString()),fit: BoxFit.cover
                                          ),
                                          borderRadius: BorderRadius.circular(15.0)
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
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
                                          ),
                                          Positioned(
                                            child: Text(e.source!.name.toString(),style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),),
                                            left: 10,
                                            bottom: 10,
                                          )

                                        ],
                                      ),
                                    ),
                                  );
                                }
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 150,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            enlargeCenterPage: true,
                          )
                      );
                      }
                  ),
                  SizedBox(height: mediaQuery.height*0.02,),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    alignment: Alignment.centerLeft,
                    child: Text('Latest India Top Headlines',style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: mediaQuery.height*0.02,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                    height: mediaQuery.height*0.45,
                    child: FutureBuilder(
                      future: getCountryNews(),
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
      ),
    );
  }
}