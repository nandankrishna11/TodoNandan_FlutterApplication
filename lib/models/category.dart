import 'package:flutter/material.dart';

class Category {
  final String id;
  final String userId;
  final String name;
  final Color color;
  final IconData icon;

  Category({
    required this.id,
    required this.userId,
    required this.name,
    required this.color,
    required this.icon,
  });

  // For storage, you may want to convert color/icon to int/string
  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      color: Color(map['color'] ?? 0xFF2196F3),
      icon: IconData(map['icon'] ?? 0xe3af, fontFamily: 'MaterialIcons'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'color': color.value,
      'icon': icon.codePoint,
    };
  }
} 