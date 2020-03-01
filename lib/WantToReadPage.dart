/**
 * 书籍悬赏
 */
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'BookInfoDetailPage.dart';
import 'BookReward.dart';
import 'Comments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Entity.dart';

class WantToReadPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WantToReadPageState();
  }

}
class WantToReadPageState extends State<WantToReadPage>{
  List mRewardList = <Reward>[];

  void initState() {
    // TODO: implement initState
    super.initState();
    LoadMyRewards();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final size =MediaQuery.of(context).size;
    if(null==mRewardList||0==mRewardList.length){
      return MaterialApp(

          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.red,
            backgroundColor: Comment.pageBgColor,
          ),
          home: new Scaffold(
            backgroundColor: Comment.pageBgColor,
            appBar: new AppBar(
              title: new Text("我的悬赏",style: TextStyle(fontSize: Comment.fontSizeBig)),
              leading: new IconButton(icon: new Icon(Icons.arrow_back_ios), onPressed: (){
                Navigator.pop(context);
              }),
              backgroundColor: Comment.appBarColor,
              centerTitle: true,
              actions: <Widget>[
                new RaisedButton(onPressed: (){
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context)=>new BookRewardPage())).whenComplete((){
                    LoadMyRewards();
                  });
                },
                  child: new Text(
                      '我要悬赏',
                      style: TextStyle(fontSize: Comment.fontSizeBig)
                  ),
                  textColor: Colors.white,
                  color: Comment.appBarColor,
                  splashColor: Colors.amberAccent,
                )
              ],
            ),
            body:new Center(
              child: new Text('尚未悬赏书籍...',style: TextStyle(fontSize: Comment.fontSizeLarge)),
            ),
          )
      );
    }
    Widget RewardGv=new Container(
        color: Comment.pageBgColor,
        //  padding: const EdgeInsets.all(32.0),
        // child: _BookInfoGV(widgetsBookShelf,context),
        child:RefreshIndicator(
            child: new ListView.separated(
                separatorBuilder:(context, index) {
                  return Container(
                    color: Colors.grey,
                    height: 3,
                  );
                },
                itemCount: mRewardList.length,
                itemBuilder: (BuildContext context, int position) {
                 Color bookHref= Comment.wantReadBookNameColor;
                  if(null==mRewardList[position].bookId||0==mRewardList[position].bookId){
                    bookHref=Colors.black;
                  }
                  return   new Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      new Expanded(child:
                      new Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            "悬赏书籍描述：",//悬赏信息
                            style: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.5,
                              fontSize: Comment.fontSizeMiddle,
                            ),
                            textAlign: TextAlign.left,
                            softWrap: true,
                            maxLines: 4,
                            textWidthBasis: TextWidthBasis.parent,
                            overflow: TextOverflow.ellipsis,
                          ),
                          new Text(
                            "  "+mRewardList[position].bookInfo.toString(),//悬赏信息
                            style: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.5,
                              fontSize: Comment.fontSizeBig,
                            ),
                            textAlign: TextAlign.left,
                            softWrap: true,
                            maxLines: 4,
                            textWidthBasis: TextWidthBasis.parent,
                            overflow: TextOverflow.ellipsis,
                          ),
                          new Container(
                           child: new Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: <Widget>[
                               new Text(
                                 mRewardList[position].createdTime,//悬赏时间
                                 style: new TextStyle(
                                   color: Colors.black,
                                   fontWeight: FontWeight.w800,
                                   fontFamily: 'Roboto',
                                   letterSpacing: 0.5,
                                   fontSize: Comment.fontSizeMiddle,
                                 ),
                                 textAlign: TextAlign.left,
                                 softWrap: true,
                                 maxLines: 1,

                               ),
                             ],
                           )
                          ),
                          new GestureDetector(
                            onTap:(){
                              BookInfo mBookInfo=new BookInfo();
                              if(null==mRewardList[position].bookId||0==mRewardList[position].bookId){
                                return;
                              }
                              mBookInfo.id=mRewardList[position].bookId;
                              //切换到书籍目录
                              Navigator.push(
                                context,
                                new MaterialPageRoute(builder: (context) => new BookInfoScreen(mBookInfo)),
                              );
                            } ,
                            child: new Text(
                              "开始阅读："+mRewardList[position].resultInfo,//书籍id
                              style: new TextStyle(
                                color: bookHref,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Roboto',
                                letterSpacing: 0.5,
                                fontSize: Comment.fontSizeBig,
                              ),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,

                            ),
                          )

                        ],

                      ),
                      ),

                    ],
                  );
                }),
            onRefresh: LoadMyRewards
        )
    );
      return Scaffold(
        backgroundColor: Comment.pageBgColor,
      appBar: new AppBar(
        title: new Text("我的悬赏"),
        leading: new IconButton(icon: new Icon(Icons.arrow_back_ios), onPressed: (){
        Navigator.pop(context);
        }),
        backgroundColor: Comment.appBarColor,
        centerTitle: true,
        actions: <Widget>[
          new RaisedButton(onPressed: (){
            Navigator.push(context,
                new MaterialPageRoute(builder: (context)=>new BookRewardPage())).whenComplete((){
              LoadMyRewards();
            });
          },
            child: new Text(
                '我要悬赏',
                style: TextStyle(fontSize: 20)
            ),
           textColor: Colors.white,
           color: Comment.appBarColor,
           splashColor: Colors.amberAccent,
          )
        ],
      ),
        body:RewardGv,
      );
  }
  Future<Reward>  LoadMyRewards() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId=prefs.getString("userId");
    if(null==userId||""==userId){
      return null ;
    }
    http.Response responseCon=await http.get(Comment.urlMyWantToReads+"?userId="+userId);
    Map<String, dynamic> resultData=json.decode(responseCon.body);
    if("1"== resultData['status']){
      mRewardList.clear();
    }
    resultData['data'].forEach((rewardInfo){
      Reward mRewardTemp=new Reward();
      mRewardList.add(mRewardTemp.fromJson(rewardInfo));
    });
    setState(() {
    });
  }
}

