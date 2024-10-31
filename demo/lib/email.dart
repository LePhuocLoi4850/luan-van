import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Email extends StatefulWidget {
  const Email({super.key});

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  final String service_id = "service_xxtt3no";
  final String template_id = "template_f3olv3r";
  final String user_id = "LYp5pQzKNIACqoyyf";
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  Future<void> _sendEmail() async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'service_id': service_id,
            'template_id': template_id,
            'user_id': user_id,
            'template_params': {
              'user_name': 'le loi',
              'user_email': 'katoshigm@gmail.com',
              'user_message': 'thank you',
            },
          }));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('email send')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('email'),
        actions: [
          IconButton(onPressed: _sendEmail, icon: Icon(Icons.send)),
        ],
      ),
    );
  }
}
