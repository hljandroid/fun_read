import 'package:carousel_slider/carousel_slider.dart';
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

class BookCityInfo extends StatefulWidget{
  @override
  createState()=> new BookCityInfoState();
}
class BookCityInfoState extends State<BookCityInfo> {
  List<BookInfo> widgetsRecommon = [];
  List<BookInfo> widgetsHot = [];
  var _futureBuilderFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureBuilderFuture=loadBookCityInfoData();
   // loadBookCityInfoData();
  }
  @override
  Widget build(BuildContext context) {
   // var _futureBuilderFuture=loadBookCityInfoData();
    final size =MediaQuery.of(context).size;
    final width =size.width;

    return Scaffold(
     // backgroundColor: Comment.bookDetailColor,
      body: FutureBuilder<Map<String,List<BookInfo>>>(
         future: _futureBuilderFuture,
          builder: (context,AsyncSnapshot<Map<String,List<BookInfo>>> snapshot){
            if(!snapshot.hasData){
              return  new GestureDetector(
                onTap: (){
                 loadBookCityInfoData();
                },
                child:  new Center(
                  child:Text("书籍加载失败，请点击重试......",textAlign: TextAlign.center,),
                ),
              );
            }else{
              CarouselSlider hotBook = CarouselSlider(
                viewportFraction: 0.9,
                aspectRatio: 2.0,
                autoPlay: true,
                enlargeCenterPage: true,
                items: widgetsHot.map(
                      (mBookInfo) {
                    return
                      Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: <Widget>[
                          Container(
                            width: width - 50,
                            height: (width - 50) / 1.5,
                            child: new CachedNetworkImage(
                              imageUrl:Comment.urlPic +  mBookInfo.bookPicUrl,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              width: width - 50,
                              height:(width - 50) / 1.5,
                              fit: BoxFit.cover,
                            ),
                            decoration: BoxDecoration(color: Color(0x90000000)),
                          ),
                          Container(
                            child:  Center(
                              child:  new GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(builder: (context) => new BookInfoScreen(mBookInfo)),
                                  );
                                },
                                //使用缓存图片
                                // child:new Image.network(picUrls[index], fit: BoxFit.cover),
                                child:   new CachedNetworkImage(
                                  imageUrl:Comment.urlPic +  mBookInfo.bookPicUrl,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                  },
                ).toList(),
              );
              return new ListView(
                children: <Widget>[
                  hotBook,
                  new Text(
                    "猜你喜欢",
                    style: new TextStyle(
                      color: Comment.bookTxtColor,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      fontSize: Comment.fontSizeBig,
                    ),
                  ),
                  new Container(
                      child: _BookInfoGV(snapshot.data["recmmond"],context),
                      color: Comment.pageBgColor,
                  ),
                  /*
                  new Text(
                    "热门书籍",
                    style: new TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      fontSize: 20.0,
                    ),
                  ),
                  new Container(
                    child: _BookInfoGV(snapshot.data["hot"],context),
                    color: Comment.pageBgColor,),
                    */
                ],
              ) ;
            }
          },
      ),
    );

  }
  //获取home书籍信息
  Future<Map<String,List<BookInfo>>>  loadBookCityInfoData() async{
    String urlCon=Comment.urlCon+"?id=12";
   // String urlCon="http://192.168.0.104:8080/app/recommend";
    http.Response responseCon=await http.get(urlCon);
    Map<String, dynamic> resultCon=json.decode(responseCon.body);
    var bookInfoList=resultCon['data'];
    var recBookInfoList=<BookInfo>[];
    bookInfoList.forEach((bookInfo){
      recBookInfoList.add(new BookInfo.fromJson(bookInfo));
    });
    http.Response responseHot=await http.get(Comment.urlHot);
    Map<String, dynamic> resultHot=json.decode(responseHot.body);
    var hotbookInfoListTemp=resultHot['data'];
    var hotBookInfoList=<BookInfo>[];
    hotbookInfoListTemp.forEach((bookInfo){
      hotBookInfoList.add(new BookInfo.fromJson(bookInfo));
    });
    widgetsRecommon=recBookInfoList;
    widgetsHot=hotBookInfoList;
   /* setState(() {
      // widgetsRecommon = JSON.decode(response.body);
      widgetsRecommon=recBookInfoList;
      widgetsHot=hotBookInfoList;
    });*/
   Map<String,List<BookInfo>> mMap=new Map<String,List<BookInfo>>();
    mMap["recmmond"]=recBookInfoList;
    mMap["hot"]=hotBookInfoList;
    return mMap;
  }
}
//创建gridview
Widget _BookInfoGV (List<BookInfo> mList,BuildContext context){

  return new GridView.count(
    physics: NeverScrollableScrollPhysics(),
    crossAxisCount: 3,//每行显示三个
    children: new List.generate(mList.length, (index){
      //  new Image.network(picUrls[index]);
      /* new CachedNetworkImage(
            placeholder: new CircularProgressIndicator(),
            imageUrl: 'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
          );*/
      return new Column(
        mainAxisSize: MainAxisSize.min,
        children:  [
          _sizedContainer(
            //  new Image.network(picUrls[index], fit: BoxFit.cover),
            new GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new BookInfoScreen(mList[index])),
                );
                },
              //使用缓存图片
              // child:new Image.network(picUrls[index], fit: BoxFit.cover),
              child:   new CachedNetworkImage(
                imageUrl:Comment.urlPic +  mList[index].bookPicUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          new Text(
            mList[index].bookName,//书名
            style: new TextStyle(
              color: Comment.bookTxtColor,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: Comment.fontSizeMiddle,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],

      );
      return Image.network(mList[index].bookPicUrl);
    }),
    shrinkWrap: true,
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