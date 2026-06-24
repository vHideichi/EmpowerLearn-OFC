import 'package:flutter/material.dart';

class TaskModel {
  final String title;
  final String course;
  final String date;
  final int points;
  final int attachments;
  final Color color;
  final String status;

  TaskModel({
    required this.title,
    required this.course,
    required this.date,
    required this.points,
    required this.attachments,
    required this.color,
    required this.status,
  });
}