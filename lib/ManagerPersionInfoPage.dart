import 'package:fluttertoast/fluttertoast.dart';
/**
 * 个人信息编辑页面
 */
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'Entity.dart';
import 'dart:convert';
import 'BookInfoDetailPage.dart';
import 'Comments.dart';
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class EditPersionInfo extends StatefulWidget{
  String userRemark="";
  String userName="";
  String imagePath="";
  EditPersionInfo(String userName,String userRemark,String imagePath)
  {
    this.userName=userName;
    this.userRemark=userRemark;
    this.imagePath=imagePath;
  }
  @override
  createState()=> new EditPersionInfoState(userName,userRemark,imagePath);
}
enum AppState {
  free,
  picked,
  cropped,
}
class EditPersionInfoState extends State<EditPersionInfo>{
  AppState state;
  File imageFile;
  String userId="";
  String userRemark="";
  String userName="";
  String imagePath="";
  FocusNode focusNodeName = new FocusNode();
  FocusNode focusNodeRemark = new FocusNode();
  TextEditingController _searchName= TextEditingController();
  TextEditingController _searchRemark = TextEditingController();
  EditPersionInfoState(String userName,String userRemark,String imagePath)
  {
    this.userName=userName;
    this.userRemark=userRemark;
    this.imagePath=imagePath;
  }
  @override
  void initState() {
    super.initState();
    state = AppState.free;
    getPersonInfo();
    _cropImage();
    this._searchName.text=userName;
    this._searchRemark.text=userRemark;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final  safeArea = MediaQuery.of(context).padding.top;//获取顶部状态栏高度
    Widget picShow;
    if(null != imagePath){
      imageFile=new File(imagePath);
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
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.red,
      ),
      home: new Scaffold(
          backgroundColor: Comment.pageBgColor,
          appBar: new AppBar(
           // title: new Text(""),
            leading: new IconButton(icon: new Icon(Icons.arrow_back_ios), onPressed: (){
              Navigator.pop(context);
            }),
            backgroundColor: Comment.appBarColor,
            centerTitle: true,),
          body:new Column(
            children: <Widget>[
              new GestureDetector(
                onTap:(){
                  _pickImage();
                } ,
                child: picShow,
              ),
              new TextField(
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.5,
                  fontSize: Comment.fontSizeBig,
                ),
                cursorColor:Colors.blue,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: userName,
                ),
                controller: _searchName,
                autofocus: false,
                focusNode: focusNodeName,
                onChanged: (value){
                  print("1:"+userName);
                  initState()=>this._searchName.text=userName;
                },
              ),
              new   TextField(
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.5,
                  fontSize: Comment.fontSizeBig,
                ),
                cursorColor:Colors.blue,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: userRemark,
                ),

                controller: _searchRemark,
                autofocus: false,
                focusNode: focusNodeRemark,
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
                      saveInfo();
                    },
                  )
              ),
            ],
          ),
    ),
    );
  }
  saveInfo()async{
    userName=_searchName.text;
    userRemark=_searchRemark.text;
    if(""==userName||0==userName.trim().length){
      Fluttertoast.showToast(
          msg: "昵称不能为空",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: Comment.fontSizeBig
      );
      return ;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userRemark", userRemark);
    prefs.setString("userName", userName);
    if(null!=imagePath){
      prefs.setString("imagePath", imagePath);
    }
    http.Response responseCon=await http.get(Comment.urlUpdateUser+"?userName="+userName+"&userId="+userId+"&userRemark="+userRemark);
    Map<String, dynamic> responseUserInfo =json.decode(responseCon.body);
    if("2"==responseUserInfo["status"]){
      Fluttertoast.showToast(
          msg: "昵称已经被占用",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: Comment.fontSizeBig
      );
    }else{
      Navigator.pop(context,"save success");
    }
  }
  Future<Null> _pickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    imagePath=imageFile.path;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
    );
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }
  getPersonInfo () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId=prefs.getString("userId");
    userRemark=prefs.getString("userRemark");
    userName=prefs.getString("userName");
    imagePath=prefs.getString("imagePath");
    if(null==userId){

    }
    if(null==userRemark){
      userRemark="这个人很懒什么都没有留下";
    }
    if(null==userName){
      userName="等待取名中";
    }
  }
}