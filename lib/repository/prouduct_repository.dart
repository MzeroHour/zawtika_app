import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zawtika/app_config/app_config.dart';
import 'package:zawtika/data_model/api_response.dart';
import 'package:zawtika/data_model/prodcut_model.dart';
import 'package:zawtika/repository/auth_repository.dart';

Future<ApiResponse> getProduct() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await AuthRepository.getToken();
    Uri url = Uri.parse('${AppConfig.BASE_URL}/v1/items');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        "Connection": "Keep-Alive",
      },
    );
    switch (response.statusCode) {
      case 200:
        final responseData = jsonDecode(response.body)['data'];
        if (responseData != null) {
          if (responseData is List) {
            apiResponse.data = responseData
                .map((itemData) => Product.fromJson(itemData))
                .toList();
          } else {
            apiResponse.data = [];
          }
        } else {
          apiResponse.data = [];
        }
        break;
      case 401:
        apiResponse.error = unauthorized;
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
