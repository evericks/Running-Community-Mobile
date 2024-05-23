import 'user.dart';

class Groups {
  Pagination? pagination;
  List<Group>? groups;

  Groups({this.pagination, this.groups});

  Groups.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      groups = <Group>[];
      json['data'].forEach((v) {
        groups!.add(Group.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (groups != null) {
      data['data'] = groups!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    data['totalRow'] = totalRow;
    return data;
  }
}

class Group {
  String? id;
  String? name;
  String? description;
  String? thumbnailUrl;
  int? minAge;
  int? maxAge;
  String? gender;
  List<GroupMembers>? groupMembers;
  String? createAt;

  Group(
      {this.id,
      this.name,
      this.description,
      this.thumbnailUrl,
      this.minAge,
      this.maxAge,
      this.gender,
      this.groupMembers,
      this.createAt});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    thumbnailUrl = json['thumbnailUrl'];
    minAge = json['minAge'];
    maxAge = json['maxAge'];
    gender = json['gender'];
    if (json['groupMembers'] != null) {
      groupMembers = <GroupMembers>[];
      json['groupMembers'].forEach((v) {
        groupMembers!.add(GroupMembers.fromJson(v));
      });
    }
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['thumbnailUrl'] = thumbnailUrl;
    data['minAge'] = minAge;
    data['maxAge'] = maxAge;
    data['gender'] = gender;
    if (groupMembers != null) {
      data['groupMembers'] = groupMembers!.map((v) => v.toJson()).toList();
    }
    data['createAt'] = createAt;
    return data;
  }
}

class GroupMembers {
  String? id;
  User? user;
  String? role;
  String? status;
  String? createAt;

  GroupMembers({this.user, this.role, this.status, this.createAt});

  GroupMembers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    role = json['role'];
    status = json['status'];
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['role'] = role;
    data['status'] = status;
    data['createAt'] = createAt;
    return data;
  }
}
