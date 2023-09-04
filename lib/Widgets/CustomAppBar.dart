import 'package:flutter/material.dart';
class CustomAppBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Container(
     child: Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Text('News',style: TextStyle(color: Colors.deepOrange,fontSize: 30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
         SizedBox(width: MediaQuery.of(context).size.width*0.02,),
         Text('Snack',style: TextStyle(color: Colors.deepPurple,fontSize: 30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
       ],
     ),
   );
  }
}