class User {
  String? id;
  String? name;
  String? email;
  String? num;
  String? address;

  User({this.id, this.name, this.email, this.num, this.address});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    num = json['num'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['num'] = num;
    return data;
  }
}