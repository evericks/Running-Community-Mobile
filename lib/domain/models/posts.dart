import 'user.dart';

class Posts {
  Pagination? pagination;
  List<Post>? posts;

  Posts({this.pagination, this.posts});

  Posts.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      posts = <Post>[];
      json['data'].forEach((v) {
        posts!.add(new Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.posts != null) {
      data['data'] = this.posts!.map((v) => v.toJson()).toList();
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

class Post {
  String? id;
  String? content;
  String? thumbnailUrl;
  Creator? creator;
  List<PostComment>? postComments;
  List<PostReacts>? postReacts;
  String? createAt;

  Post(
      {this.id,
      this.content,
      this.thumbnailUrl,
      this.creator,
      this.postComments,
      this.postReacts,
      this.createAt});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    thumbnailUrl = json['thumbnailUrl'];
    creator =
        json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
    if (json['postComments'] != null) {
      postComments = <PostComment>[];
      json['postComments'].forEach((v) {
        postComments!.add(new PostComment.fromJson(v));
      });
    }
    if (json['postReacts'] != null) {
      postReacts = <PostReacts>[];
      json['postReacts'].forEach((v) {
        postReacts!.add(new PostReacts.fromJson(v));
      });
    }
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['thumbnailUrl'] = this.thumbnailUrl;
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    if (this.postComments != null) {
      data['postComments'] = this.postComments!.map((v) => v.toJson()).toList();
    }
    if (this.postReacts != null) {
      data['postReacts'] = this.postReacts!.map((v) => v.toJson()).toList();
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

class PostComment {
  String? id;
  User? user;
  String? content;
  List<ReplyComments>? replyComments;
  List<PostCommentReacts>? postCommentReacts;
  String? createAt;

  PostComment(
      {this.id,
      this.user,
      this.content,
      this.replyComments,
      this.postCommentReacts,
      this.createAt});

  PostComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    content = json['content'];
    if (json['replyComments'] != null) {
      replyComments = <ReplyComments>[];
      json['replyComments'].forEach((v) {
        replyComments!.add(new ReplyComments.fromJson(v));
      });
    }
    if (json['postCommentReacts'] != null) {
      postCommentReacts = <PostCommentReacts>[];
      json['postCommentReacts'].forEach((v) {
        postCommentReacts!.add(new PostCommentReacts.fromJson(v));
      });
    }
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['content'] = this.content;
    if (this.replyComments != null) {
      data['replyComments'] =
          this.replyComments!.map((v) => v.toJson()).toList();
    }
    if (this.postCommentReacts != null) {
      data['postCommentReacts'] =
          this.postCommentReacts!.map((v) => v.toJson()).toList();
    }
    data['createAt'] = this.createAt;
    return data;
  }
}

class ReplyComments {
  String? id;
  User? user;
  String? content;
  List<ReplyCommentReacts>? replyCommentReacts;
  String? createAt;

  ReplyComments(
      {this.id,
      this.user,
      this.content,
      this.replyCommentReacts,
      this.createAt});

  ReplyComments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    content = json['content'];
    if (json['replyCommentReacts'] != null) {
      replyCommentReacts = <ReplyCommentReacts>[];
      json['replyCommentReacts'].forEach((v) {
        replyCommentReacts!.add(new ReplyCommentReacts.fromJson(v));
      });
    }
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['content'] = this.content;
    if (this.replyCommentReacts != null) {
      data['replyCommentReacts'] =
          this.replyCommentReacts!.map((v) => v.toJson()).toList();
    }
    data['createAt'] = this.createAt;
    return data;
  }
}

class ReplyCommentReacts {
  String? userId;
  String? replyCommentId;
  String? createAt;
  String? id;
  ReplyComments? replyComment;
  User? user;

  ReplyCommentReacts(
      {this.userId,
      this.replyCommentId,
      this.createAt,
      this.id,
      this.replyComment,
      this.user});

  ReplyCommentReacts.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    replyCommentId = json['replyCommentId'];
    createAt = json['createAt'];
    id = json['id'];
    replyComment = json['replyComment'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['replyCommentId'] = this.replyCommentId;
    data['createAt'] = this.createAt;
    data['id'] = this.id;
    data['replyComment'] = this.replyComment;
    data['user'] = this.user;
    return data;
  }
}

class PostCommentReacts {
  User? user;
  String? createAt;

  PostCommentReacts({this.user, this.createAt});

  PostCommentReacts.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['createAt'] = this.createAt;
    return data;
  }
}

class PostReacts {
  String? id;
  User? user;
  String? createAt;

  PostReacts({this.id, this.user, this.createAt});

  PostReacts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['createAt'] = this.createAt;
    return data;
  }
}
