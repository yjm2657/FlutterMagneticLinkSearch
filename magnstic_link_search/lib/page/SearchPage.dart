import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magnstic_link_search/page/SearchList.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = new ScrollController();
  TabController _tabController;
  FocusNode _searchFoc;
  String keyword;
  bool isShow = false;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {});
    _searchFoc = FocusNode();
    super.initState();
    _tabController = new TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: <Widget>[
              new Positioned(
                top: 86 + ScreenUtil.statusBarHeight / 2.0,
                left: 0,
                right: 0,
                height: 8,
                child: Container(
                  height: 4,
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0.0, 5.0),
                          blurRadius: 6.0,
                          color: Colors.black26),
                    ],
                  ),
                ),
              ),
              new Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 120,
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                    color: Colors.white,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('磁力搜索',
                                style: TextStyle(
                                    fontSize: 20,
                                    decoration: TextDecoration.none,
                                    color: Colors.black)),
                            IconButton(
                              icon: new Icon(
                                Icons.menu,
                                color: Color.fromRGBO(48, 190, 120, 1),
                              ),
                              splashColor: Colors.white,
                              onPressed: () {},
                            ),
                          ],
                        ),
                        Container(
                          width: ScreenUtil.screenWidth - 30,
                          height: 40,
                          decoration: new BoxDecoration(
                              color: Color.fromRGBO(250, 250, 250, 1),
                              border: new Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(48, 190, 120, 1)),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(20))),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                left: 15,
                                top: 0,
                                height: 42,
                                right: 50,
                                child: TextField(
                                  focusNode: _searchFoc,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                  decoration: InputDecoration(
                                      hintText: '请输入搜索关键字',
                                      border: InputBorder.none),
                                  onChanged: (text) {
                                    setState(() {
                                      keyword = text;
                                      _tabController.animateTo(0);
                                    });
                                    // _tabController.
                                  },
                                  onSubmitted: (text) {
                                    _searchFoc.unfocus();
                                    setState(() {
                                      keyword = text;
                                      _tabController.animateTo(0);
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                right: 5,
                                top: 0,
                                bottom: 5,
                                width: 40,
                                child: IconButton(
                                  icon: new Icon(Icons.search,
                                      color: Color.fromRGBO(175, 175, 175, 1)),
                                  onPressed: () {
                                    _searchFoc.unfocus();
                                    _tabController.animateTo(0);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              new Positioned(
                top: 110 + ScreenUtil.statusBarHeight / 2.0,
                left: 0,
                right: 0,
                height: 60,
                child: new TabBar(
                  labelColor: Color.fromRGBO(48, 190, 120, 1),
                  unselectedLabelColor: Colors.black87,
                  indicatorColor: Color.fromRGBO(48, 190, 120, 1),
                  tabs: <Widget>[
                    new Tab(
                      icon: new Icon(
                        Icons.all_inclusive,
                      ),
                      text: '综合',
                    ),
                    new Tab(
                      icon: new Icon(
                        Icons.hot_tub,
                        size: 18,
                      ),
                      text: '热门',
                    ),
                    new Tab(
                      icon: new Icon(
                        Icons.scanner,
                        size: 18,
                      ),
                      text: '大小',
                    ),
                    new Tab(
                      icon: new Icon(
                        Icons.timelapse,
                        size: 18,
                      ),
                      text: '时间',
                    ),
                  ],
                  controller: _tabController,
                ),
              ),
              new Positioned(
                  top: 170 + ScreenUtil.statusBarHeight / 2.0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: new TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      SearchList(keyword: keyword),
                      SearchList(
                          sortProperties: 'download_count', keyword: keyword),
                      SearchList(
                          sortProperties: 'content_size', keyword: keyword),
                      SearchList(
                          sortProperties: 'created_time', keyword: keyword),
                    ],
                  ))
            ],
          ),
        ));
  }
}
