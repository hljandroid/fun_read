import 'dart:ui';

/**
 * 通用参数
 */
class Comment{
  // static const baseUrl="http://192.168.0.105:8080/";
   static const baseUrl="http://47.108.72.98:80/";
  static const urlCon=baseUrl+"app/recommend";//推荐书籍
  static const urlHot=baseUrl+"app/hot";//热门书籍
  static const urlBookChapterList=baseUrl+"app/phone-book-cataolog";//根据bookId获取书籍最新和开始目录信息
  static const urlBookAllChapterList=baseUrl+"app/book-cataolog";//根据bookId获取书籍所有目录信息
  static const urlBookChapterInfo=baseUrl+"app/chapter-info";//根据章节id获取章节内容
  static const urlRegist=baseUrl+"app/regist";//用户注册
  static const urlBookShelfInfo=baseUrl+"app/bookshelfinfo";//获取书架书籍信息
  static const urlDelBookShelfInfo=baseUrl+"app/del-bookshelf";//删除书架书籍信息
  static const urlAddBookShelfInfo=baseUrl+"app/add-bookshelf";//添加书架书籍信息
  static const urlSearchBookfInfo=baseUrl+"app/search";//检索书籍信息
  static const urlPic=baseUrl+"app/pic/";//检索书籍信息
  static const urlLeaveMessage=baseUrl+"app/save-leave-message";//留言
  static const urlWantToRead=baseUrl+"app/save-want-to-read";//书籍悬赏
  static const urlMyWantToReads=baseUrl+"app/user-want-to-read";//书籍悬赏
  static const urlBookInfo=baseUrl+"app/book-info";//获取书籍信息
  static const urlUpdateUserIcons=baseUrl+"app/update-user-icons";//更新银子
  static const urlUpdateUser=baseUrl+"app/update-user";//更新用户基本信息
  static const Color bookDetailColor=Color(0xFFFFFAFA);//书籍明细页面背景色
  static const Color chapterDetailColor=Color(0xFFFBF6EC);//阅读页面背景色
  static const Color pageBgColor=Color(0xFFFDF5E6);//主页面背景色
  static const Color wantReadBookNameColor=Color(0xFF90CAF9);//书籍悬赏中有结果时，书籍颜色
  static const Color buttonTxtColor=Color(0xFFFFFFFF);//按钮文字颜色
  static const Color buttonBgColor=Color(0xFF90CAF9);//按钮颜色
  static const Color buttonSplashColor=Color(0xFFFFE57F);//按钮颜色
  static const Color widgetTxtColor=Color(0xFF000000);//文字颜色
  static const Color bookTxtColor=Color(0xFF000000);//书籍信息文字颜色
  static const Color appBarColor=Color(0xFFEECBAD);//书籍信息文字颜色
   static const double fontSizeSmall=14;//小号字体
   static const double fontSizeMiddle=16;//中号字体
   static const double fontSizeBig=20;//大号字体
   static const double fontSizeLarge=24;//特大号字体
   //   static const String adAppId = "ca-app-pub-3506604574911396~5274565104";//admob ID
     static const String adAppId = "ca-app-pub-3506604574911396~2381073291";//admob ID tset
static const String rewardAdUnitId="ca-app-pub-3940256099942544/5224354917"; //video 测试广告id
// static const String rewardAdUnitId="ca-app-pub-3506604574911396/2666876779";//video 广告id
//  static const String rewardAdUnitId="ca-app-pub-3506604574911396/2381266288";//video 广告id

}