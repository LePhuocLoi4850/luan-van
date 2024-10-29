import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

class InsertSkill extends StatefulWidget {
  const InsertSkill({super.key});

  @override
  _InsertSkillState createState() => _InsertSkillState();
}

class _InsertSkillState extends State<InsertSkill> {
  final AuthController controller = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _skillNameController = TextEditingController();
  double _rating = 0;

  Future<void> _saveSkill() async {
    if (_formKey.currentState!.validate()) {
      int uid = controller.userModel.value.id!;
      String name = _skillNameController.text;
      int rating = _rating.toInt();
      try {
        await Database().insertSkill(uid, name, rating);
        Get.back(result: true);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm kỹ năng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Tên kỹ năng',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _skillNameController,
                decoration: InputDecoration(
                  hintText: 'Nhập tên công ty',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên kỹ năng';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              _saveSkill();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Thêm thông tin',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
