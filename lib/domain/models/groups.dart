import 'user.dart';

class Groups {
  Pagination? pagination;
  List<Group>? groups;

  Groups({this.pagination, this.groups});

  Groups.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      groups = <Group>[];
      json['data'].forEach((v) {
        groups!.add(new Group.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.groups != null) {
      data['data'] = this.groups!.map((v) => v.toJson()).toList();
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

class Group {
  String? id;
  String? name;
  String? description;
  String? rule;
  String? thumbnailUrl;
  List<GroupMembers>? groupMembers;
  String? createAt;

  Group(
      {this.id,
      this.name,
      this.description,
      this.rule,
      this.thumbnailUrl,
      this.groupMembers,
      this.createAt});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    rule = json['rule'];
    thumbnailUrl = json['thumbnailUrl'];
    if (json['groupMembers'] != null) {
      groupMembers = <GroupMembers>[];
      json['groupMembers'].forEach((v) {
        groupMembers!.add(new GroupMembers.fromJson(v));
      });
    }
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['rule'] = this.rule;
    data['thumbnailUrl'] = this.thumbnailUrl;
    if (this.groupMembers != null) {
      data['groupMembers'] = this.groupMembers!.map((v) => v.toJson()).toList();
    }
    data['createAt'] = this.createAt;
    return data;
  }
}

class GroupMembers {
  User? user;
  String? role;
  String? status;
  String? createAt;

  GroupMembers({this.user, this.role, this.status, this.createAt});

  GroupMembers.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    role = json['role'];
    status = json['status'];
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['role'] = this.role;
    data['status'] = this.status;
    data['createAt'] = this.createAt;
    return data;
  }
}
