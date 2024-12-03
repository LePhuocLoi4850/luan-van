import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

class ChooseRole extends StatefulWidget {
  const ChooseRole({super.key});

  @override
  State<ChooseRole> createState() => _ChooseRoleState();
}

class _ChooseRoleState extends State<ChooseRole> {
  AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.blue[50]),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Hãy chọn vai trò của bạn',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.chooseRole('user', controller.email.toString());
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: 600,
                    height: 200,
                    decoration: BoxDecoration(color: Colors.blue[100]),
                    child: const Center(
                      child: Text(
                        'Ứng viên',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.chooseRole('company', controller.email.toString());
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: 600,
                    height: 200,
                    decoration: BoxDecoration(color: Colors.blue[100]),
                    child: const Center(
                      child: Text('Nhà tuyển dụng',
                          style: TextStyle(fontSize: 30)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//  Future<void> updateUserData(
//       String email,
//       String name,
//       String pass,
//       String role,
//       DateTime creationDate,
//       String career,
//       int phone,
//       String birthday,
//       String gender,
//       String address,
//       String description,
//       String image) async {
//     final conn = DatabaseConnection().connection;
//     try {
//       await conn?.execute(
//         Sql.named(
//             'UPDATE users SET email = @email, name = @name, pass = @pass, role = @role, creationDate = @creationDate, career = @career, phone = @phone, birthday = @birthday, gender = @gender, address = @address, description = @description, image = @image  WHERE email = @email'),
//         parameters: {
//           'email': email,
//           'name': name,
//           'pass': pass,
//           'role': role,
//           'creationDate': creationDate,
//           'career': career,
//           'phone': phone,
//           'birthday': birthday,
//           'gender': gender,
//           'address': address,
//           'description': description,
//           'image': image,
//         },
//       );
//       base64 = image;
//       _saveData(base64!);
//       Get.offAllNamed('/homeUV');
//     } catch (e) {
//       print(e);
//       return;
//     }
//   }