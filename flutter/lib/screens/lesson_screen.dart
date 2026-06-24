import 'package:flutter/material.dart';

class LessonScreen extends StatelessWidget {
  final String title;

  const LessonScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081225),

      appBar: AppBar(
        backgroundColor: const Color(0xFF081225),
        elevation: 0,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4A6CFF),
                    Color(0xFF7B3FFF),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(24),
              ),
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 90,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Aprenda os conceitos fundamentais desta aula com exemplos práticos e exercícios.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF111C3D),
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red
                          .withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(
                              10),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      "Material Complementar.pdf",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.download,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}