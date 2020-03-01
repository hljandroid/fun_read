/**
 * 书籍信息
 */
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

@JsonSerializable()
class BookInfo{
  int id;
  String bookName;
  String bookPicUrl;
  String bookAuthor;
  String bookContent;
  String bookType;
  String bookStatus;
  String newestChapter;
  int readChapterId;
  int chapterId;//上次阅读章节ID
  String chapterName;//上次阅读章节名称
  BookInfo({this.id,this.bookName,this.bookPicUrl,this.bookAuthor,this.bookContent,this.bookType,
    this.bookStatus,this.newestChapter,this.readChapterId,this.chapterId,this.chapterName});
  factory BookInfo.fromJson(Map<String, dynamic> json){
    return BookInfo(
    id:json['id'],
    bookName:json['bookName'],
    bookPicUrl:json['bookPicUrl'],
    bookAuthor:json['bookAuthor'],
    bookContent:json['bookContent'],
    bookType:json['bookType'],
    bookStatus:json['bookStatus'],
    newestChapter:json['newestChapter'],
    readChapterId:json['readChapterId'],
    chapterId:json['chapterId'],
    chapterName:json['chapterName'],
    );
  }
}
@JsonSerializable()
class BookInfoAyy{
  int msg;
  String status;
  List<BookInfo> data;
  BookInfoAyy({this.msg,this.status,this.data});
  factory BookInfoAyy.fromJson(Map<String, dynamic> bookInfo){
    var hotBookInfoMap=bookInfo['data'] as List;// <BookInfo>[];
    List<BookInfo> hotBookInfoList = hotBookInfoMap.map((i) => BookInfo.fromJson(i)).toList();
    /*bookInfo['data'].forEach((json){
      BookInfo mBookInfo=new BookInfo(
        id:json['id'],
        bookName:json['bookName'],
        bookPicUrl:json['bookPicUrl'],
        bookAuthor:json['bookAuthor'],
        bookContent:json['bookContent'],
        bookType:json['bookType'],
        bookStatus:json['bookStatus'],
        newestChapter:json['newestChapter'],
        readChapterId:json['readChapterId'],
      );
      hotBookInfoList.add(mBookInfo);
    });*/

    return BookInfoAyy(msg:bookInfo['msg'],status:bookInfo['status'],data:hotBookInfoList);
  }
}

@JsonSerializable()
class ChapterInfo{
  int id;
  int bookId;
  int chapterId;
  int nextChapterId;
  int lastChapterId;
  String content;
  String chapterName;
  String chapterHref;
  String nextChapterHref;//下一章
  String lastChapterHref;//上一章
  ChapterInfo({this.id,this.bookId,this.chapterId,this.nextChapterId,this.lastChapterId,this.content,
    this.chapterName,this.chapterHref,this.nextChapterHref,this.lastChapterHref});
  ChapterInfo fromJson(Map<String, dynamic> json){
    return ChapterInfo(id:json['id'],
      bookId: json['bookId'],
      chapterId: json['chapterId'],
      nextChapterId: json['nextChapterId'],
      lastChapterId: json['lastChapterId'],
      content: json['content'],
      chapterName: json['chapterName'],
      chapterHref: json['chapterHref'],
      nextChapterHref: json['nextChapterHref'],
      lastChapterHref: json['lastChapterHref'],
    );
  }
}
@JsonSerializable()
class User {
  int id;
  String userId;
  String userAccount;
  String userPassword;
  String userName;
  String userPhone;
  String userRemark;
  String userStatus;
  String createdTime;
  String updatedTime;
  int userIcons;
  User({this.id,this.userId,this.userAccount,this.userPassword,
    this.userName,this.userPhone,this.userRemark,this.userStatus,this.userIcons});
  User fromJson(Map<String, dynamic> json){
      return User(
        id:json['id'],
        userId:json['userId'],
        userAccount:json['userAccount'],
        userPassword:json['userPassword'],
        userName:json['userName'],
        userPhone:json['userPhone'],
        userRemark:json['userRemark'],
        userStatus:json['userStatus'],
        userIcons:json['userIcons'],
      );
  }
}

@JsonSerializable()
class Reward {
  int id;
  String userId;
  String userName;
  String bookInfo;
  String resultInfo;
  String status;
  String createdTime;
  String updatedTime;
  int bookId;

  Reward({this.id, this.userId, this.userName, this.bookInfo,
    this.resultInfo, this.status, this.createdTime, this.updatedTime,this.bookId});

  Reward fromJson(Map<String, dynamic> json) {
    String resultInfo="";
   if(null!=json['resultInfo']){
      resultInfo=json['resultInfo'];
    }
    int bookId=0;
    if(null!=json['bookId']){
      bookId=json['bookId'];
    }
  String createdTimeTemp= json['createdTime'];
  if(null!=createdTimeTemp&&createdTimeTemp.length>=10){
    createdTimeTemp=createdTimeTemp.substring(0,10);
  }
    return Reward(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      bookInfo: json['bookInfo'],
      resultInfo: resultInfo,
      status: json['status'],
      createdTime: createdTimeTemp,
      updatedTime: json['updatedTime'],
      bookId: bookId,
    );
  }
}