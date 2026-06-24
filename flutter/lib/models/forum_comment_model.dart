class ForumCommentModel {
  final String authorName;
  final String authorInitials;
  final String content;
  final String timeAgo;

  ForumCommentModel({
    required this.authorName,
    required this.authorInitials,
    required this.content,
    required this.timeAgo,
  });
}