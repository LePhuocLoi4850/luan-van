import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../server/database.dart';
import '../../../../auth/auth_controller.dart';

class UpdateDescription extends StatefulWidget {
  const UpdateDescription({super.key});

  @override
  State<UpdateDescription> createState() => _UpdateDescriptionState();
}

class _UpdateDescriptionState extends State<UpdateDescription> {
  final AuthController controller = Get.find<AuthController>();
  final _gioithieuController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _gioithieuController.text =
        controller.userModel.value.description.toString();
  }

  void _handelUpdateDescription() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    int uid = controller.userModel.value.id!;
    String description = _gioithieuController.text;
    try {
      await Database().updateDescription(uid, description);
      controller.userModel.value =
          controller.userModel.value.copyWith(description: description);
      await controller.saveUserData(controller.userModel.value);

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thông tin công ty thành công'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Get.back();
    } catch (e) {
      print('update description error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giới thiệu bản thân'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Giới thiệu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    maxLines: 6,
                    controller: _gioithieuController,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter, // Đặt nút ở dưới cùng
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        _handelUpdateDescription();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 11.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cập nhật',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
