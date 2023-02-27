class Profile {
  String? name;
  String? email;
  String? phone;
  String? avatar;

  Profile({this.name, this.email, this.phone, this.avatar});

  Profile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['avatar'] = avatar;
    return data;
  }
}