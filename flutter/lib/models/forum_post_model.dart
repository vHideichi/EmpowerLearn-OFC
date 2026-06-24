import 'forum_comment_model.dart';

class ForumPostModel {
  String authorName;
  String authorInitials;
  String authorRole;
  String course;
  String timeAgo;
  String content;

  int likes;
  int comments;

  bool liked;
  bool isPinned;

  int avatarColorIndex;

  List<ForumCommentModel> commentsList;

  ForumPostModel({
    required this.authorName,
    required this.authorInitials,
    required this.authorRole,
    required this.course,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    this.liked = false,
    this.isPinned = false,
    this.avatarColorIndex = 0,
    List<ForumCommentModel>? commentsList,
  }) : commentsList = commentsList ?? [];
}