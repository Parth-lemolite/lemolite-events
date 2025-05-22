import 'package:flutter/material.dart';

class ProductInfo {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final double pricePerUser;

  ProductInfo({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.pricePerUser,
  });
}