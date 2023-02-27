class Auth {
  String? msg;
  final int status;
  String? token;
  User? user;
  bool? isEmployee;
  Auth({this.msg, this.token, this.user, this.isEmployee, this.status = 0});
  Auth.withStatus(
      {this.msg, this.token, this.user, this.isEmployee, required this.status});

  Auth.fromJson(Map<String, dynamic> json, {this.status = 200}) {
    msg = json['msg'];
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    isEmployee = json['is_employee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['is_employee'] = isEmployee;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? lastName;
  Login? login;
  bool? isVerified;
  bool? isEmployee;
  Images? images;
  String? phone;
  String? createdAt;
  String? updatedAt;
  String? status;

  User(
      {this.id,
      this.name,
      this.lastName,
      this.login,
      this.isVerified,
      this.isEmployee,
      this.images,
      this.phone,
      this.createdAt,
      this.updatedAt,
      this.status});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['last_name'];
    login = json['login'] != null ? Login.fromJson(json['login']) : null;
    isVerified = json['is_verified'];
    isEmployee = json['is_employee'];
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
    phone = json['phone'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['last_name'] = lastName;
    if (login != null) {
      data['login'] = login!.toJson();
    }
    data['is_verified'] = isVerified;
    data['is_employee'] = isEmployee;
    if (images != null) {
      data['images'] = images!.toJson();
    }
    data['phone'] = phone;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['status'] = status;
    return data;
  }
}

class Login {
  String? username;
  String? email;
  String? provider;
  String? lastLogin;

  Login({this.username, this.email, this.provider, this.lastLogin});

  Login.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    provider = json['provider'];
    lastLogin = json['lastLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['provider'] = provider;
    data['lastLogin'] = lastLogin;
    return data;
  }
}

class Images {
  String? avatar;

  Images({this.avatar});

  Images.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avatar'] = avatar;
    return data;
  }
}
