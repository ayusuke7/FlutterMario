import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final String label;
  final double percentage;
  final Color color;

  const ProgressBar({
    super.key,
    required this.label,
    required this.percentage,
    this.color = Colors.red
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(
          fontWeight: FontWeight.bold
        )),
        Container(
          width: 200,
          height: 10,
          decoration: BoxDecoration(
            border: Border.all(),
            gradient: LinearGradient(
            colors: [color, Colors.transparent],
            stops: [percentage, percentage],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
        ),
      ],
    );
  }
}