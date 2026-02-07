import 'package:flutter/material.dart';

class HorizontalSpacing extends StatelessWidget {
  const HorizontalSpacing({super.key, required this.spacing});

  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: spacing);
  }
}

class VerticalSpacing extends StatelessWidget {
  const VerticalSpacing({super.key, required this.spacing});

  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: spacing);
  }
}
