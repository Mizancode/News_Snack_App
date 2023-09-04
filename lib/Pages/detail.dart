import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class Detail extends StatefulWidget{
  final NewsUrl;
  Detail(this.NewsUrl);

  @override
  State<Detail> createState() => _DetailState();
}
class _DetailState extends State<Detail> {
   double _progress=0;
   late InAppWebViewController inAppWebViewController;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        var isLastPage=await inAppWebViewController.canGoBack();
        if(isLastPage){
          inAppWebViewController.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('WebView Detail Page'),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(widget.NewsUrl),
                ),
                onWebViewCreated: (InAppWebViewController controller){
                  inAppWebViewController=controller;
                },
                onProgressChanged: (InAppWebViewController controller,int progress){
                  setState(() {
                    _progress=progress/100;
                  });
                },
              ),
              _progress<1? Container(
                child: LinearProgressIndicator(
                  value: _progress,
                ),
              ):SizedBox()
            ],
          )
        ),
      ),
    );
  }
}