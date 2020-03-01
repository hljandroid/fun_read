/**
 * 书籍介绍和目录
 */
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'Entity.dart';
import 'dart:convert';
import 'Comments.dart';
import 'BookChapterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BookShelfPage.dart';

// 书籍详情页面 start
class BookInfoScreen extends StatefulWidget{
  BookInfo mBookInfo;//书籍信息
  BookInfoScreen(BookInfo mBookInfo){
    this.mBookInfo=mBookInfo;
  }
  @override
  createState()=>new BookInfoScreenState(mBookInfo);
}
class BookInfoScreenState extends State<BookInfoScreen>{
  List chapterListStart = [];//开始20个章节信息
  List chapterListLast = [];//最新6个章节信息
  List recommondbookInfo = [];//推荐书籍6本
  BookInfo mBookInfo;//书籍信息
  String userId="";//用户id
  bool collectionFlag=false;//是否收藏书籍
  ScrollController scrollController = ScrollController();

  BookInfoScreenState(BookInfo mBookInfo){
    this.mBookInfo=mBookInfo;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBookChapter();
    loadReCommendBook();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    Color collectionHeart;

    if(widgetsBookShelfAll.contains(mBookInfo.id)){
      collectionFlag=true;
    }else{
      collectionFlag=false;
    }
    if(collectionFlag){
      collectionHeart= Colors.red;
    }else{
      collectionHeart= Colors.black12;
    }
    if(null==mBookInfo.bookName||""==mBookInfo.bookName){
      return MaterialApp(
        color: Colors.blue,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor:  Comment.bookDetailColor,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text("书籍详情",style: TextStyle(fontSize: Comment.fontSizeBig)),
            leading: new IconButton(icon: new Icon(Icons.arrow_back_ios), onPressed: (){
              Navigator.pop(context);
            }),
            centerTitle: true,),
          body:new Center(
            child: new Text('数据加载中...'),
          ),
        )
      );
    }

    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Comment.bookDetailColor,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text("${mBookInfo.bookName}"),
            leading: new IconButton(icon: new Icon(Icons.arrow_back_ios), onPressed: (){
              Navigator.pop(context);
            }),
          centerTitle: true,),
          backgroundColor:Comment.bookDetailColor,
          body:
          new CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: new Row(
                  mainAxisAlignment:MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new CachedNetworkImage(
                      imageUrl:Comment.urlPic + mBookInfo.bookPicUrl,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: width/3,
                      height: 200,
                    ),
                    new Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment:CrossAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          "${mBookInfo.bookName}",//书名
                          style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize:Comment.fontSizeBig,
                            textBaseline: TextBaseline.ideographic,

                          ),
                          textAlign: TextAlign.left,

                        ),
                        new Text(
                          "作者:${mBookInfo.bookAuthor} ",//书名
                          style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize: Comment.fontSizeMiddle,
                            textBaseline: TextBaseline.alphabetic,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        new Text(
                          "分类：${mBookInfo.bookType}",//书名
                          style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize:  Comment.fontSizeMiddle,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    Expanded(
                      child:Container(
                          alignment: AlignmentDirectional.topEnd,
                          //  color: Colors.blue,
                          padding: EdgeInsets.all(5.0),
                          child:IconButton(icon: new Icon(Icons.favorite_border, color: collectionHeart), onPressed: bookToShelf)
                        //child: new Icon(Icons.favorite_border, color: collectionHeart),
                      ) ,
                      flex: 1,
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: new Text(
                  "简介:${mBookInfo.bookContent}",//书名
                  style: new TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.5,
                    fontSize:  Comment.fontSizeSmall,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.black12,
                  height: 3,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                    alignment: AlignmentDirectional.topEnd,
                    //  color: Colors.blue,
                  padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: new Text(
                    "最近更新",//书名
                    style: new TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      fontSize:Comment.fontSizeSmall,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  //child: new Icon(Icons.favorite_border, color: collectionHeart),
                ) ,
              ),
              new SliverList(
                delegate: new SliverChildBuilderDelegate(
                        (BuildContext context, int position) {
                      //创建列表项
                      return new GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (context) => new ChapterScreen(chapterListLast[position].chapterId)),
                          );
                        },
                        child:  new Text(
                          chapterListLast[position].chapterName,//章节名称
                          style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize: Comment.fontSizeMiddle,
                          ),
                        ),
                      );
                    },
                    childCount: chapterListLast.length //开始章节个列表项
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.black12,
                  height: 3,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                    alignment: AlignmentDirectional.topEnd,
                    //  color: Colors.blue,
                    child:MaterialButton(
                      onPressed: loadAllBookChapter,
                    child:  new Text(
                      "查看全部章节",//书名
                      style: new TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        fontSize: Comment.fontSizeSmall,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    )
                  //child: new Icon(Icons.favorite_border, color: collectionHeart),
                ) ,
              ),
            new SliverList(
              delegate: new SliverChildBuilderDelegate(
                      (BuildContext context, int position) {
                    //创建列表项
                    return new GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) => new ChapterScreen(chapterListStart[position].chapterId)),
                        );
                      },
                      child:  new Text(
                        chapterListStart[position].chapterName,//章节名称
                        style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          fontSize: Comment.fontSizeMiddle,
                        ),
                      ),
                    );
                  },
                  childCount: chapterListStart.length //开始章节个列表项
              ),
            ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.black12,
                  height: 3,
                ),
              ),
              SliverToBoxAdapter(
                child: new Row(
                  children: <Widget>[
                    new Text(
                      "读这本书的人还在读",//书名
                      style: new TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        fontSize: Comment.fontSizeSmall,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  Expanded(
                    child:Container(
                        alignment: AlignmentDirectional.topEnd,
                        //  color: Colors.blue,
                        padding: EdgeInsets.all(5.0),
                        child:IconButton(icon: new Icon(Icons.refresh, color: Colors.black12), onPressed: loadReCommendBook)
                      //child: new Icon(Icons.favorite_border, color: collectionHeart),
                    ) ,
                    flex: 1,
                  )
                  ],
                ),
              ),
              new SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3
                ),
                  delegate: new SliverChildBuilderDelegate(
                          (BuildContext context, int position) {
                        //创建列表项
                        return new Column(
                          mainAxisSize: MainAxisSize.min,
                          children:  [
                            _sizedContainer(
                              //  new Image.network(picUrls[index], fit: BoxFit.cover),
                              new GestureDetector(
                                onTap: (){
                                 /* Navigator.push(
                                    context,
                                    new MaterialPageRoute(builder: (context) => new BookInfoScreen(recommondbookInfo[position])),
                                  );*/
                                  mBookInfo.bookName="";
                                  mBookInfo.id=recommondbookInfo[position].id;
                                  loadBookChapter();

                                  },
                                //使用缓存图片
                                // child:new Image.network(picUrls[index], fit: BoxFit.cover),
                                child:   new CachedNetworkImage(
                                  imageUrl:Comment.urlPic +  recommondbookInfo[position].bookPicUrl,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            ),
                            new Text(
                              recommondbookInfo[position].bookName,//书名
                              style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Roboto',
                                letterSpacing: 0.5,
                                fontSize: Comment.fontSizeMiddle,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        );
                      },
                      childCount: recommondbookInfo.length //开始章节个列表项
                  ),

              )
           ],
          ),


          ),
    );
  }
  //初次加载书籍
  loadBookChapter() async{
    //只有书籍id，获取书籍信息
    if(null==mBookInfo.bookName||""==mBookInfo.bookName){
      http.Response responseBookInfo=await http.get(Comment.urlBookInfo+"?id="+mBookInfo.id.toString());
      Map<String, dynamic> responseBookInfoList=json.decode(responseBookInfo.body);
      if(null!=responseBookInfoList['data']){
        var bookChapterList=responseBookInfoList['data'];
        mBookInfo=new BookInfo.fromJson(bookChapterList);
      }
    }
    http.Response responseCon=await http.get(Comment.urlBookChapterList+"?bookId="+mBookInfo.id.toString());
    Map<String, dynamic> resultChapterList=json.decode(responseCon.body);
    var bookChapterList=resultChapterList['data'];
    var bookChapterListOther=resultChapterList['dataOther'];
    var recBookChapterList=<ChapterInfo>[];
    var recBookChapterListOther=<ChapterInfo>[];
    bookChapterList.forEach((bookInfo){
      ChapterInfo mChapterInfo=new ChapterInfo();
      recBookChapterList.add(mChapterInfo.fromJson(bookInfo));
    });
    bookChapterListOther.forEach((bookInfo){
      ChapterInfo mChapterInfo=new ChapterInfo();
      recBookChapterListOther.add(mChapterInfo.fromJson(bookInfo));
    });
    setState(() {
      // widgetsRecommon = JSON.decode(response.body);
      chapterListStart=recBookChapterList;
      chapterListLast=recBookChapterListOther;
      scrollController.jumpTo(0);//切换到顶部
    });
  }
  //加载推荐数据
  loadReCommendBook() async{
    String urlCon=Comment.urlCon+"?id=6";
    // String urlCon="http://192.168.0.104:8080/app/recommend";
    http.Response responseCon=await http.get(urlCon);
    Map<String, dynamic> resultCon=json.decode(responseCon.body);
    var bookInfoList=resultCon['data'];
    var recBookInfoList=<BookInfo>[];
    bookInfoList.forEach((bookInfo){
      recBookInfoList.add(new BookInfo.fromJson(bookInfo));
    });
     setState(() {
      // widgetsRecommon = JSON.decode(response.body);
       recommondbookInfo=recBookInfoList;
    });

}
//加载全部章节
  loadAllBookChapter() async{
    Fluttertoast.showToast(
        msg: "努力加载章节中...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0
    );
    //只有书籍id，获取书籍信息
    if(null==mBookInfo.bookName||""==mBookInfo.bookName){
      http.Response responseBookInfo=await http.get(Comment.urlBookInfo+"?id="+mBookInfo.id.toString());
      Map<String, dynamic> responseBookInfoList=json.decode(responseBookInfo.body);
      if(null!=responseBookInfoList['data']){
        var bookChapterList=responseBookInfoList['data'];
        mBookInfo=new BookInfo.fromJson(bookChapterList);
      }
    }
    http.Response responseCon=await http.get(Comment.urlBookAllChapterList+"?bookId="+mBookInfo.id.toString());
    Map<String, dynamic> resultChapterList=json.decode(responseCon.body);
    var bookChapterList=resultChapterList['data'];
    var recBookChapterList=<ChapterInfo>[];
    bookChapterList.forEach((bookInfo){
      ChapterInfo mChapterInfo=new ChapterInfo();
      recBookChapterList.add(mChapterInfo.fromJson(bookInfo));
    });
    setState(() {
      // widgetsRecommon = JSON.decode(response.body);
      chapterListStart=recBookChapterList;
    });
    Fluttertoast.showToast(
        msg: "已经加载完所有章节",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  Widget _sizedContainer(Widget child) {

    return new SizedBox(
      width: 120,
      height: 90.0,
      child: new Center(
        child: child,
      ),
    );
  }
  //收藏、删除书架书籍
 bookToShelf() async{
    if(""==userId){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("userId");
    }
    if(collectionFlag){
      //删除收藏
      http.Response responseCon=await http.get(Comment.urlDelBookShelfInfo+"?bookId="+mBookInfo.id.toString()+"&userId="+userId);
      Map<String, dynamic> result=json.decode(responseCon.body);
      if("1"==result["status"]){
        //删除成功
        widgetsBookShelfAll.remove(mBookInfo.id);
        setState(() {
         // collectionFlag=false;
        });
      }
    }else{
      //添加收藏
      http.Response responseCon=await http.get(Comment.urlAddBookShelfInfo+"?bookId="+mBookInfo.id.toString()+"&userId="+userId);
      Map<String, dynamic> result=json.decode(responseCon.body);
      if("1"==result["status"]){
        //添加成功
        widgetsBookShelfAll.add(mBookInfo.id);
        setState(() {
         // collectionFlag=true;
        });
      }
    }


 }
}

// 书籍详情页面 end
