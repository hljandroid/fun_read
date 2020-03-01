import 'dart:async';

import 'package:device_info/device_info.dart';
/**
 * 个人页面
 */
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'BookReward.dart';
import 'Entity.dart';
import 'dart:convert';
import 'BookInfoDetailPage.dart';
import 'Comments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LeaveMessagePage.dart';
import 'ManagerPersionInfoPage.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'WantToReadPage.dart';
import 'TeaWithMilkPage.dart';
import 'package:firebase_admob/firebase_admob.dart';
import'main.dart';

class PersonPlacePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PersonPlacePageState();
  }
}

class PersonPlacePageState extends State<PersonPlacePage> {
  String userId = "";
  String userRemark = "";
  String userName = "";
  String imagePath = "";
  int userIcons=0;
  File imageFile;
  bool loadAdFailure=false;//false

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: <String>[], // testDevices: Comment.testDevice != null ? <String>[Comment.testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );
/*  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    birthday: DateTime.now(),
    childDirected: false,
    designedForFamilies: false,
    gender: MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
    testDevices: <String>[], // Android emulators are considered test devices
  );*/
  Timer loadTimer;
  var countdownTime = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPersionInfo();
    FirebaseAdMob.instance.initialize(appId: Comment.adAppId);//FirebaseAdMob.testAppId);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          saveIcons(rewardAmount);
        });
      }
      if(event == RewardedVideoAdEvent.closed){
        //倒计时10秒，并加载广告
        startCountdown();
      }
      if(event == RewardedVideoAdEvent.failedToLoad){
        loadAdFailure=true;
        setState(() {});
      }
    };
    loadReward();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final  safeArea = MediaQuery.of(context).padding.top;//获取顶部状态栏高度
    Widget picShow;
    String rewardMes="";
    if(0==countdownTime){
      rewardMes="钱庄取银两";
      if(loadAdFailure){
        rewardMes="自动出货失败，点击手动取银两";
      }
    }else{
      rewardMes="银两自动出货倒计时"+countdownTime.toString()+"秒";
    }

    if (imageFile != null){
      picShow=new Container(
        width: 80,
        height: 80,
        child: new ClipOval(
            child:  new Image.file(imageFile)
        ),
      );
    }else{
      picShow=new Container(
        width: 80,
        height: 80,
        child: new ClipOval(
          child: new Image.asset(
            "images/one.jpg", fit: BoxFit.cover,),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(top:safeArea),
      child: new Stack(
        children: <Widget>[
          new Scaffold(
              backgroundColor: Comment.pageBgColor,
              body: new Column(
                children: <Widget>[
                  picShow,
                  new Text(
                    userName, //昵称
                    style: new TextStyle(
                      color: Comment.widgetTxtColor,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      fontSize: Comment.fontSizeBig,
                    ),
                  ),
                  new Text(
                    "银子："+userIcons.toString()+"两", //昵称
                    style: new TextStyle(
                      color: Comment.widgetTxtColor,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      fontSize: Comment.fontSizeMiddle,
                    ),
                  ),
                  new Text(
                    "签名："+userRemark, //签名
                    style: new TextStyle(
                      color: Comment.widgetTxtColor,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      fontSize: Comment.fontSizeSmall,
                    ),
                  ),
                  /*new MaterialButton(
                    color: Colors.white,
                    // 按下的背景色
                    splashColor: Colors.amberAccent,
                    // 水波纹颜色
                    colorBrightness: Brightness.light,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        side: BorderSide(
                            color: Color(0xFFFFFFFF),
                            style: BorderStyle.solid,
                            width: 2)),
                    clipBehavior: Clip.antiAlias,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    minWidth: double.infinity,
                    child: Container(
                      alignment: AlignmentDirectional.topStart,
                      padding: EdgeInsets.all(5.0),
                      child: new Text(
                        "请开发者喝奶茶", //昵称
                        style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    onPressed: () {
                      //EditPersionInfo
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new TeaWithMilkPage())
                      ).then((value){
                        loadPersionInfo();
                      });
                    },
                  ),*/
                  new MaterialButton(
                    color: Colors.white,
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
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    minWidth: double.infinity,
                    child: Container(
                      alignment: AlignmentDirectional.topStart,
                      padding: EdgeInsets.all(5.0),
                      child: new Text(
                        "留言板", //昵称
                        style: new TextStyle(
                          color: Comment.widgetTxtColor,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          fontSize: Comment.fontSizeBig,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                      new MaterialPageRoute(builder: (context)=>new LeaveMessagePage()));
                    },
                  ),
                  new MaterialButton(
                    color: Colors.white,
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
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    minWidth: double.infinity,
                    child: Container(
                      alignment: AlignmentDirectional.topStart,
                      padding: EdgeInsets.all(5.0),
                      child: new Text(
                        "书籍悬赏",
                        style: new TextStyle(
                          color: Comment.widgetTxtColor,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          fontSize: Comment.fontSizeBig,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context)=>new WantToReadPage()))
                          .whenComplete((){
                        register();
                      });
                    },
                  ),
                  new MaterialButton(
                    color: Colors.white,
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
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    minWidth: double.infinity,
                    child: Container(
                      alignment: AlignmentDirectional.topStart,
                      padding: EdgeInsets.all(5.0),
                      child: new Text(
                        rewardMes,
                        style: new TextStyle(
                          color: Comment.widgetTxtColor,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          fontSize: Comment.fontSizeBig,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    onPressed: () {
                      if(countdownTime>0){
                        return ;
                      }
                      if(loadAdFailure){
                        //广告加载失败，再次加载
                      //  loadAdFailure=false;
                        startCountdown();
                     //   loadReward();
                        return ;
                      }
                      RewardedVideoAd.instance.show().whenComplete((){
                      print("RewardedVideoAd show whenComplete ");
                      }).catchError((e){
                        loadAdFailure=true;
                        //广告加载失败，再次加载
                        startCountdown();
                      print("RewardedVideoAd show catchError "+e.toString());
                        Fluttertoast.showToast(
                            msg: "金币加载失败，请稍后重试",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.black45,
                            textColor: Colors.white,
                            fontSize: Comment.fontSizeMiddle
                        );
                      });
                    },
                  ),
                  new MaterialButton(
                    color: Colors.white,
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
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    minWidth: double.infinity,
                    child: Container(
                      alignment: AlignmentDirectional.topStart,
                      padding: EdgeInsets.all(5.0),
                      child: new Text(
                        "关于我们",
                        style: new TextStyle(
                          color: Comment.widgetTxtColor,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          fontSize: Comment.fontSizeBig,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            title:new Center(child: Text("关于我们"),),
                            content: Text("本站所有小说均由网友上传,转载至本站只是为了宣传本书让更多读者欣赏。如有侵权，请联系我们删除。"),
                          backgroundColor: Comment.pageBgColor,
                        ),
                      );
                    },
                  ),
                ],
              )
          ),
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new EditPersionInfo(
                    userName, userRemark, imagePath)),

              ).then((value){
                loadPersionInfo();
              }
              );
            },
            child: Container(
              alignment: AlignmentDirectional.topEnd,
              padding: EdgeInsets.all(5.0),
              child: new Text(
                "编辑", //昵称
                style: new TextStyle(
                  color:Comment.widgetTxtColor,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.5,
                  fontSize: Comment.fontSizeBig,
                ),
                textAlign: TextAlign.right,
              ),

            ),
          ),
        ],
      ),
    );
  }
  loadPersionInfo() async{
    await getPersonInfo();
   // await _cropImage();
  }
  getPersonInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userIdTemp = prefs.getString("userId");
    String userRemarkTemp = prefs.getString("userRemark");
    String userNameTemp = prefs.getString("userName");
    String imagePathTemp = prefs.getString("imagePath");
    if (""==userRemarkTemp||null == userRemarkTemp) {
      userRemarkTemp = "这个人很懒什么都没有留下";
    }
    if (""==userNameTemp||null == userNameTemp) {
      userNameTemp = "等待取名中";
      register();
    }

    userId=userIdTemp;
    userRemark=userRemarkTemp;
    userName=userNameTemp;
    imagePath=imagePathTemp;
    userIcons=prefs.getInt("userIcons");
    if(null==userIcons){
      userIcons=0;
    }
    if(null != imagePathTemp){
      imageFile=new File(imagePathTemp);
    }
    setState(() {
    });
  }
  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imagePath,
    );
    if (croppedFile != null) {
      imageFile = croppedFile;
    }
    setState(() {
    });
  }
  void saveIcons(int reward) async{
    //保存金币到本地
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(null==userIcons){
      userIcons=0;
      prefs.setInt("userIcons", userIcons);
      return ;
    }
    String userId=prefs.getString("userId");
    //上传数据到服务器
    http.Response responseCon=await http.get(Comment.urlUpdateUserIcons+"?userIcons="+reward.toString()+"&userId="+userId);
    Map<String, dynamic> result=json.decode(responseCon.body);
    if("1"==result["status"]){
      userIcons=userIcons+reward;
    }
    prefs.setInt("userIcons", userIcons);
  }
  void loadReward(){
/*    RewardedVideoAd.instance.load(
        adUnitId: RewardedVideoAd.testAdUnitId,
        targetingInfo: targetingInfo).then((value){
    }).whenComplete((){
      print("RewardedVideoAd ad  load complete");
    });*/

    print("RewardedVideoAd start load ");
    RewardedVideoAd.instance.load(
        adUnitId:Comment.rewardAdUnitId ,//RewardedVideoAd.testAdUnitId,
        targetingInfo: targetingInfo).whenComplete((){
          print("RewardedVideoAd load whenComplete ");
    }).catchError((e){
        print("RewardedVideoAd load catchError "+e.toString());
    });
  }
  startCountdown() {
    loadAdFailure=false;
    countdownTime = 11;
    final call = (timer) {
      setState(() {
        if (countdownTime < 1) {
          loadTimer.cancel();
        } else {
          countdownTime -= 1;
        }
      });
      if(5==countdownTime){
        loadReward();
      }
      print("RewardedVideoAd startCountdown "+countdownTime.toString());
    };

    loadTimer = Timer.periodic(Duration(seconds: 1), call);
  }

  Future register() async{
    String userId="";
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if(Platform.isIOS){
      IosDeviceInfo  iosDeviceInfo = await deviceInfo.iosInfo;
      userId=iosDeviceInfo.identifierForVendor.toString();
    }else if(Platform.isAndroid){
      AndroidDeviceInfo  androidDeviceInfo = await deviceInfo.androidInfo;
      userId=androidDeviceInfo.androidId.toString();
    }
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
    getPersonInfo();
  }
}