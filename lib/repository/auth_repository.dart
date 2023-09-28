import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawtika/app_config/app_config.dart';
import 'package:zawtika/data_model/api_response.dart';

import '../data_model/user_model.dart';

class AuthRepository {
  Future<ApiResponse> getLoginResponse(String email, String password) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      Uri url = Uri.parse('${AppConfig.BASE_URL}/login');
      final response = await http.post(url,
          headers: {'Accept': 'application/json'},
          body: {'email': email, 'password': password});
      print('Body : ${response.body}');
      switch (response.statusCode) {
        case 200:
          apiResponse.data = User.loginJson(jsonDecode(response.body)['data']);
          print('Body : ${apiResponse.data}');
          break;
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;
        case 401:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
      print(e);
    }
    return apiResponse;
  }

  //Get User details
  Future<ApiResponse> getUserDetails(int id) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await getToken();
      Uri url = Uri.parse("${AppConfig.BASE_URL}/v1/users/$id");
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        "Connection": "Keep-Alive",
      });

      switch (response.statusCode) {
        case 200:
          // print('xxxxxxxx ${response.body}');
          apiResponse.data = User.fromJson(jsonDecode(response.body)['data']);

          break;
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;
        case 401:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  //Logout Remove Token
  Future<void> removeTokenFromDatabase() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final token =
        pref.getString('token'); // Retrieve the token from SharedPreferences

    // Make an HTTP request to remove the token from the database
    Uri url = Uri.parse("${AppConfig.BASE_URL}/v1/logout");
    final response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      // Token removed successfully
      print('Token removed successfully');
    } else {
      // Handle error, e.g., show an error message
      print('Error removing token from database: ${response.statusCode}');
    }
  }

  // Logout
  Future<bool> logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await removeTokenFromDatabase(); // Remove the token from the database
    // cartItemBloc.dispose();

    return await pref.remove('token');
  }

  // Get Token
  static Future<String> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token') ?? '';
  }

  // Get Token
  static Future<int> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('user_id') ?? 0;
  }
}
