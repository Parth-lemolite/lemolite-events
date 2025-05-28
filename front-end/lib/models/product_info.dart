// File: lib/models/product_info.dart
import 'package:flutter/material.dart';

class ProductInfo {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final double pricePerUser;
  String userCount; // New field for user count

  ProductInfo({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.pricePerUser,
    this.userCount = "1", // Default to 1 user
  });
}