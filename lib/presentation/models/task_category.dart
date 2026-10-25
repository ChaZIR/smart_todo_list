import 'package:flutter/material.dart';

class TaskCategory {
  final String name;
  final IconData icon;
  final Color color;

  const TaskCategory({
    required this.name,
    required this.icon,
    required this.color,
  });

  static const List<TaskCategory> defaultCategories = [
    TaskCategory(
      name: 'work',
      icon: Icons.work,
      color: Colors.blue,
    ),
    TaskCategory(
      name: 'personal',
      icon: Icons.person,
      color: Colors.green,
    ),
    TaskCategory(
      name: 'shopping',
      icon: Icons.shopping_cart,
      color: Colors.orange,
    ),
    TaskCategory(
      name: 'health',
      icon: Icons.favorite,
      color: Colors.red,
    ),
    TaskCategory(
      name: 'study',
      icon: Icons.school,
      color: Colors.purple,
    ),
    TaskCategory(
      name: 'home',
      icon: Icons.home,
      color: Colors.brown,
    ),
  ];
}
