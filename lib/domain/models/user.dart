class User {
  String? id;
  String? name;
  String? phone;
  String? avatarUrl;
  String? address;
  String? gender;
  String? dateOfBirth;
  String? status;
  String? createAt;

  User(
      {this.id,
      this.name,
      this.phone,
      this.avatarUrl,
      this.address,
      this.gender,
      this.dateOfBirth,
      this.status,
      this.createAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    avatarUrl = json['avatarUrl'];
    address = json['address'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    status = json['status'];
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['avatarUrl'] = this.avatarUrl;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['dateOfBirth'] = this.dateOfBirth;
    data['status'] = this.status;
    data['createAt'] = this.createAt;
    return data;
  }

    @override
  bool operator ==(Object other) => identical(this, other) || other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
