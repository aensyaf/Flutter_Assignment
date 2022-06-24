class User {
  String? id;
  String? name;
  String? email;
  String? phoneno;
  String? address;

  User({this.id, this.name, this.email, this.phoneno, this.address});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneno = json['phoneno'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phoneno'] = phoneno;
    data['address'] = address;
    return data;
  }
}
