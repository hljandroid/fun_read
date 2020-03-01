/**
 * 留言板
 */
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Comments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LeaveMessagePage extends StatelessWidget{
  TextEditingController _message = TextEditingController();//获取输入值
  FocusNode focusNodeMessage = new FocusNode();//获取焦点
  BuildContext mContext;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final size =MediaQuery.of(context).size;
    mContext=context;
    return new Scaffold(
      backgroundColor: Comment.pageBgColor,
      appBar: new AppBar(
         title: new Text("留言板",style: TextStyle(fontSize: Comment.fontSizeBig)),
        leading: new IconButton(icon: new Icon(Icons.arrow_back_ios), onPressed: (){
          Navigator.pop(context);
        }),
        backgroundColor: Comment.appBarColor,
        centerTitle: true,),
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
                hintText: "请输入留言信息...",
              ),
              controller: _message,
              autofocus: false,
              focusNode: focusNodeMessage,
              minLines: 4,
              maxLines: 10,
              maxLength: 300,
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
          msg: "请输入留言信息",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: Comment.fontSizeMiddle
      );
    }else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("userId");
      String userName = prefs.getString("userName");
      String url=Comment.urlLeaveMessage+"?userId="+userId+"&userName="+userName+"&helpMessage="+mMessage;
      http.Response response=await http.get(url);
      Map<String, dynamic> result=json.decode(response.body);
      if("1"==result["status"]){
        //保存成功
        Navigator.pop(mContext,"save success");
      }
    }


  }
}