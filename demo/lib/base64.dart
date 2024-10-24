import 'dart:convert';

import 'package:demo/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Base64Text extends StatefulWidget {
  const Base64Text({super.key});

  @override
  State<Base64Text> createState() => _Base64TextState();
}

class _Base64TextState extends State<Base64Text> {
  Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    final base64Provider = Provider.of<MyBase64>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('base64'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: imageFromBase64String(base64Provider.base64),
            ),
            Center(
              child: Text(base64Provider.base64),
            ),
          ],
        ),
      ),
    );
  }
}
