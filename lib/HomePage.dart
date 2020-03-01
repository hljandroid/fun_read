import 'package:flutter/material.dart';
import 'BookCity.dart';
import 'BookShelfPage.dart';
import 'Comments.dart';
import 'SearchPage.dart';
import 'package:flutter_app/MyPlacePage.dart';

class HomeBookInfo extends StatefulWidget{
  @override
  createState()=> new HomeBookInfoState();
}
class HomeBookInfoState extends State<HomeBookInfo> {
  int _currentIndex = 1;
  static Widget mBookShelfInfo=new BookShelfInfo();
  final List<Widget> _children = [mBookShelfInfo, BookCityInfo(), SearchInfo(), PersonPlacePage()];

  final List<BottomNavigationBarItem> _list = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.library_books),
      title: Text('书架'),
      //backgroundColor: Colors.orange
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('书城'),
      //backgroundColor: Colors.orange
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      title: Text('搜索'),
      //backgroundColor: Colors.orange
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      title: Text('个人'),
      //backgroundColor: Colors.orange
    ),
  ];
// 响应空白处的焦点的Node
  FocusNode blankNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Comment.pageBgColor,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: _list,
        backgroundColor: Comment.pageBgColor,
      ),
      //body: _children[_currentIndex],
      body:GestureDetector(
        onTap:(){FocusScope.of(context).requestFocus(blankNode);} ,
        child:  IndexedStack(
          index: _currentIndex,
          children: _children,
      ),),

    );
  }

  void onTabTapped(int index) {
    FocusScope.of(context).requestFocus(blankNode);
    setState(() {
      if(1==index){
        mBookShelfInfo.createElement();
      }
      _currentIndex = index;
    });
  }
}
