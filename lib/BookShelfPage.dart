/**
 * 书城
 */
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'Entity.dart';
import 'dart:convert';
import 'BookInfoDetailPage.dart';
import 'Comments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BookChapterPage.dart';

List widgetsBookShelfAll= <int>[];//收藏书籍id列表

class BookShelfInfo extends StatefulWidget{
  @override
  createState()=> new BookShelfInfoState();

}
class BookShelfInfoState extends State<BookShelfInfo> {
  List widgetsBookShelf = <BookInfo>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBookShelfData();
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    loadBookShelfData();
  }
  @override
  Widget build(BuildContext context) {
    if(null==widgetsBookShelf||0==widgetsBookShelf.length){
      return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.red,
            backgroundColor: Comment.pageBgColor,
          ),
          home: new Scaffold(
            backgroundColor:Comment.pageBgColor,
            body:new Center(
              child: new Text('尚未收藏书籍...',style: TextStyle(fontSize: Comment.fontSizeBig)),
            ),
          )
      );
    }
    Widget bookInfoRecGv=new Container(
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
              itemCount: widgetsBookShelf.length,
              itemBuilder: (BuildContext context, int position) {
                return   new GestureDetector(
                  onLongPress:(){
                    deleteBookShelfInfo(widgetsBookShelf[position]);
                  },
                  onTap: (){
                    if(null!=widgetsBookShelf[position].chapterId){
                      //切换到上次阅读章节
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => new ChapterScreen(widgetsBookShelf[position].chapterId)),
                      );
                    }else{
                      //切换到书籍目录
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => new BookInfoScreen(widgetsBookShelf[position])),
                      );
                    }
                  },
                  child:  new Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      //  new Image.network(picUrls[index], fit: BoxFit.cover),
                      Expanded(
                        child:new CachedNetworkImage(
                          width: 80,
                          imageUrl:Comment.urlPic + widgetsBookShelf[position].bookPicUrl,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new Text(
                                widgetsBookShelf[position].bookName,//书名
                                style: new TextStyle(
                                  color: Comment.bookTxtColor,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.5,
                                  fontSize: Comment.fontSizeBig,
                                ),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              new Text(
                                "作者:"+widgetsBookShelf[position].bookAuthor,//作者
                                style: new TextStyle(
                                  color: Comment.bookTxtColor,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.5,
                                  fontSize: Comment.fontSizeMiddle,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              new Text(
                                "最新章节："+widgetsBookShelf[position].newestChapter,//最新章节
                                style: new TextStyle(
                                  color: Comment.bookTxtColor,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.5,
                                  fontSize: Comment.fontSizeMiddle,
                                ),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2
                              ),
                              new Text(
                                "上次阅读："+widgetsBookShelf[position].chapterName,//最新章节
                                style: new TextStyle(
                                  color: Comment.bookTxtColor,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.5,
                                  fontSize: Comment.fontSizeMiddle,
                                ),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],

                          ),
                          flex:3
                      ),
                    ],
                  ),
                );
              }),
          onRefresh: loadBookShelfData
      )
    );
    return Scaffold(
      body:bookInfoRecGv,
    );
  }
  //获取书架书籍信息
  Future<BookInfo> loadBookShelfData() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId=prefs.getString("userId");
    if(null==userId||""==userId){
      return null ;
    }
    http.Response responseCon=await http.get(Comment.urlBookShelfInfo+"?userId="+userId);
    Map<String, dynamic> resultData=json.decode(responseCon.body);
    var bookShelfInfoList=<BookInfo>[];
    resultData['data'].forEach((bookInfo){
      BookInfo mBookInfoTemp=new BookInfo.fromJson(bookInfo);
      widgetsBookShelfAll.add(mBookInfoTemp.id);
      if(""==mBookInfoTemp.chapterName||null==mBookInfoTemp.chapterName){
        mBookInfoTemp.chapterName="   ";
      }
      bookShelfInfoList.add(mBookInfoTemp);
    });

    setState(() {
      // widgetsRecommon = JSON.decode(response.body);
      widgetsBookShelf=bookShelfInfoList;
    });
  }
  deleteBookShelfInfo(BookInfo mBookInfo) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId=prefs.getString("userId");
    http.Response responseCon=await http.get(Comment.urlDelBookShelfInfo+"?userId="+userId+"&bookId="+mBookInfo.id.toString());
    loadBookShelfData();
  }
}


