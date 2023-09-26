import 'package:flutter/material.dart';

class IconCountWidget extends StatelessWidget {
  const IconCountWidget({super.key, required this.count, required this.text});

  final String count;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(count == "" ? "0" : count,style: const TextStyle(fontWeight: FontWeight.bold),),
        const SizedBox(
          width: 5,
        ),
        Text(text,style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
