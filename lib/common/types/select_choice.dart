import 'package:flutter/material.dart';

abstract class SelectChoice {}

class SelectTextChoice implements SelectChoice {
  final String title;
  final String description;

  const SelectTextChoice({required this.title, this.description = ""});
}

class SelectColorChoice implements SelectChoice {
  final Color color;

  const SelectColorChoice({required this.color});
}
