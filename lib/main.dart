import 'package:firebase_admob/firebase_admob.dart';
/**
 * 启动页面
 */
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'Entity.dart';
import 'dart:convert';
import 'HomePage.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Comments.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //判断是否注册，如果没有则自动注册
    loginInfo();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.red,
      ),
      //Stace 将布局叠加
      home: new Scaffold(
        body: new   HomeBookInfo(),

      ),
    );
  }
}
//判断是否注册，如果没有则自动注册
loginInfo() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId=prefs.getString("userId");
  if(null==userId){
    register();
  }
}
Future register() async{
  String userId="";
  DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
  User mUserTemp=new User();
  if(Platform.isIOS){
    IosDeviceInfo  iosDeviceInfo = await deviceInfo.iosInfo;
    userId=iosDeviceInfo.identifierForVendor.toString();
    mUserTemp.userPhone="IPHONE";
  }else if(Platform.isAndroid){
    AndroidDeviceInfo  androidDeviceInfo = await deviceInfo.androidInfo;
    userId=androidDeviceInfo.androidId.toString();
    mUserTemp.userPhone="ANDROID";
  }
  http.Response responseCon=await http.get(Comment.urlRegist+"?userId="+userId+"&userPhone="+mUserTemp.userPhone);
  Map<String, dynamic> resultUserInfo=json.decode(responseCon.body);

  mUserTemp=mUserTemp.fromJson(resultUserInfo['data']);
  saveUserInfo(mUserTemp);
}
saveUserInfo(User mUser) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("userId", mUser.userId);
  prefs.setString("userRemark", mUser.userRemark);
  prefs.setString("userName", mUser.userName);
  prefs.setInt("userIcons", mUser.userIcons);
}


