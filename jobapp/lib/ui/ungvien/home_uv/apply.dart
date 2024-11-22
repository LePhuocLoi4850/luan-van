import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../controller/cv_storage_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../server/database.dart';
import '../../auth/auth_controller.dart';

class Apply extends StatefulWidget {
  const Apply({super.key});

  @override
  State<Apply> createState() => _ApplyState();
}

class _ApplyState extends State<Apply> {
  final cvStorageController = Get.find<CvStorageController>();
  final UserController userController = Get.find<UserController>();
  AuthController controller = Get.find<AuthController>();
  final String service_id = "service_xxtt3no";
  final String template_uid = "template_f3olv3r";
  final String template_cid = "template_x8l3448";
  final String user_id = "LYp5pQzKNIACqoyyf";
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  int? _selectedCvIndex;
  int? _groupValue = 1;
  int? _groupValue1;
  String? emailCompany;
  String? address;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> detailJob = {};
  bool isLoading = false;
  bool isCVProfile = false;
  String salary = '';
  @override
  void initState() {
    super.initState();
    detailJob = Get.arguments;
    salary = '${detailJob['salaryFrom']} - ${detailJob['salaryTo']}';
    int lastCommaIndex = detailJob['address'].lastIndexOf(",");
    address = detailJob['address'].substring(lastCommaIndex + 1).trim();
    fetchEmailForCid();
  }

