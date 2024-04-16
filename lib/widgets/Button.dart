import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/colors.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isActive;
  const Button({
    super.key, required this.title, required this.onPressed, this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? primaryColor : grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(title, style: TextStyle(color: white, fontSize: 16),),).onTap(() => onPressed());
  }
}