import 'package:flutter/material.dart';

import '../models/course_model.dart';
import 'lesson_screen.dart';

class CourseDetailsScreen extends StatelessWidget {
  final CourseModel course;

  const CourseDetailsScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081225),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                24,
                60,
                24,
                30,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4A6CFF),
                    Color(0xFF7B3FFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    course.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    course.instructor,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 20),

              ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: LinearProgressIndicator(
    value: course.progress,
    minHeight: 8,

  
    backgroundColor: const Color(0xFF7B3FFF),


    valueColor: const AlwaysStoppedAnimation<Color>(
      Colors.white,
    ),
  ),
),
                  const SizedBox(height: 10),

                  Text(
                    "${(course.progress * 100).toInt()}% concluído",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding:
                              const EdgeInsets.all(
                            14,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white10,
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.people,
                                color:
                                    Colors.white,
                              ),
                              const SizedBox(
                                  height: 5),
                              Text(
                                course.students,
                                style:
                                    const TextStyle(
                                  color: Colors
                                      .white,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                              const Text(
                                "Alunos",
                                style:
                                    TextStyle(
                                  color: Colors
                                      .white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Container(
                          padding:
                              const EdgeInsets.all(
                            14,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white10,
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.star,
                                color:
                                    Colors.amber,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "4.8",
                                style:
                                    TextStyle(
                                  color: Colors
                                      .white,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                              Text(
                                "Avaliação",
                                style:
                                    TextStyle(
                                  color: Colors
                                      .white70,
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
            ),

            Padding(
              padding: const EdgeInsets.all(
                20,
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),
                    decoration:
                        BoxDecoration(
                      color: const Color(
                        0xFF111C3D,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.download,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "Baixar Materiais do Curso",
                            style: TextStyle(
                              color:
                                  Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.chevron_right,
                            color:
                                Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Align(
                    alignment:
                        Alignment.centerLeft,
                    child: Text(
                      "Conteúdo do Curso",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  _lessonTile(
                    context,
                    "Context API & Performance",
                  ),

                  _lessonTile(
                    context,
                    "React Hooks Avançados",
                  ),

                  _lessonTile(
                    context,
                    "Redux Toolkit",
                  ),

                  _lessonTile(
                    context,
                    "Deploy e Produção",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lessonTile(
    BuildContext context,
    String title,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(
          0xFF111C3D,
        ),
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.play_circle_fill,
          color: Colors.blue,
          size: 35,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: const Text(
          "Vídeo Aula",
          style: TextStyle(
            color: Colors.white54,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white54,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  LessonScreen(
                title: title,
              ),
            ),
          );
        },
      ),
    );
  }
}