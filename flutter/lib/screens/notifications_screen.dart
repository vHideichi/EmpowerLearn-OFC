import 'package:flutter/material.dart';

import '../models/notification_model.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      NotificationModel(
        title: "Novo comentário na sua publicação",
        subtitle: "Sarah respondeu sua dúvida.",
        time: "5 min",
      ),
      NotificationModel(
        title: "Curtiram sua publicação",
        subtitle: "Michael curtiu seu post.",
        time: "20 min",
      ),
      NotificationModel(
        title: "Novo curso disponível",
        subtitle: "React Avançado foi liberado.",
        time: "1h",
      ),
      NotificationModel(
        title: "Meta concluída",
        subtitle: "Você concluiu sua meta semanal.",
        time: "3h",
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF081225),

      appBar: AppBar(
        backgroundColor: const Color(0xFF081225),
        elevation: 0,
        centerTitle: true,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          "Notificações",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        itemCount: notifications.length,
        itemBuilder: (_, index) {
          return NotificationCard(
            notification: notifications[index],
          );
        },
      ),
    );
  }
}