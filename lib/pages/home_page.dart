import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:prim_fultter_app/dao/home_dao.dart';
import 'package:prim_fultter_app/model/common_model.dart';
import 'package:prim_fultter_app/model/home_model.dart';
import 'package:prim_fultter_app/components/grid_nav.dart';
import 'dart:convert';
import 'dart:async';

const APPBAR_SCROLL_OFFSET = 100;

///首页页面
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    'http://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
    'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
    'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg'
  ];

  double appBarOpacity = 0;

  String resultString = "";

  List<CommonModel> gridNavList;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Null> loadData() async {
    //一种方式
//    HomeDao.fetch().then((result) {
//      //转换json字符串
//      resultString = json.encode(result.config);
//      print("homeDao:" + resultString);
//    }).catchError((e) {
//      resultString = e.toString();
//      print("homeDao:" + resultString);
//    });

    //另一种方式
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        gridNavList = model.localNavList;
        print(json.encode(model.localNavList));
      });
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  _scroll(offest) {
    double alpha = offest / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarOpacity = alpha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      //自定义appBar
      body: Stack(
        children: <Widget>[
          //view 数组 后面第会盖在前面上
          //列表部分
          MediaQuery.removePadding(
            //移除view顶部设置的padding 主要用于顶部导航栏的问题
            removeTop: true, //移除顶部的padding
            context: context,
            child: NotificationListener(
              //滚动监听 list view
              onNotification: (scrollNotification) {
                //监听滚动的距离ScrollUpdateNotification 滚动时在进行回调
                if (scrollNotification is ScrollUpdateNotification &&
                    scrollNotification.depth == 0) {
                  //只检测listview的滚动第0个元素widget时候才开始滚动
                  _scroll(scrollNotification.metrics.pixels);
                }
              },
              child: _buildListView(_imageUrls),
            ),
          ),
          //顶部 bar部分
          _buildTopBar(appBarOpacity),
        ],
      ),
    );
  }

  ///构建顶部bar
  Widget _buildTopBar(appBarOpacity) {
    return Opacity(
      //和在CSS的属性中的opacity一样设置不透明度的级别
      opacity: appBarOpacity,
      child: Container(
        height: 80,
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.only(top: 20), //padding 距离顶部20
        child: Center(
          child: Text('首页'),
        ),
      ),
    );
  }

  /// 构建列表
  ListView _buildListView(_imageUrls) {
    return ListView(
      children: <Widget>[
        _buildBanner(_imageUrls),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: GridNav(gridNavList: gridNavList),
        ),
        Container(
          height: 800,
          child: ListTile(
            title: Text('hahahah'),
          ),
        ),
      ],
    );
  }

  /// 构建列表头部banner
  Container _buildBanner(_imageUrls) {
    return Container(
      height: 160.0,
      child: Swiper(
        itemCount: _imageUrls.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(_imageUrls[index], fit: BoxFit.fill); //加载网络图片
        },
        pagination: SwiperPagination(), //添加指示器
      ),
    );
  }
}