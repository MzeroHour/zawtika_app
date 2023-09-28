class User {
  int? id;
  int? userId;
  String? name;
  String? email;
  String? phone;
  String? token;

  User({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.token,
  });

//function to convert json data to user model
  factory User.loginJson(Map<String, dynamic> json) => User(
        id: json['id'] ?? 0,
        userId: json['user_data']['id'] ?? 0,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        token: json['token'] ?? '',
      );

//function to convert json data to user model
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "name": name ?? '',
        "email": email ?? '',
        "phone": phone ?? '',
        "token": token ?? '',
      };
}