  Future<void> _sendEmailUser() async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'service_id': service_id,
            'template_id': template_uid,
            'user_id': user_id,
            'template_params': {
              'company_name': detailJob['name'],
              'user_name': _nameController.text,
              'user_email': _emailController.text,
              'title': detailJob['title'],
              'salary': salary,
              'address': address,
              'day': 20,
              'base64': detailJob['image'],
              'base64Logo': detailJob['image'],
            },
          }));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('gửi cho ứng viên thành công')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error')),
      );
    }
  }

  Future<void> _sendEmailCompany() async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'service_id': service_id,
            'template_id': template_cid,
            'user_id': user_id,
            'template_params': {
              'job_title': detailJob['title'],
              'company_name': detailJob['name'],
              'company_email': emailCompany,
              'user_name': _nameController.text,
              'user_phone': _phoneController.text,
              'user_email': _emailController.text,
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

  void fetchEmailForCid() async {
    try {
      emailCompany =
          await Database().selectEmailCompanyForCid(detailJob['cid']);
    } catch (e) {
      print(e);
    }
  }

  void apply() async {
    setState(() {
      isLoading = true;
    });
    int uid = controller.userModel.value.id!;
    String status = 'applied';
    int jid = detailJob['jid'];
    int cid = detailJob['cid'];
    String nameU = controller.userModel.value.name.toString();
    String title = detailJob['title'];
    String nameC = detailJob['name'];
    String address = detailJob['address'];
    String experience = detailJob['experience'];
    String salaryFrom = detailJob['salaryFrom'];
    String salaryTo = detailJob['salaryTo'];
    String imageC = detailJob['image'];
    String imageU = controller.userModel.value.image!;
    int cvId = cvStorageController.cvData[_selectedCvIndex!].cvId;
    String nameCv = cvStorageController.cvData[_selectedCvIndex!].nameCv;
    DateTime applyDate = DateTime.now();

    try {
      await Database().apply(
          jid,
          uid,
          cid,
          nameU,
          title,
          nameC,
          address,
          experience,
          salaryFrom,
          salaryTo,
          applyDate,
          status,
          imageC,
          imageU,
          cvId,
          nameCv);
      print('ứng tuyển thành công');
      await _sendEmailUser();
      await _sendEmailCompany();
      setState(() {
        isLoading = false;
      });
      Get.offAllNamed('/notificationApply');
    } catch (e) {
      print('Ứng tuyển lỗi: $e');
    }
  }

  void _showCvBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[200],
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return FractionallySizedBox(
            heightFactor: 0.6,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'CV từ thư viện của tôi',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          'CV ĐÃ TẢI LÊN',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      cvStorageController.cvData.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          'Chưa có CV nào được tải lên',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'Tải lên CV có sẳn trong thiết bị để tiếp cận tốt hơn với nhà tuyển dụng',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[400]),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 170,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              final result = await Get.toNamed(
                                                  '/uploadCV');
                                              if (result == true) {
                                                setState(() {});
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color: Color.fromARGB(
                                                      136, 0, 0, 0),
                                                ),
                                                Text(
                                                  ' Tải CV ngay',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cvStorageController.cvData.length,
                              itemBuilder: (context, index) {
                                final cv = cvStorageController.cvData[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Radio<int>(
                                          value: index,
                                          groupValue: _selectedCvIndex,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedCvIndex = value;
                                              _groupValue1 = null;
                                            });
                                            this.setState(() {
                                              _selectedCvIndex = value;
                                              isCVProfile = false;
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(cv.nameCv),
                                              Text(
                                                'Cập nhật lần cuối: ${DateTime.parse(cv.time.toString()).year}/${DateTime.parse(cv.time.toString()).month}/${DateTime.parse(cv.time.toString()).day}',
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Text('Xem'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          'CV Profile',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5),
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _groupValue1,
                                onChanged: (value) {
                                  setState(() {
                                    _groupValue1 = value;
                                    _selectedCvIndex = null;
                                  });
                                  this.setState(() {
                                    isCVProfile = true;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('CV Profile'),
                                    Text(
                                      'Cập nhật lần cuối: ${DateTime.parse(controller.userModel.value.createdAt.toString()).year}/${DateTime.parse(controller.userModel.value.createdAt.toString()).month}/${DateTime.parse(controller.userModel.value.createdAt.toString()).day}',
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed('/cvProfileScreen');
                                },
                                child: Text('Xem'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ứng tuyển'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'CV ứng tuyển',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildRadioListTile(
                      title: 'CV từ thư viện của tôi',
                      value: 1,
                      selectedBorderColor: Colors.blue,
                      unselectedBorderColor: Colors.grey,
                      child: SizedBox(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showCvBottomSheet(context);
                              },
                              child: isCVProfile
                                  ? Container(
                                      width: 350,
                                      height: _groupValue == 1 ? 70 : 0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 201, 201, 201)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'CV Profile',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Cập nhật lần cuối: ${DateTime.parse(controller.userModel.value.createdAt.toString()).year}/${DateTime.parse(controller.userModel.value.createdAt.toString()).month}/${DateTime.parse(controller.userModel.value.createdAt.toString()).day}',
                                                  style: TextStyle(
                                                      color: Colors.grey[500]),
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              size: 30,
                                              color: Colors.grey[500],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : _selectedCvIndex != null
                                      ? Container(
                                          width: 350,
                                          height: _groupValue == 1 ? 70 : 0,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 201, 201, 201)),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      cvStorageController
                                                          .cvData[
                                                              _selectedCvIndex!]
                                                          .nameCv,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Cập nhật lần cuối: ${DateTime.parse(cvStorageController.cvData[_selectedCvIndex!].time.toString()).year}/${DateTime.parse(cvStorageController.cvData[_selectedCvIndex!].time.toString()).month}/${DateTime.parse(cvStorageController.cvData[_selectedCvIndex!].time.toString()).day}',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[500]),
                                                    ),
                                                  ],
                                                ),
                                                Icon(
                                                  Icons
                                                      .keyboard_arrow_down_sharp,
                                                  size: 30,
                                                  color: Colors.grey[500],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Container(
                                            width: 350,
                                            height: _groupValue == 1 ? 70 : 0,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blue, width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.download_rounded,
                                                  size: 30,
                                                  color: Colors.blue,
                                                ),
                                                Text(
                                                  'Hãy chọn CV của bạn',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                            ),
                            SizedBox(
                              width: 350,
                              height: _groupValue == 1 ? 15 : 0,
                            ),
                            Container(
                              width: 350,
                              height: _groupValue == 1 ? 300 : 0,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Họ và tên',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'Nhập họ và tên',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 14),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                          controller: _nameController,
                                          keyboardType: TextInputType.name,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Hãy cho tôi biết họ và tên của bạn';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const Text(
                                        'Số điện thoại',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'Nhập số điện thoại',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 14),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                          controller: _phoneController,
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Hãy cho tôi biết họ và tên của bạn';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const Text(
                                        'Email',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'Nhập email',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 14),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                          controller: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Hãy cho tôi biết họ và tên của bạn';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 350,
                              height: _groupValue == 1 ? 15 : 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildRadioListTile(
                      title: 'Tải CV lên từ điện thoại',
                      value: 2,
                      selectedBorderColor: Colors.blue,
                      unselectedBorderColor: Colors.grey,
                      child: SizedBox(
                        child: Column(
                          children: [
                            Container(
                              width: 350,
                              height: _groupValue == 2 ? 200 : 0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.blue)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        colors: [Colors.white, Colors.blue],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds);
                                    },
                                    child: const Icon(
                                      Icons.cloud_upload_rounded,
                                      size: 50,
                                      color: Color.fromARGB(255, 122, 188, 243),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Nhấn để tải lên',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: const TextSpan(
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        children: [
                                          TextSpan(
                                              text:
                                                  'Hỗ trợ định dạng .doc, .docx, pdf có kích thước dưới '),
                                          TextSpan(
                                            text: '5MB',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 350,
                              height: _groupValue == 2 ? 15 : 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: SizedBox(
              width: 180,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  apply();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Ứng tuyển ngay',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioListTile({
    required String title,
    required int value,
    required Color selectedBorderColor,
    required Color unselectedBorderColor,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AnimatedContainer(
        // Sử dụng AnimatedContainer để tạo hiệu ứng chuyển đổi mượt mà
        duration: Duration(milliseconds: 300), // Thời gian chuyển đổi
        curve: Curves.easeInOut, // Đường cong chuyển đổi
        decoration: BoxDecoration(
          border: Border.all(
            color: _groupValue == value
                ? selectedBorderColor
                : unselectedBorderColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            RadioListTile<int>(
              title: Text(title),
              value: value,
              groupValue: _groupValue,
              onChanged: (value) {
                setState(() {
                  _groupValue = value;
                });
              },
            ),
            child,
          ],
        ),
      ),
    );
  }
}
