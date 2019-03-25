import 'package:flutter/material.dart';
import 'package:prim_fultter_app/components/webview.dart';
import 'package:prim_fultter_app/model/common_model.dart';
import 'package:prim_fultter_app/model/grid_nav_model.dart';
import 'package:prim_fultter_app/model/grid_nav_item.dart';

///卡片网格布局
class CardGridNav extends StatefulWidget {
  final GridNavModel gridNavModel;

  const CardGridNav({Key key, this.gridNavModel}) : super(key: key);

  @override
  _CardGridNavState createState() => _CardGridNavState();
}

class _CardGridNavState extends State<CardGridNav> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _gridNavItems(context),
    );
  }

  /// 大卡片
  _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (widget.gridNavModel == null) return null;
    if (widget.gridNavModel.hotel != null) {
      ///酒店

    }
    if (widget.gridNavModel.flight != null) {}
    if (widget.gridNavModel.travel != null) {}
    return items;
  }

  ///小卡片
  _gridNavItem(BuildContext context, GridNavItem item, bool first) {
    List<Widget> items = [];
    items.add(_mainItem(item.mainItem));
    return items;
  }

  ///具体的主卡片widget
  _mainItem(CommonModel model) {
    return _warpGesture(
        Stack(
          //设置为容器布局
          children: <Widget>[
            Image.network(
              model.icon,
              fit: BoxFit.contain, //居中
              alignment: AlignmentDirectional.bottomEnd, //图片局下
            ),
            Text(
              model.title,
              style: TextStyle(fontSize: 14, color: Colors.white),
            )
          ],
        ),
        model);
  }

  /// 附属卡片
  _doubleItem(BuildContext context, CommonModel topIem, CommonModel bottomItem,
      bool isCenter) {
    return Column(
      children: <Widget>[
        Expanded(child: _item(context, topIem, true, isCenter)),
      ],
    );
  }

  _item(BuildContext context, CommonModel item, bool first, bool isCenter) {
    BorderSide side = BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      widthFactor: 1, //设置宽度撑满父布局
      child: Container(
        //设置装饰器
        decoration: BoxDecoration(
          border: Border(
              //设置边框
              left: side,
              bottom: first ? side : BorderSide.none),
        ),
        child: _warpGesture(
            Center(
              //设置一个居中布局
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            item),
      ),
    );
  }

  /// 自动适配点击事件
  _warpGesture(Widget widget, CommonModel model) {
    return GestureDetector(
      child: widget,
      onTap: () {
        //点击事件
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebView(
                      url: model.url,
                      hideAppBar: model.hideAppBar,
                      statusBarColor: model.statusBarColor,
                    )));
      },
    );
  }
}
