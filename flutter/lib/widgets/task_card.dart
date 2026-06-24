import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Container(
            width: 4,
            height: 110,
            decoration: BoxDecoration(
              color: task.color,
              borderRadius:
                  BorderRadius.circular(20),
            ),
          ),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    task.course,
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.white54,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        task.date,
                        style:
                            const TextStyle(
                          color:
                              Colors.white54,
                        ),
                      ),

                      const SizedBox(width: 15),

                      const Icon(
                        Icons.emoji_events,
                        size: 14,
                        color: Colors.white54,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        "${task.points} pts",
                        style:
                            const TextStyle(
                          color:
                              Colors.white54,
                        ),
                      ),

                      const SizedBox(width: 15),

                      const Icon(
                        Icons.attach_file,
                        size: 14,
                        color: Colors.white54,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        "${task.attachments}",
                        style:
                            const TextStyle(
                          color:
                              Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}