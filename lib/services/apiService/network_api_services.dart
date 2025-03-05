import 'dart:io';

import 'package:dio/dio.dart';
import 'package:web_horizon/services/apiService/app_exception.dart';
import 'package:web_horizon/services/apiService/base_api_services.dart';

class NetworkApiServices extends BaseApiService {
  Dio dio = Dio(BaseOptions());

  @override
  Future getGetApiResponse(
      {required String url, Map<String, dynamic>? headers}) async {
    dynamic responseJson;

    try {
      var response = await dio.get(
        url,
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }

    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, data) async {
    dynamic responseJson;

    try {
      var response = await dio.post(url, data: data);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }

    return responseJson;
  }

  @override
  Future getPatchApiResponse(String url, data) async {
    dynamic responseJson;

    try {
      var response = await dio.patch(url, data: data);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }

    return responseJson;
  }

  @override
  Future getPutApiResponse(String url, data) async {
    dynamic responseJson;

    try {
      var response = await dio.put(url, data: data);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }

    return responseJson;
  }

  @override
  Future getDeleteApiResponse(String url, data) async {
    dynamic responseJson;

    try {
      var response = await dio.delete(url, data: data);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }

    return responseJson;
  }

  returnResponse(Response response) {
    if (response.statusCode == 200) {
      dynamic responseJson = response.data;
      return responseJson;
    } else {
      throw FetchDataException(response.statusMessage.toString());
    }
  }
}
