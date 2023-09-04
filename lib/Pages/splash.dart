import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_app_07_july_2023/Pages/Home.dart';

class Splash extends StatefulWidget{
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),(){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade300,
                Colors.blue.shade100
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/news.png',scale: 1.3,),
              Text('News Snack',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 45,fontStyle: FontStyle.italic),)
            ],
          ),
        ),
    );
  }
}