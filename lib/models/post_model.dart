class Post {
  final String id;
  final String username;
  final String userImage;
  final String postImage;
  final String caption;
  bool isLiked;
  int likes;
  final List<Comment> comments;
  final DateTime timestamp;

  Post({
    required this.id,
    required this.username,
    required this.userImage,
    required this.postImage,
    required this.caption,
    this.isLiked = false,
    this.likes = 0,
    required this.comments,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'userImage': userImage,
      'postImage': postImage,
      'caption': caption,
      'isLiked': isLiked,
      'likes': likes,
      'comments': comments.map((c) => c.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      username: json['username'],
      userImage: json['userImage'],
      postImage: json['postImage'],
      caption: json['caption'],
      isLiked: json['isLiked'] ?? false,
      likes: json['likes'] ?? 0,
      comments:
          (json['comments'] as List?)
              ?.map((c) => Comment.fromJson(c))
              .toList() ??
          [],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class Comment {
  final String id;
  final String username;
  final String userImage;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.username,
    required this.userImage,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'userImage': userImage,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      username: json['username'],
      userImage: json['userImage'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
