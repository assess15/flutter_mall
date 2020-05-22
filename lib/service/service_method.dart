import 'dart:async';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import '../config/service_url.dart';

Future requestPost(url, {fromData}) async {
  try {
    print('开始请求数据....');
    Response response;
    Dio dio = new Dio();
//    dio.options.headers["user-agent"] = "xxx";
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    dio.options.baseUrl = baseUrl;
    dio.options.contentType = Headers.formUrlEncodedContentType;
//    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//        (client) {
//      client.findProxy = (uri) {
//        // charles: 设置自己电脑的ip + 端口; 上线需要手动关闭
//        return "PROXY 192.168.101.26:8888";
//      };
//      client.badCertificateCallback =
//          (X509Certificate cert, String host, int port) => true;
//    };

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
