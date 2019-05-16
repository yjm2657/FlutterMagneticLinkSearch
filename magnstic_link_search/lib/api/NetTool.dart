import 'package:dio/dio.dart';
// import 'dart:convert';
import 'Api.dart';
import 'dart:io';

class NetTool {
  static const String GET = "get";
  static const String POST = "post";

  static void get(String url, Function callBack,
      {Map<String, String> params, Function errorCallBack}) async {
    _request(Api.BaseUrl + url, callBack,
        method: GET, params: params, errorCallBack: errorCallBack);
  }

  static void post(String url, Function callBack,
      {Map<String, String> params, Function errorCallBack}) async {
    _request(url, callBack,
        method: POST, params: params, errorCallBack: errorCallBack);
  }

  static void _request(String url, Function callBack,
      {String method,
      Map<String, String> params,
      Function errorCallBack}) async {
    print("<net> url : <" + method + ">" + url);
    if (params != null && params.isNotEmpty) {
      print("<net> params :" + params.toString());
    }

    String errorMsg = "";
    int statusCode;

    try {
      Response response;
      if (method == GET) {
        if (params != null && params.isNotEmpty) {
          StringBuffer sb = new StringBuffer("?");
          params.forEach((key, value) {
            sb.write("$key" + "=" + "$value" + "&");
          });
          String paramsStr = sb.toString();
          paramsStr = paramsStr.substring(0, paramsStr.length - 1);
          url += paramsStr;
        }
        response = await Dio().get(url);
      } else {
        if (params != null && params.isNotEmpty) {
          response = await Dio().post(url,
              data: params,
              options: Options(
                contentType:
                    ContentType.parse("application/x-www-form-urlencoded"),
              ));
        } else {
          response = await Dio().post(url);
        }
      }

      statusCode = response.statusCode;

      if (statusCode < 0) {
        errorMsg = "网络请求错误,状态码:" + statusCode.toString();
        _handError(errorCallBack, errorMsg);
        return;
      }
      print(response);
      if (callBack != null) {
        callBack(response.data);
        print("<net> response data:" + response.data.toString());
      }
    } catch (exception) {
      _handError(errorCallBack, exception.toString());
    }
  }

  static void _handError(Function errorCallBack, String errorMsg) {
    if (errorCallBack != null) {
      errorCallBack(errorMsg);
    }
    print("<net> errorMsg :" + errorMsg);
  }
}
