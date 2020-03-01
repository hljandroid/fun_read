/*
*书籍悬赏，消耗银子悬赏书籍
*/
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Comments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Entity.dart';

class BookRewardPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BookRewardPageState();
  }
}

class BookRewardPageState extends State<BookRewardPage>{
  TextEditingController _message = TextEditingController();//获取输入值
  FocusNode focusNodeMessage = new FocusNode();//获取焦点
  int userIcons=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserIcons();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final size =MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: Comment.pageBgColor,
      appBar: new AppBar(
         title: new Text("发起悬赏",style: TextStyle(fontSize: Comment.fontSizeBig)),
        leading: new IconButton(icon: new Icon(Icons.arrow_back_ios), onPressed: (){
          Navigator.pop(context);
        }),
        centerTitle: true,
        backgroundColor: Comment.appBarColor,
      ),
      body: new Column(
        mainAxisAlignment:MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
            child: TextField(
              style: TextStyle(
                fontSize: Comment.fontSizeBig,
              ),
              cursorColor:Colors.blue,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "请输入书籍名称及作者...",
              ),
              controller: _message,
              autofocus: false,
              focusNode: focusNodeMessage,
              minLines: 2,
              maxLines: 3,
              maxLength: 30,
            ),
          ),
          Container(
            alignment: AlignmentDirectional.topStart,
            // child: IconButton(icon:new Icon(Icons.favorite_border, color: Colors.blue),onPressed: saveMessage),
            child:  Text(
              '当前拥有'+userIcons.toString()+"两银子",
              style: TextStyle(fontSize:  Comment.fontSizeBig)
              ),
          ),
          Container(
              alignment: AlignmentDirectional.topEnd,
              child: new MaterialButton(
                color: Comment.buttonBgColor,
                // 按下的背景色
                splashColor: Comment.buttonSplashColor,
                // 水波纹颜色
                colorBrightness: Brightness.light,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    side: BorderSide(
                        color: Color(0xFFFFFFFF),
                        style: BorderStyle.solid,
                        width: 2)),
                clipBehavior: Clip.antiAlias,
                //materialTapTargetSize: MaterialTapTargetSize.padded,
                child:  new Text(
                  "保存", //昵称
                  style: new TextStyle(
                    color:Comment.buttonTxtColor,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.5,
                    fontSize: Comment.fontSizeBig,
                  ),
                  textAlign: TextAlign.right,
                ),
                onPressed: () {
                  saveMessage();
                  focusNodeMessage.unfocus();
                },
              )
          ),
        ],
      ),
    );

  }
  void saveMessage() async{
    String mMessage=_message.text;
    if(""==mMessage){
      Fluttertoast.showToast(
          msg: "请输入书籍名称及作者...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: Comment.fontSizeBig,
      );
      return;
    }
    if(userIcons<1000){
      Fluttertoast.showToast(
          msg: "您的银两不足1000两，请从钱庄中取足银两后再来",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: Comment.fontSizeBig
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("提示"),
          content: Text("悬赏将消耗1000两银子"),
          actions: <Widget>[
            RaisedButton(
              onPressed: (){
                saveRewardInfo(mMessage);
                Navigator.pop(context);
              },
              child: Text(
                  '确认',
                  style: TextStyle(fontSize: Comment.fontSizeBig)
              ),
              textColor: Comment.buttonTxtColor,
              color: Comment.buttonBgColor,
              splashColor: Comment.buttonSplashColor,
            ),
            RaisedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(
                  '取消',
                  style: TextStyle(fontSize: Comment.fontSizeBig)
              ),
              textColor: Comment.buttonTxtColor,
              color: Comment.buttonBgColor,
              splashColor:  Comment.buttonSplashColor,
            ),
          ]),
    );
  }
  saveRewardInfo(String bookInfo) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");
    String userName = prefs.getString("userName");
    String url=Comment.urlWantToRead+"?userId="+userId+"&userName="+userName+"&bookInfo="+bookInfo+"&id=1000";
    http.Response response=await http.get(url);
    Map<String, dynamic> result=json.decode(response.body);
    if("1"==result["status"]){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("userIcons", userIcons-1000);
      //保存成功
      Navigator.pop(context,"save success");
    }
  }
  Future loadUserIcons() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId=prefs.getString("userId");
    http.Response responseCon=await http.get(Comment.urlRegist+"?userId="+userId);
    Map<String, dynamic> resultUserInfo=json.decode(responseCon.body);
    User mUserTemp=new User();
    mUserTemp=mUserTemp.fromJson(resultUserInfo['data']);
    saveUserInfo(mUserTemp);
  }
  saveUserInfo(User mUser) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", mUser.userId);
    prefs.setString("userRemark", mUser.userRemark);
    prefs.setString("userName", mUser.userName);
    prefs.setInt("userIcons", mUser.userIcons);
    userIcons=mUser.userIcons;
    if(null==userIcons){
      userIcons=0;
    }
    setState(() {

    });
  }
}
