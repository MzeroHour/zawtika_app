import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zawtika/app_config/app_config.dart';
import 'package:zawtika/data_model/api_response.dart';
import 'package:zawtika/repository/auth_repository.dart';

import '../data_model/order_model.dart';

Future<Order> orderSubmit(Order product) async {
  try {
    final String token = await AuthRepository.getToken();
    Uri url = Uri.parse('${AppConfig.BASE_URL}/v1/customer-orders');
    final response = await http.post(url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(product.toJson()));
    print('Order Response : ${product.toJson()}');
    if (response.statusCode == 201) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      print('API Error Response: ${response.body}');
      throw Exception('Failed to create order');
    }
  } catch (e) {
    print('JSON Parsing Error: $e');
    throw Exception('Failed to create order: $e');
  }
}

Future<ApiResponse> getOrderAll() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await AuthRepository.getToken();
    Uri url = Uri.parse("${AppConfig.BASE_URL}/v1/customer-orders");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      "Connection": "Keep-Alive",
    });
    print('Apple is ${response.body}');
    switch (response.statusCode) {
      case 200:
        final responseData = jsonDecode(response.body)['data'];
        // print('Fucking Api : $responseData');
        if (responseData != null) {
          if (responseData is List) {
            // apiResponse.data = responseData
            //     .map((roderListData) => Order.fromJson(roderListData))
            //     .toList();
            List<Order> orders = responseData
                .map((orderData) => Order.fromJson(orderData))
                .toList();
            apiResponse.data = orders;
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
    apiResponse.error = 'JSON Parsing Error: $e';
    print('JSON Parsing Error: $e');
  }
  return apiResponse;
}
