class User {
  String? id;
  String? name;
  String? phone;
  String? avatarUrl;
  String? address;
  double? longitude;
  double? latitude;
  String? status;
  String? createAt;

  User(
      {this.id,
      this.name,
      this.phone,
      this.avatarUrl,
      this.address,
      this.longitude,
      this.latitude,
      this.status,
      this.createAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    avatarUrl = json['avatarUrl'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
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
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['status'] = this.status;
    data['createAt'] = this.createAt;
    return data;
  }

    @override
  bool operator ==(Object other) => identical(this, other) || other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
