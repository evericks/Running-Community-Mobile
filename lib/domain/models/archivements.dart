
import 'tournaments.dart';
import 'user.dart';

class Archivements {
  Pagination? pagination;
  List<Archivement>? archivements;

  Archivements({this.pagination, this.archivements});

  Archivements.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      archivements = <Archivement>[];
      json['data'].forEach((v) {
        archivements!.add(new Archivement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.archivements != null) {
      data['data'] = this.archivements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? pageNumber;
  int? pageSize;
  int? totalRow;

  Pagination({this.pageNumber, this.pageSize, this.totalRow});

  Pagination.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalRow = json['totalRow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['totalRow'] = this.totalRow;
    return data;
  }
}

class Archivement {
  String? id;
  String? name;
  String? thumbnailUrl;
  int? rank;
  Creator? creator;
  User? user;
  Tournament? tournament;
  String? createAt;

  Archivement(
      {this.id,
      this.name,
      this.thumbnailUrl,
      this.rank,
      this.creator,
      this.user,
      this.tournament,
      this.createAt});

  Archivement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    thumbnailUrl = json['thumbnailUrl'];
    rank = json['rank'];
    creator =
        json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    tournament = json['tournament'] != null
        ? new Tournament.fromJson(json['tournament'])
        : null;
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['rank'] = this.rank;
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.tournament != null) {
      data['tournament'] = this.tournament!.toJson();
    }
    data['createAt'] = this.createAt;
    return data;
  }
}

class Creator {
  String? id;
  String? name;
  String? phone;
  String? avatarUrl;

  Creator({this.id, this.name, this.phone, this.avatarUrl});

  Creator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    avatarUrl = json['avatarUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['avatarUrl'] = this.avatarUrl;
    return data;
  }
}

