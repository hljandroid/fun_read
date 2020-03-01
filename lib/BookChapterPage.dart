/**
 * 章节内容详情
 */
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Entity.dart';
import 'dart:convert';
import 'Comments.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BookInfoDetailPage.dart';

// 书籍详情页面 start
class ChapterScreen extends StatefulWidget{
 // ChapterInfo mChapterInfo;

  int chapterId;
  int bookId=0;
  ChapterScreen(int chapterId){
    this.chapterId=chapterId;
  }
  @override
  createState()=>new ChapterScreenState(chapterId);
}
class ChapterScreenState extends State<ChapterScreen>{
  double showPosition=0;
  List chapterList = [];
  ChapterInfo mChapterInfo;
  int chapterId;
  String userId="";
  ScrollController _controller = new ScrollController();
  ChapterScreenState(int chapterId){
    this.chapterId=chapterId;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBookChapterInfo();
    _controller.addListener((){
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;//获取屏幕高度
    final safeArea = MediaQuery.of(context).padding.top;//获取顶部状态栏高度
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor:  Comment.bookDetailColor,
        ),
        home: new Scaffold(
        appBar: null,
        body:  new GestureDetector(
            onTap: (){
              showPosition+=screenHeight-safeArea-30;//减去顶部状态栏高度
              _controller.jumpTo(showPosition);
            },
            child: SingleChildScrollView(
              controller: _controller,
                //true 滑动到底部
                reverse: false,
              //滑动到底部回弹效果
              physics: BouncingScrollPhysics(),
             child: new Container(
                padding: const EdgeInsets.fromLTRB(5,25,5,5),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      "${mChapterInfo.chapterName}",//章节名称
                      style: new TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        fontSize: Comment.fontSizeMiddle,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Html(
                        data: mChapterInfo.content,
                        padding: EdgeInsets.all(8.0),
                        backgroundColor: Comment.chapterDetailColor,
                        defaultTextStyle: TextStyle(fontFamily: 'serif'),
                        linkStyle: const TextStyle(
                          color: Colors.redAccent,
                        ),
                        onLinkTap: (url) {
                          // open url in a webview
                        },

                    ),
                    new Row(
                      mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: new GestureDetector(
                            onTap: (){
                              chapterId=mChapterInfo.lastChapterId;
                              if(0!=chapterId) {
                                showPosition=0;
                                _controller.jumpTo(showPosition);
                                loadBookChapterInfo();
                              }
                            },
                            child:  new Text(
                              "上一章",//章节ID
                              style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Roboto',
                                letterSpacing: 0.5,
                                fontSize: Comment.fontSizeMiddle,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: new GestureDetector(
                            onTap: (){
                              //mChapterInfo
                              BookInfo mBookInfo=new BookInfo();
                              mBookInfo.id=mChapterInfo.bookId;
                             // Navigator.of(context).pop();
                              //切换到书籍目录
                              Navigator.push(
                                context,
                                new MaterialPageRoute(builder: (context) => new BookInfoScreen(mBookInfo)),
                              );
                            },
                            child:  new Text(
                              "目录",
                              style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Roboto',
                                letterSpacing: 0.5,
                                fontSize: Comment.fontSizeMiddle,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: new GestureDetector(
                            onTap: (){
                              chapterId=mChapterInfo.nextChapterId;
                              if(0!=chapterId){
                                showPosition=0;
                                _controller.jumpTo(showPosition);
                                loadBookChapterInfo();
                              }
                            },
                            child:  new Text(
                              "下一章",//章节ID
                              style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Roboto',
                                letterSpacing: 0.5,
                                fontSize: Comment.fontSizeMiddle,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          flex: 1,
                        ),
                      ],
                    )
                  ],
                ),
              )
          )
        )
    )
    );
  }
  loadBookChapterInfo() async{
    if(""==userId){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("userId");
    }
    http.Response responseCon=await http.get(Comment.urlBookChapterInfo+"?chapterId="+chapterId.toString()+"&userId="+userId);
    Map<String, dynamic> resultChapterList=json.decode(responseCon.body);
    var bookChapterInfo=resultChapterList['data'];
    ChapterInfo mChapterInfoTemp=new ChapterInfo();

    setState(() {
      mChapterInfo=mChapterInfoTemp.fromJson(bookChapterInfo);
    });
  }
}
