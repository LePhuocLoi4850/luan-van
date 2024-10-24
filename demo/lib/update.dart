import 'package:demo/controller.dart';
import 'package:demo/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final AuthController userController = Get.find();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();

    // Khởi tạo TextEditingController với thông tin từ userModel hiện tại
    _nameController =
        TextEditingController(text: userController.userModel.value.name);
    _emailController =
        TextEditingController(text: userController.userModel.value.email);
    _ageController = TextEditingController(
        text: userController.userModel.value.age.toString());
  }

  @override
  void dispose() {
    // Giải phóng tài nguyên
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tạo một UserModel mới với thông tin từ form
                UserModel updatedUser = UserModel(
                  name: _nameController.text,
                  email: _emailController.text,
                  age: int.tryParse(_ageController.text) ?? 0,
                );

                // Gọi controller để cập nhật và lưu thông tin
                userController.updateUser(updatedUser);

                // Quay lại màn hình trước
                Get.back();
              },
              child: Text('Update User'),
            ),
          ],
        ),
      ),
    );
  }
}
