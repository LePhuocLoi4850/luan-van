import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationApply extends StatefulWidget {
  const NotificationApply({super.key});

  @override
  State<NotificationApply> createState() => _NotificationApplyState();
}

class _NotificationApplyState extends State<NotificationApply> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo ứng tuyển'),
      ),
      body: Container(
        color: Colors.blue,
        child: Column(
          children: [
            Text('Ứng tuyển thành công'),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Get.offAllNamed('/homeScreen',
                          arguments: {'selectedIndex': 1});
                    },
                    child: Text('đến trang quản lí việc làm')),
                TextButton(
                    onPressed: () {
                      Get.offAllNamed('/homeScreen');
                    },
                    child: Text('Về trang chủ'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
