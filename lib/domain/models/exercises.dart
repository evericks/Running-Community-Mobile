class Exercises {
  Pagination? pagination;
  List<Exercise>? exercises;

  Exercises({this.pagination, this.exercises});

  Exercises.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      exercises = <Exercise>[];
      json['data'].forEach((v) {
        exercises!.add(Exercise.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (exercises != null) {
      data['data'] = exercises!.map((v) => v.toJson()).toList();
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

class Exercise {
  String? id;
  String? name;
  String? thumbnailUrl;
  Creator? creator;
  String? description;
  List<ExerciseItems>? exerciseItems;
  String? createAt;

  Exercise(
      {this.id,
      this.name,
      this.thumbnailUrl,
      this.creator,
      this.description,
      this.exerciseItems,
      this.createAt});

  Exercise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    thumbnailUrl = json['thumbnailUrl'];
    creator =
        json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    description = json['description'];
    if (json['exerciseItems'] != null) {
      exerciseItems = <ExerciseItems>[];
      json['exerciseItems'].forEach((v) {
        exerciseItems!.add(ExerciseItems.fromJson(v));
      });
    }
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['thumbnailUrl'] = thumbnailUrl;
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    data['description'] = description;
    if (exerciseItems != null) {
      data['exerciseItems'] =
          exerciseItems!.map((v) => v.toJson()).toList();
    }
    data['createAt'] = createAt;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['avatarUrl'] = avatarUrl;
    return data;
  }
}

class ExerciseItems {
  String? id;
  String? title;
  int? priority;
  String? content;
  String? thumbnailUrl;
  String? videoUrl;

  ExerciseItems({this.id, this.title, this.priority, this.content, this.thumbnailUrl, this.videoUrl});

  ExerciseItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    priority = json['priority'];
    content = json['content'];
    thumbnailUrl = json['thumbnailUrl'];
    videoUrl = json['videoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['priority'] = priority;
    data['content'] = content;
    data['thumbnailUrl'] = thumbnailUrl;
    data['videoUrl'] = videoUrl;
    return data;
  }
}
