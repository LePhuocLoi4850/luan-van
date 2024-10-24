import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'user_gird_title.dart';

class UserGird extends StatefulWidget {
  const UserGird({super.key});

  @override
  State<UserGird> createState() => _UserGirdState();
}

class _UserGirdState extends State<UserGird> {
  List<Map<String, dynamic>> data = [];
  @override
  void initState() {
    super.initState();
    data = Get.arguments;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Danh sách ứng viên'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(5.0),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final user = data[index];
            final userData = {
              'uid': user['uid'],
              'name': user['name'],
              'career': user['career'],
              'birthday': user['birthday'],
              'gender': user['gender'],
              'address': user['address'],
              'image': user['image'],
              'salaryFrom': user['salaryFrom'],
              'salaryTo': user['salaryTo'],
              'create_at': user['create_at'],
            };
            return Container(
                width: double.infinity,
                height: 210,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: UserGirdTitle(girdUV: userData));
          },
        ));
  }
}
