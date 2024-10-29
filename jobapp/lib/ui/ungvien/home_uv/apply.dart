import 'package:flutter/material.dart';

class Apply extends StatefulWidget {
  const Apply({super.key});

  @override
  State<Apply> createState() => _ApplyState();
}

class _ApplyState extends State<Apply> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ứng tuyển'),
      ),
    );
  }
}
