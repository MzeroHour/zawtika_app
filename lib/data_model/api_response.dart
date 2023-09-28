import 'user_model.dart';

const serverError = 'Server Error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, Pls Try again!';

// ApiResponse apiResponseFromJson(String str) =>
//     ApiResponse.fromJson(json.decode(str));

// String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
// for response error and data
  Object? data;
  String? error;
  User? user;
  ApiResponse({
    this.data,
    this.error,
    this.user,
  });

  // factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
  //       user: json["user"] == null ? null : User.fromJson(json["user"]),
  //     );
  // Map<String, dynamic> toJson() => {
  //       "user": user == null ? null : user!.toJson(),
  //     };
}
