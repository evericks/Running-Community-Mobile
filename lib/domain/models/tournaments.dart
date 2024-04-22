class Tournaments {
  Pagination? pagination;
  List<Tournament>? tournaments;

  Tournaments({this.pagination, this.tournaments});

  Tournaments.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      tournaments = <Tournament>[];
      json['data'].forEach((v) {
        tournaments!.add(Tournament.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (tournaments != null) {
      data['data'] = tournaments!.map((v) => v.toJson()).toList();
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

class Tournament {
  String? id;
  String? title;
  String? thumbnailUrl;
  String? description;
  String? rule;
  int? maximumMember;
  double? distance;
  String? registerDuration;
  String? startTime;
  String? endTime;
  String? address;
  double? longitude;
  double? latitude;
  String? createAt;

  Tournament(
      {this.id,
      this.title,
      this.thumbnailUrl,
      this.description,
      this.rule,
      this.maximumMember,
      this.distance,
      this.registerDuration,
      this.startTime,
      this.endTime,
      this.address,
      this.longitude,
      this.latitude,
      this.createAt});

  Tournament.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    thumbnailUrl = json['thumbnailUrl'];
    description = json['description'];
    rule = json['rule'];
    maximumMember = json['maximumMember'];
    distance = json['distance'];
    registerDuration = json['registerDuration'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['thumbnailUrl'] = thumbnailUrl;
    data['description'] = description;
    data['rule'] = rule;
    data['maximumMember'] = maximumMember;
    data['distance'] = distance;
    data['registerDuration'] = registerDuration;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['address'] = address;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['createAt'] = createAt;
    return data;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Tournament && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
