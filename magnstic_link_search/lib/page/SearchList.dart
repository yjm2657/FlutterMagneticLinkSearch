import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magnstic_link_search/api/NetTool.dart';
import 'package:random_color/random_color.dart';
import 'package:magnstic_link_search/api/Api.dart';
import 'package:magnstic_link_search/api/NetTool.dart';
import 'package:magnstic_link_search/model/list_data_model.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchList extends StatefulWidget {
  var sortProperties;
  var keyword;
  SearchList({Key key, this.sortProperties, this.keyword}) : super(key: key);

  _SearchListState createState() => _SearchListState(sortProperties, keyword);
}

class _SearchListState extends State<SearchList> {
  List<ListDataModelResultContentModel> contentList =
      <ListDataModelResultContentModel>[];
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  final String sortProperties;
  final String keyword;
  var pageNum;

  _SearchListState(this.sortProperties, this.keyword);

  void _getListContentHttp() {
    if (keyword?.isEmpty ?? true) {
      return;
    }
    if (keyword.length < 2) {
      return;
    }
    var params;
    if (sortProperties != null && sortProperties.isNotEmpty) {
      params = {
        'page': pageNum.toString(),
        'word': keyword,
        'sortProperties': sortProperties
      };
    } else {
      params = {
        'page': pageNum.toString(),
        'word': keyword,
      };
    }

    NetTool.get(
        Api.SearchList,
        (data) {
          ListDataModel listdatamodel = ListDataModel.fromJson(data);

          if (!mounted) {
            return;
          }

          setState(() {
            if (pageNum == 1) {
              contentList = listdatamodel.data.result.content;
            } else {
              contentList.addAll(listdatamodel.data.result.content);
            }
          });
        },
        params: params,
        errorCallBack: (errorMsg) {
          print(errorMsg);
        });
  }

  @override
  void initState() {
    pageNum = 1;
    super.initState();
    _getListContentHttp();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getListContentHttp();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new EasyRefresh(
        key: _easyRefreshKey,
        child: ListView.builder(
          itemCount: contentList.length,
          itemBuilder: (BuildContext context, int index) {
            ListDataModelResultContentModel contentModel = contentList[index];
            return SearchListCell(content: contentModel);
          },
        ),
        onRefresh: () async {
          setState(() {
            pageNum = 1;
          });
          _getListContentHttp();
        },
        loadMore: () async {
          setState(() {
            pageNum++;
          });
          _getListContentHttp();
        },
      ),
    );
  }
}

class SearchListCell extends StatefulWidget {
  var content;

  SearchListCell({Key key, this.content}) : super(key: key);

  _SearchListCellState createState() => _SearchListCellState(content);
}

class _SearchListCellState extends State<SearchListCell> {
  RandomColor _randomColor = RandomColor();

  final ListDataModelResultContentModel contentModel;
  _SearchListCellState(this.contentModel);

  @override
  Widget build(BuildContext context) {
    Color _color = _randomColor.randomColor(colorHue: ColorHue.green);

    return Container(
      height: 60,
      child: Stack(
        children: <Widget>[
          new Positioned(
            left: 15,
            top: 10,
            bottom: 10,
            width: 40,
            child: Container(
              decoration: BoxDecoration(
                  color: _color,
                  borderRadius: new BorderRadius.all(Radius.circular(20))),
              child: Text(
                'P',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 20, color: Colors.black26, height: 1.4),
              ),
            ),
          ),
          new Positioned(
            left: 60,
            top: 10,
            height: 20,
            right: 125,
            child: Text(contentModel.title,
                style: TextStyle(fontSize: 14, color: Colors.black87)),
          ),
          new Positioned(
            left: 60,
            top: 35,
            height: 18,
            right: 115,
            child: Text(contentModel.infohash,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                )),
          ),
          new Positioned(
            width: 100,
            top: 10,
            height: 18,
            right: 20,
            child: Text(contentModel.created_time,
                textDirection: TextDirection.rtl,
                maxLines: 1,
                style: TextStyle(fontSize: 10, color: Colors.black45)),
          ),
          new Positioned(
            width: 100,
            top: 30,
            height: 20,
            right: 5,
            child: FlatButton.icon(
              color: Colors.white,
              icon: Icon(
                Icons.file_download,
                color: _color,
                size: 13,
              ),
              label: Text(
                '拷贝磁链接',
                style: TextStyle(fontSize: 10, color: Colors.black45),
              ),
              onPressed: () {
                ClipboardData data = new ClipboardData(
                    text: "magnet:?xt=urn:btih:${contentModel.infohash}");
                Clipboard.setData(data);
                Fluttertoast.showToast(msg: "已复制磁链接到剪贴板");
              },
            ),
          ),
          new Positioned(
            top: 59.5,
            left: 0,
            right: 0,
            height: 0.5,
            child: Container(
              color: Color.fromRGBO(246, 246, 246, 1),
            ),
          )
        ],
      ),
    );
  }
}
