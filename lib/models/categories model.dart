import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  CategoryModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, String docId) {
    String title = map['title'] ?? 'Service';
    Map<String, dynamic> style = getCategoryStyle(title);

    return CategoryModel(
      id: docId,
      title: title,
      icon: style['icon'],
      backgroundColor: style['color'],
      iconColor: style['iconColor'],
    );
  }

  static Map<String, dynamic> getCategoryStyle(String title) {
    String lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('ac')) {
      return {
        'icon': CupertinoIcons.wind,
        'color': Color(0xFFE3F2FD),
        'iconColor': Colors.blue,
      };
    } else if (lowerTitle.contains('electric') || lowerTitle.contains('socket')) {
      return {
        'icon': CupertinoIcons.bolt_fill,
        'color': Color(0xFFFFF8E1),
        'iconColor': Colors.amber,
      };
    } else if (lowerTitle.contains('plumb')) {
      return {
        'icon': CupertinoIcons.drop_fill,
        'color': Color(0xFFE0F7FA),
        'iconColor': Colors.cyan,
      };
    } else if (lowerTitle.contains('carpentr') || lowerTitle.contains('wood')) {
      return {
        'icon': CupertinoIcons.hammer_fill,
        'color': Color(0xFFEFEBE9),
        'iconColor': Colors.brown,
      };
    } else if (lowerTitle.contains('paint')) {
      return {
        'icon': CupertinoIcons.paintbrush_fill,
        'color': Color(0xFFFCE4EC),
        'iconColor': Colors.pink,
      };
    } else if (lowerTitle.contains('pest')) {
      return {
        'icon': CupertinoIcons.ant_fill,
        'color': Color(0xFFE8F5E9),
        'iconColor': Colors.green,
      };
    } else {
      return {
        'icon': CupertinoIcons.wrench_fill,
        'color': Color(0xFFEFF9FF),
        'iconColor': Colors.blue,
      };
    }
  }
}