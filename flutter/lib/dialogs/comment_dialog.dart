import 'package:flutter/material.dart';

import '../models/forum_comment_model.dart';
import '../models/forum_post_model.dart';

class CommentDialog {
  static void open(
    BuildContext context,
    ForumPostModel post,
    VoidCallback refresh,
  ) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (_) {
        return SizedBox(
          height: 550,
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Text(
                "Comentários",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: ListView.builder(
                  itemCount: post.commentsList.length,
                  itemBuilder: (_, index) {
                    final comment =
                        post.commentsList[index];

                    return Container(
                      margin:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding:
                          const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF1E293B),
                        borderRadius:
                            BorderRadius.circular(
                                16),
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                Colors.blue,
                            child: Text(
                              comment.authorInitials,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment
                                          .authorName,
                                      style:
                                          const TextStyle(
                                        color: Colors
                                            .white,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    const SizedBox(
                                        width: 8),

                                    Text(
                                      comment.timeAgo,
                                      style:
                                          const TextStyle(
                                        color: Colors
                                            .white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                    height: 6),

                                Text(
                                  comment.content,
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration:
                            InputDecoration(
                          hintText:
                              "Escreva um comentário...",
                          hintStyle:
                              const TextStyle(
                            color: Colors
                                .white54,
                          ),
                          filled: true,
                          fillColor:
                              const Color(
                                  0xFF1E293B),
                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    15),
                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        if (controller.text
                            .trim()
                            .isNotEmpty) {
                          post.commentsList.add(
                            ForumCommentModel(
                              authorName:
                                  "Amanda",
                              authorInitials:
                                  "AM",
                              content:
                                  controller.text,
                              timeAgo: "agora",
                            ),
                          );

                          post.comments++;

                          refresh();

                          controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}