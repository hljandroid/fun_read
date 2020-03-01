/**
 * 请开发者喝奶茶
 */
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Comments.dart';

import 'package:firebase_admob/firebase_admob.dart';

// You can also test with your own ad unit IDs by registering your device as a
// test device. Check the logs for your device's ID value.
const String testDevice = 'ca-app-pub-3506604574911396~5274565104';

class TeaWithMilkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return new Scaffold(
      appBar: new AppBar(
        // title: new Text(""),
        leading: new IconButton(icon: new Icon(Icons.arrow_back_ios), onPressed: (){
          Navigator.pop(context);
        }),
        centerTitle: true,),
      body: new CachedNetworkImage(
        width: width,
        height: height,
        imageUrl:Comment.urlPic +  "teaWithMilk.jpg",
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
