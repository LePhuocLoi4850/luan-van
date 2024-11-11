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
        title: Text(
          'Thông báo ứng tuyển',
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white10,
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/cheering.png'),
              width: 400,
              height: 400,
              fit: BoxFit.cover,
            ),
            Text(
              'Ứng tuyển thành công',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 240,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                        onPressed: () {
                          Get.offAllNamed('/homeScreen',
                              arguments: {'selectedIndex': 1});
                        },
                        child: Text('đến trang quản lí việc làm',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ),
                  Container(
                    width: 140,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                        onPressed: () {
                          Get.offAllNamed('/homeScreen');
                        },
                        child: Text('Về trang chủ',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
