import 'package:flutter/material.dart';

class LineTop extends StatelessWidget implements PreferredSizeWidget {
  const LineTop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.0,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 208, 208, 208),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 146, 145, 145).withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(1.0);
}
