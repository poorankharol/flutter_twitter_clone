import 'package:flutter/material.dart';

class IconTextWidget extends StatelessWidget {
  const IconTextWidget({super.key, required this.icons, required this.text});

  final IconData icons;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icons,
          color: Colors.grey,
          size: 20,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(text),
      ],
    );
  }
}
