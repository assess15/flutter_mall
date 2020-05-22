
### Error
##### 1. Your app isn't using AndroidX.

fix 1
android.enableJetifier=true
android.useAndroidX=true

##### 2. SingleChildScrollView 和 ListView 滚动冲突


### Dio 网络请求

```Dart
Future requestPost(url, {fromData}) async {
  try {
    print('开始请求数据....');
    Response response;
    // 或者这样写法
//    BaseOptions options = new BaseOptions(
//        connectTimeout: 5000,
//        receiveTimeout: 5000,
//        baseUrl: serviceUrl,
//        headers: ,
//        contentType: Headers.formUrlEncodedContentType);
//    Dio dio = new Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        // charles: 设置自己电脑的ip + 端口; 上线需要手动关闭
        return "PROXY 192.168.101.26:8888";
      };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };

    if (fromData != null) {
      response = await dio.post(url, data: fromData);
    } else {
      response = await dio.post(url);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("接口异常");
    }
  } catch (e) {
    return print(e);
  }
}

```

### 底部页面保持/懒加载

1. with AutomaticKeepAliveClientMixin
2.   @override
     bool get wantKeepAlive => true;
3. IndexedStack

### GridView EasyRefresh 冲突

// 静止回弹,否则下拉刷新和GridView冲突
physics: NeverScrollableScrollPhysics(),
