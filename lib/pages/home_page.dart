import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mall/config/service_url.dart';
import 'package:flutter_mall/service/service_method.dart';
import 'package:flutter_mall/utils/ToastUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ffff'),
        ),
        body: FutureBuilder(
          future: requestPost(homePageContentUrl,
              fromData: {'lon': '115.02932', 'lat': '35.76189'}),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              List<Map> swiperDataList = List<Map>.from(data['data']['slides']);
              List<Map> navigatorList =
              List<Map>.from(data['data']['category']);
              String adPicture =
              data['data']['advertesPicture']['PICTURE_ADDRESS'];
              String leaderPhone = data['data']['shopInfo']['leaderPhone'];
              String leaderImage = data['data']['shopInfo']['leaderImage'];
              List<Map> recommendList =
              List<Map>.from(data['data']['recommend']);
              String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
              String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
              String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];

              List<Map> floor1 = List<Map>.from(data['data']['floor1']);
              List<Map> floor2 = List<Map>.from(data['data']['floor2']);
              List<Map> floor3 = List<Map>.from(data['data']['floor3']);

              return ListView(
                children: <Widget>[
                  CustomSwiper(swiperDateList: swiperDataList),
                  TopNavigator(navigatorList: navigatorList),
                  AdBanner(adPicture: adPicture),
                  LeaderPhone(
                      leaderImage: leaderImage, leaderPhone: leaderPhone),
                  Recommend(recommendList: recommendList),
                  FloorTitle(pictureAddress: floor1Title),
                  FloorContent(floorGoodsList: floor1),
                  FloorTitle(pictureAddress: floor2Title),
                  FloorContent(floorGoodsList: floor1),
                  FloorTitle(pictureAddress: floor3Title),
                  FloorContent(floorGoodsList: floor1),
                ],
              );
            } else {
              return Center(
                  child: Text('加载中...' + '设备像素密度: ${ScreenUtil.pixelRatio}'));
            }
          },
        ));
  }
}

/// banner模块
class CustomSwiper extends StatelessWidget {
  final List swiperDateList;

  CustomSwiper({this.swiperDateList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network("${swiperDateList[index]['image']}",
              fit: BoxFit.fill);
        },
        itemCount: swiperDateList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

/// 顶部导航模块
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  const TopNavigator({this.navigatorList});

  Widget _gridViewItemUI(BuildContext context, item, int i) {
    return InkWell(
      onTap: () {
        ToastUtil.show("dfddb");
      },
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.network(
              item['image'],
              width: ScreenUtil().setWidth(95),
            ),
          ),
          Text(
            item['mallCategoryName'],
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = 0;

    /// 移除10以后的数据,只保留0-9之间的数据
    if (this.navigatorList.length > 0) {
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    return Container(
      color: Colors.white,
      height: ScreenUtil().setWidth(320),
      padding: EdgeInsets.all(3),
      child: GridView.count(
        crossAxisCount: 5,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(5),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item, itemCount++);
        }).toList(),
      ),
    );
  }
}

/// 广告banner
class AdBanner extends StatelessWidget {
  final String adPicture;

  const AdBanner({this.adPicture});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(3),
        child: Image.network(
          adPicture,
          height: ScreenUtil().setHeight(110),
        ));
  }
}

/// 拨打电话
class LeaderPhone extends StatelessWidget {
  final String leaderPhone;
  final String leaderImage;

  const LeaderPhone({this.leaderImage, this.leaderPhone});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _launchURL(leaderPhone);
      },
      child: Container(
        padding: EdgeInsets.all(3),
        child: Image.network(
          leaderImage,
        ),
      ),
    );
  }

  void _launchURL(String lp) async {
    String url = 'tel:' + lp;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

/// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;

  const Recommend({this.recommendList});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: ScreenUtil().setHeight(390),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(),
        ],
      ),
    );
  }

  /// 标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black45,
            width: 0.5,
          ),
        ),
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  /// 横向列表
  Widget _recommendList() {
    return Container(
        margin: EdgeInsets.only(top: 1),
        height: ScreenUtil().setHeight(330),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _itemWidget(context, index);
          },
        ));
  }

  /// 推荐商品单独项
  Widget _itemWidget(context, index) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: ScreenUtil().setWidth(250),
        height: ScreenUtil().setHeight(330),
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: Colors.black12, width: 0.5),
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
//            Text(
//              '${recommendList[index]['goodsName']}',
//              style: TextStyle(color: Colors.black45),
//            ),
            Text('￥${recommendList[index]['mallPrice'].toString()}'),
            Text(
              '￥${recommendList[index]['price'].toString()}',
              style: TextStyle(
                  color: Colors.grey, decoration: TextDecoration.lineThrough),
            ),
          ],
        ),
      ),
    );
  }
}

/// 楼层标题
class FloorTitle extends StatelessWidget {
  final String pictureAddress;

  const FloorTitle({this.pictureAddress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Image.network(pictureAddress),
    );
  }
}

/// 楼层列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  const FloorContent({this.floorGoodsList});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstGoods(context),
          _otherGoods(context),
        ],
      ),
    );
  }

  Widget _firstGoods(BuildContext context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(context, floorGoodsList[1]),
            _goodsItem(context, floorGoodsList[2]),
          ],
        ),
      ],
    );
  }

  Widget _otherGoods(BuildContext context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[3]),
        _goodsItem(context, floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(BuildContext context, Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {},
        child: Image.network(goods['image']),
      ),
    );
  }
}

void prints() {
  print('设备像素密度: ${ScreenUtil.pixelRatio}');
  print('设备高: ${ScreenUtil.screenHeight}');
  print('设备宽: ${ScreenUtil.screenWidth}');
}
