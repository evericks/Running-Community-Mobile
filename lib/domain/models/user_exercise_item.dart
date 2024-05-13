class UserExerciseItem {
  String? id;
  String? exerciseItemId;
  String? createAt;

  UserExerciseItem({this.id, this.exerciseItemId, this.createAt});

  UserExerciseItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    exerciseItemId = json['exerciseItemId'];
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['exerciseItemId'] = this.exerciseItemId;
    data['createAt'] = this.createAt;
    return data;
  }
}
