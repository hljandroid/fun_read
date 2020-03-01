/**
 * 检索页面
 */
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'Entity.dart';
import 'dart:convert';
import 'BookInfoDetailPage.dart';
import 'Comments.dart';

class SearchInfo extends StatefulWidget{
  @override
  createState()=>new SearchInfoState();
}
class SearchInfoState extends State<SearchInfo>{
  List<BookInfo> searchList=[];
  TextEditingController _search = TextEditingController();//获取输入值
  FocusNode focusNodeSearch = new FocusNode();//获取焦点
  ScrollController _scrollController;
  String key="";//检索关键字
  int page=1;//页码
  @override
  void initState() {
    // TODO: implement initState

    // 初始化ScrollController
    _scrollController = ScrollController();
    // 监听ListView是否滚动到底部
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        // 滑动到了底部
        // 这里可以执行上拉加载逻辑
        page++;
        loadSearchInfo();
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final  safeArea = MediaQuery.of(context).padding.top;//获取顶部状态栏高度
    return new Scaffold(
      backgroundColor: Comment.pageBgColor,
      body:
     new Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: safeArea, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(38.0),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(color: Colors.grey.withOpacity(0.2), offset: Offset(0, 2), blurRadius: 8.0),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                            child: TextField(
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              cursorColor:Colors.blue,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: "请输入作者或书名...",
                              ),
                              controller: _search,
                              autofocus: false,
                              focusNode: focusNodeSearch,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(38.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: Colors.grey.withOpacity(0.4), offset: Offset(0, 2), blurRadius: 8.0),
                        ],
                      ),
                      child:  IconButton(
                          icon: Icon(Icons.search),
                          onPressed: (){
                            focusNodeSearch.unfocus();
                            searchList.clear();
                            loadSearchInfo();
                            key=_search.text;
                            page=1;
                          }),
                    /*  child: Material(
                    //    color: Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                          onTap: () {
                            focusNodeSearch.unfocus();
                            searchList.clear();
                            loadSearchInfo();
                            key=_search.text;
                            page=1;
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.search, size: 30, color: Colors.amberAccent),
                          ),
                        ),
                      ),*/
                    ),
                  ],
                ),
              ),
              Flexible(
                child: new ListView.separated(
                    separatorBuilder:(context, index) {
                      return Container(
                        color: Colors.grey,
                        height: 3,
                      );
                    },
                    itemCount: searchList.length,
                    itemBuilder: (BuildContext context, int position) {
                      return   new GestureDetector(

                        onTap: (){
                          Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (context) => new BookInfoScreen(searchList[position])),
                          );
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
                                imageUrl: Comment.urlPic + searchList[position].bookPicUrl,
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
                                      searchList[position].bookName,//书名
                                      style: new TextStyle(
                                        color: Comment.bookTxtColor,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Roboto',
                                        letterSpacing: 0.5,
                                        fontSize: Comment.fontSizeBig,
                                      ),
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    new Text(
                                      "作者:"+searchList[position].bookAuthor,//作者
                                      style: new TextStyle(
                                        color: Comment.bookTxtColor,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Roboto',
                                        letterSpacing: 0.5,
                                        fontSize: Comment.fontSizeMiddle,
                                      ),
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    new Text(
                                      "分类：${searchList[position].bookType}",//分类
                                      style: new TextStyle(
                                        color: Comment.bookTxtColor,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Roboto',
                                        letterSpacing: 0.5,
                                        fontSize: Comment.fontSizeMiddle,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                                flex:3
                            ),
                          ],
                        ),
                      );
                    }),
              ),

            ],
          )

    );
  }
//获取home书籍信息
  loadSearchInfo() async{
    String url=Comment.urlSearchBookfInfo+"?page="+page.toString()+"&searchKey="+key;
    http.Response response=await http.get(url);
    Map<String, dynamic> result=json.decode(response.body);
    var bookInfoList=result['data'];
    var searchBookInfoList=<BookInfo>[];
    bookInfoList.forEach((bookInfo){
      searchBookInfoList.add(new BookInfo.fromJson(bookInfo));
    });
    setState(() {
      searchList.addAll(searchBookInfoList);
    });

  }
}
