import 'package:flutter/material.dart';

/// One entry in the Women / Men / Accessories / Beauty row on the Home Page.
class CategoryModel {
  final String id;
  final String label;
  final IconData icon;

  const CategoryModel({
    required this.id,
    required this.label,
    required this.icon,
  });
}
