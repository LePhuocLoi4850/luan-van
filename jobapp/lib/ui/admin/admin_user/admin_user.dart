import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobapp/server/database.dart';

class AdminUser extends StatefulWidget {
  const AdminUser({super.key});

  @override
  State<AdminUser> createState() => _AdminUserState();
}

class _AdminUserState extends State<AdminUser> {
  List<Map<String, dynamic>> allUser = [];
  bool isLoading = false; // Thêm biến isLoading

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    setState(() {
      isLoading = true; // Đặt isLoading = true trước khi fetch
    });
    try {
      allUser = await Database().fetchAllUserAdmin();
      print(allUser);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false; // Đặt isLoading = false sau khi fetch xong
      });
    }
  }

  Image imageFromBase64String(String base64String) {
    if (base64String.isEmpty || base64String == 'null') {
      return const Image(
        image: AssetImage('assets/images/user.png'),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    }

    try {
      return Image.memory(
        base64Decode(base64String),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } catch (e) {
      print('Error decoding Base64 image: $e');
      return const Image(
        image: AssetImage('assets/images/user.png'),
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý ứng viên'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Hiển thị loading
          : allUser.isEmpty
              ? const Center(child: Text('Không có ứng viên nào.'))
              : ListView.separated(
                  itemCount: allUser.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final user = allUser[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/userDetailAdmin', arguments: user['uid']);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: imageFromBase64String(user['image']),
                          ),
                          title: Text(user['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user['email']),
                              Text(
                                  'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(user['create_at'])}'),
                              Text('Hồ sơ đã ứng tuyển: ${user['num_apply']}'),
                            ],
                          ),
                          trailing: Icon(Icons.remove_red_eye_sharp),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
