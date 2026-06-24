import 'package:flutter/material.dart';
import '../models/forum_post_model.dart';

class ForumPostCard extends StatelessWidget {
  final ForumPostModel post;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const ForumPostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors.purple,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    post.authorInitials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                Colors.blue
                                    .withOpacity(
                                        .15),
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),
                          child: Text(
                            post.authorRole,
                            style:
                                const TextStyle(
                              color:
                                  Colors.blue,
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(
                            width: 8),

                        Text(
                          post.timeAgo,
                          style:
                              const TextStyle(
                            color: Colors
                                .white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.blue
                  .withOpacity(.15),
              borderRadius:
                  BorderRadius.circular(
                      12),
            ),
            child: Text(
              post.course,
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            post.content,
            style: const TextStyle(
              color: Colors.white,
              height: 1.5,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              InkWell(
                onTap: onLike,
                borderRadius:
                    BorderRadius.circular(
                        20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration:
                      BoxDecoration(
                    color: post.liked
                        ? Colors.red
                            .withOpacity(
                                .15)
                        : Colors.white
                            .withOpacity(
                                .05),
                    borderRadius:
                        BorderRadius.circular(
                            20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        post.liked
                            ? Icons.favorite
                            : Icons
                                .favorite_border,
                        color:
                            post.liked
                                ? Colors.red
                                : Colors
                                    .white70,
                      ),
                      const SizedBox(
                          width: 6),
                      Text(
                        "${post.likes}",
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              InkWell(
                onTap: onComment,
                borderRadius:
                    BorderRadius.circular(
                        20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Colors.white
                        .withOpacity(.05),
                    borderRadius:
                        BorderRadius.circular(
                            20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons
                            .chat_bubble_outline,
                        color:
                            Colors.white70,
                      ),
                      const SizedBox(
                          width: 6),
                      Text(
                        "${post.comments}",
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}