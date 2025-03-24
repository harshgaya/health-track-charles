import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/sharedprefs.dart';
import 'base_api_services.dart';
import 'exceptions.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      try {
        final uri = Uri.parse(url);

        final response = await http.get(uri, headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization":
              'Bearer ${sharedPreferences.getString(SharedPreferenceKey.jwtToken) ?? ''}'
        }).timeout(const Duration(seconds: 250));

        return returnResponse(response);
      } on SocketException {
        throw InternetException();
      } on TimeoutException {
        throw RequestTimeOut();
      } on Exception catch (e) {
        throw Exception(e);
      }
    } catch (error, stackTrace) {
      rethrow;
    }
  }

  @override
  Future<dynamic> postApi(data, String url) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final uri = Uri.parse(url);
      try {
        print("PostUrl $uri");
        print("----PostReq-- $data------");
        final response = await http.post(uri, body: jsonEncode(data), headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization":
              'Bearer ${sharedPreferences.getString(SharedPreferenceKey.jwtToken)}'
        }).timeout(const Duration(seconds: 250));

        return returnResponse(response);
      } on SocketException {
        throw InternetException();
      } on TimeoutException {
        throw RequestTimeOut();
      } on Exception {
        throw Exception();
      }
    } catch (error, stackTrace) {
      print('------ERROR-------');
      print(error);
      print(stackTrace);
      // Logger.log(error, stackTrace: stackTrace);
      throw (error.toString());
    }
  }
}

dynamic returnResponse(http.Response response) {
  String? message = json.decode(response.body)['message'].toString();

  switch (response.statusCode) {
    case 200:
      if (json.decode(response.body)['status'] == 500) {
        print('------URL500-------');
        print("${response.request?.url} URL500");

        // Get.to(PhoneLoginPage());
      }
      return json.decode(response.body);
    case 400:
      throw (message ?? 'Something went wrong, please try again.');
    case 401:
      throw Unauthorized();
    case 403:
      throw Forbidden();
    case 404:
      throw NotFound();
    case 408:
      throw RequestTimeOut();
    case 500:
      throw (message ?? 'Something went wrong, please try again.');
    case 502:
      throw BadGateway();
    default:
      throw FetchDataException("Something Went Wrong ${response.statusCode}");
  }
}
