import 'archivements.dart';

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
  List<UserArchivements>? userArchivements;

  User(
      {this.id,
      this.name,
      this.phone,
      this.avatarUrl,
      this.address,
      this.gender,
      this.dateOfBirth,
      this.status,
      this.createAt,
      this.userArchivements});

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
    if (json['userArchivements'] != null) {
      userArchivements = <UserArchivements>[];
      json['userArchivements'].forEach((v) {
        userArchivements!.add(UserArchivements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['avatarUrl'] = avatarUrl;
    data['address'] = address;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['status'] = status;
    data['createAt'] = createAt;
    if (userArchivements != null) {
      data['userArchivements'] =
          userArchivements!.map((v) => v.toJson()).toList();
    }
    return data;
  }

    @override
  bool operator ==(Object other) => identical(this, other) || other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class UserArchivements {
  String? id;
  String? createAt;
  Archivement? archivement;

  UserArchivements({this.id, this.createAt, this.archivement});

  UserArchivements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createAt = json['createAt'];
    archivement = json['archivement'] != null
        ? Archivement.fromJson(json['archivement'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createAt'] = createAt;
    if (archivement != null) {
      data['archivement'] = archivement!.toJson();
    }
    return data;
  }
}
