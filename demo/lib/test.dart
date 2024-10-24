import 'dart:convert';
import 'dart:io';

import 'package:demo/base64.dart';
import 'package:demo/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? base64String;
  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      List<int> imageBytes = File(_image!.path).readAsBytesSync();
      base64String = base64Encode(imageBytes);
      Provider.of<MyBase64>(context, listen: false).updateBase64(base64String!);
    }
  }

  Future<void> _takePhotoGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      List<int> imageBytes = File(_image!.path).readAsBytesSync();
      base64String = base64Encode(imageBytes);
      Provider.of<MyBase64>(context, listen: false).updateBase64(base64String!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose image')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Center(
                child: _image == null
                    ? const Text('Choose image in phone or camera')
                    : Image.file(_image!),
              ),
              Center(
                  child: base64String == null
                      ? const Text('image not convert to base64')
                      : Text(base64String!)),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: _takePhoto,
            icon: Icon(Icons.camera),
          ),
          IconButton(
            onPressed: _takePhotoGallery,
            icon: Icon(Icons.camera_alt),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => Base64Text()));
            },
            icon: Icon(Icons.skip_next_rounded),
          ),
        ],
      ),
    );
  }
}
// SingleChildScrollView(
        //   child: Obx(() {
        //     return Column(
        //       children: [
        //         Container(
        //           height: 200,
        //           decoration: const BoxDecoration(
        //             color: Colors.white,
        //             image: DecorationImage(
        //               image: AssetImage('assets/images/backgrounduser.jpg'),
        //               fit: BoxFit.cover,
        //             ),
        //           ),
        //           child: Padding(
        //             padding: const EdgeInsets.all(10.0),
        //             child: Row(
        //               children: [
        //                 ClipOval(
        //                   child: imageFromBase64String(
        //                     controller.userModel.value.image.toString(),
        //                   ),
        //                 ),
        //                 const SizedBox(
        //                   width: 10,
        //                 ),
        //                 Text.rich(
        //                   TextSpan(
        //                     text: controller.userModel.value.name,
        //                     style: const TextStyle(
        //                         fontWeight: FontWeight.bold, fontSize: 20),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.all(15.0),
        //           child: Container(
        //             height: 350,
        //             padding: const EdgeInsets.all(15),
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(15),
        //                 color: Colors.white),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     const Text(
        //                       'Thông tin cá nhân',
        //                       style: TextStyle(
        //                           fontSize: 18, fontWeight: FontWeight.bold),
        //                     ),
        //                     IconButton(
        //                       onPressed: () async {
        //                         await Get.toNamed('/updateInformation');
        //                       },
        //                       icon: const Icon(
        //                         Icons.edit_outlined,
        //                         size: 30,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 Row(
        //                   children: [
        //                     const Icon(Icons.calendar_month_rounded,
        //                         size: 30, color: Colors.grey),
        //                     const SizedBox(
        //                       width: 10,
        //                     ),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         const Text(
        //                           'Ngày sinh',
        //                           style: TextStyle(color: Colors.grey),
        //                         ),
        //                         Text(
        //                           controller.userModel.value.birthday
        //                               .toString(),
        //                           style: const TextStyle(
        //                               fontSize: 16,
        //                               fontWeight: FontWeight.bold),
        //                         )
        //                       ],
        //                     )
        //                   ],
        //                 ),
        //                 Row(
        //                   children: [
        //                     const Icon(Icons.person,
        //                         size: 30, color: Colors.grey),
        //                     const SizedBox(
        //                       width: 10,
        //                     ),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         const Text(
        //                           'Giới tính',
        //                           style: TextStyle(color: Colors.grey),
        //                         ),
        //                         Text(
        //                           controller.userModel.value.gender.toString(),
        //                           style: const TextStyle(
        //                               fontSize: 16,
        //                               fontWeight: FontWeight.bold),
        //                         )
        //                       ],
        //                     )
        //                   ],
        //                 ),
        //                 Row(
        //                   children: [
        //                     const Icon(Icons.email,
        //                         size: 30, color: Colors.grey),
        //                     const SizedBox(
        //                       width: 10,
        //                     ),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         const Text(
        //                           'Email',
        //                           style: TextStyle(color: Colors.grey),
        //                         ),
        //                         Text(
        //                           controller.userModel.value.email.toString(),
        //                           style: const TextStyle(
        //                               fontSize: 16,
        //                               fontWeight: FontWeight.bold),
        //                         )
        //                       ],
        //                     )
        //                   ],
        //                 ),
        //                 Row(
        //                   children: [
        //                     const Icon(Icons.phone,
        //                         size: 30, color: Colors.grey),
        //                     const SizedBox(
        //                       width: 10,
        //                     ),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         const Text(
        //                           'Số điện thoại',
        //                           style: TextStyle(color: Colors.grey),
        //                         ),
        //                         Text(
        //                           controller.userModel.value.phone.toString(),
        //                           style: const TextStyle(
        //                               fontSize: 16,
        //                               fontWeight: FontWeight.bold),
        //                         )
        //                       ],
        //                     )
        //                   ],
        //                 ),
        //                 Row(
        //                   children: [
        //                     const Icon(Icons.location_on,
        //                         size: 30, color: Colors.grey),
        //                     const SizedBox(
        //                       width: 10,
        //                     ),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         const Text(
        //                           'Địa chỉ',
        //                           style: TextStyle(color: Colors.grey),
        //                         ),
        //                         Text(
        //                           controller.userModel.value.address.toString(),
        //                           style: const TextStyle(
        //                               fontSize: 16,
        //                               fontWeight: FontWeight.bold),
        //                         )
        //                       ],
        //                     )
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.all(15.0),
        //           child: Container(
        //             height: 300,
        //             padding: const EdgeInsets.all(15),
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(15),
        //                 color: Colors.white),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 const Padding(
        //                   padding: EdgeInsets.only(bottom: 10.0),
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Text(
        //                         'Trình độ học vấn',
        //                         style: TextStyle(
        //                             fontSize: 18, fontWeight: FontWeight.bold),
        //                       ),
        //                       Icon(
        //                         Icons.edit_outlined,
        //                         size: 30,
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //                 Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     const Text(
        //                       'Học vấn',
        //                       style: TextStyle(color: Colors.grey),
        //                     ),
        //                     Text(
        //                       controller.userModel.value.education!.isEmpty
        //                           ? 'Cập nhật'
        //                           : controller.userModel.value.education
        //                               .toString(),
        //                       style: const TextStyle(
        //                           fontSize: 16,
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.blue),
        //                     ),
        //                   ],
        //                 ),
        //                 Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     const Text(
        //                       'Kỹ năng',
        //                       style: TextStyle(color: Colors.grey),
        //                     ),
        //                     Text(
        //                       controller.userModel.value.skill!.isEmpty
        //                           ? 'Cập nhật'
        //                           : controller.userModel.value.skill.toString(),
        //                       style: const TextStyle(
        //                           fontSize: 16,
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.blue),
        //                     )
        //                   ],
        //                 ),
        //                 Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     const Text(
        //                       'Chứng chỉ',
        //                       style: TextStyle(color: Colors.grey),
        //                     ),
        //                     Text(
        //                       controller.userModel.value.certificate!.isEmpty
        //                           ? 'Cập nhật'
        //                           : controller.userModel.value.certificate
        //                               .toString(),
        //                       style: const TextStyle(
        //                           fontSize: 16,
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.blue),
        //                     )
        //                   ],
        //                 ),
        //                 Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     const Text(
        //                       'Kinh nghiệm',
        //                       style: TextStyle(color: Colors.grey),
        //                     ),
        //                     Text(
        //                       controller.userModel.value.prize!.isEmpty
        //                           ? 'Cập nhật'
        //                           : controller.userModel.value.prize.toString(),
        //                       style: const TextStyle(
        //                           fontSize: 16,
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.blue),
        //                     )
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.all(15.0),
        //           child: Container(
        //             height: 120,
        //             padding: const EdgeInsets.all(15),
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(15),
        //                 color: Colors.white),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 const Padding(
        //                   padding: EdgeInsets.only(bottom: 10.0),
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Text(
        //                         'Giới thiệu bản thân',
        //                         style: TextStyle(
        //                             fontSize: 18, fontWeight: FontWeight.bold),
        //                       ),
        //                       Icon(
        //                         Icons.edit_outlined,
        //                         size: 30,
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //                 Text(
        //                     controller.userModel.value.description!.isEmpty
        //                         ? 'Cập nhật'
        //                         : controller.userModel.value.description
        //                             .toString(),
        //                     style: TextStyle(
        //                       fontSize: 16,
        //                       fontWeight: FontWeight.bold,
        //                       color: controller
        //                               .userModel.value.description!.isEmpty
        //                           ? Colors.blue
        //                           : Colors.black87,
        //                     ))
        //               ],
        //             ),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.all(15.0),
        //           child: Container(
        //             height: 120,
        //             padding: const EdgeInsets.all(15),
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(15),
        //                 color: Colors.white),
        //             child: const Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Padding(
        //                   padding: EdgeInsets.only(bottom: 10.0),
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Text(
        //                         'Giải thưởng',
        //                         style: TextStyle(
        //                             fontSize: 18, fontWeight: FontWeight.bold),
        //                       ),
        //                       Icon(
        //                         Icons.edit_outlined,
        //                         size: 30,
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //                 Text(
        //                   'Cập nhật',
        //                   style: TextStyle(
        //                       fontSize: 16,
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.blue),
        //                 )
        //               ],
        //             ),
        //           ),
        //         )
        //       ],
        //     );
        //   }),
        // ),
// SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.all(15.0),
          //     child: Column(
          //       children: [
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 const Text(
          //                   'Kinh nghiệm làm việc',
          //                   style: TextStyle(
          //                       fontSize: 18, fontWeight: FontWeight.w600),
          //                 ),
          //                 TextButton(
          //                   onPressed: () {
          //                     _showBottomSheet();
          //                   },
          //                   child: const Text(
          //                     'Sửa',
          //                     style:
          //                         TextStyle(fontSize: 18, color: Colors.blue),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             if (_experienceController.text.isNotEmpty)
          //               IntrinsicWidth(
          //                 child: Container(
          //                   height: 30,
          //                   padding: const EdgeInsets.symmetric(horizontal: 10),
          //                   decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(10),
          //                       color: Colors.grey[300]),
          //                   child: Align(
          //                     alignment: Alignment.center,
          //                     child: Text(
          //                       _experienceController.text,
          //                       style: const TextStyle(
          //                           fontSize: 16, fontWeight: FontWeight.bold),
          //                     ),
          //                   ),
          //                 ),
          //               )
          //           ],
          //         ),
          //         const Divider(),
          //         Column(
          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 const Text(
          //                   'Công việc mong muốn',
          //                   style: TextStyle(
          //                       fontSize: 18, fontWeight: FontWeight.w600),
          //                 ),
          //                 TextButton(
          //                   onPressed: () {
          //                     _showListJobBottomSheet();
          //                   },
          //                   child: const Text(
          //                     'Sửa',
          //                     style:
          //                         TextStyle(fontSize: 18, color: Colors.blue),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             if (_listJob.isNotEmpty)
          //               IntrinsicWidth(
          //                 child: Container(
          //                   height: 30,
          //                   padding: const EdgeInsets.symmetric(horizontal: 10),
          //                   decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(10),
          //                       color: Colors.grey[300]),
          //                   child: Align(
          //                     alignment: Alignment.center,
          //                     child: Text(
          //                       _jobController.text,
          //                       style: const TextStyle(
          //                           fontSize: 16, fontWeight: FontWeight.bold),
          //                     ),
          //                   ),
          //                 ),
          //               )
          //           ],
          //         ),
          //         const Divider(),
          //         Column(
          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 const Text(
          //                   'Địa điểm mong muốn',
          //                   style: TextStyle(
          //                       fontSize: 18, fontWeight: FontWeight.w600),
          //                 ),
          //                 TextButton(
          //                   onPressed: () {},
          //                   child: const Text(
          //                     'Sửa',
          //                     style:
          //                         TextStyle(fontSize: 18, color: Colors.blue),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          // ),




          //  List<String> _listJob = [];
  // final _experienceController = TextEditingController();
  // final _jobController = TextEditingController();
  // final _addressController = TextEditingController();

  // bottomsheet

  
  // void _showBottomSheet() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (builder) {
  //         return SizedBox(
  //           width: double.infinity,
  //           height: 350,
  //           child: Column(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(15.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     const Text(
  //                       "Chọn số năm kinh nghiệm",
  //                       style: TextStyle(
  //                           fontSize: 20, fontWeight: FontWeight.bold),
  //                     ),
  //                     TextButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                       child: const Text(
  //                         'Xong',
  //                         style: TextStyle(
  //                             fontSize: 20,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.blue),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Expanded(
  //                 child: SingleChildScrollView(
  //                   child: ListView.builder(
  //                     shrinkWrap: true,
  //                     physics: const NeverScrollableScrollPhysics(),
  //                     itemCount: kn.length,
  //                     itemBuilder: (context, index) {
  //                       return Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: ListTile(
  //                           title: Align(
  //                             alignment: Alignment.center,
  //                             child: Text(
  //                               kn[index].toString(),
  //                               style: const TextStyle(
  //                                 fontSize: 18,
  //                               ),
  //                             ),
  //                           ),
  //                           onTap: () {
  //                             setState(
  //                               () {
  //                                 _experienceController.text = kn[index];
  //                                 print(_experienceController.text);
  //                                 Navigator.pop(context);
  //                               },
  //                             );
  //                           },
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }

  // void _showListJobBottomSheet() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (builder) {
  //         return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setModalState) {
  //           return FractionallySizedBox(
  //             heightFactor: 0.85,
  //             child: Column(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(15.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       const Text(
  //                         "Chọn số năm kinh nghiệm",
  //                         style: TextStyle(
  //                             fontSize: 20, fontWeight: FontWeight.bold),
  //                       ),
  //                       TextButton(
  //                         onPressed: () {
  //                           if (_listJob.isNotEmpty) {
  //                             setState(() {
  //                               _jobController.text = _listJob.join(", ");
  //                             });
  //                           }
  //                           Navigator.pop(context);
  //                         },
  //                         child: const Text(
  //                           'Xong',
  //                           style: TextStyle(
  //                               fontSize: 20,
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.blue),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: SingleChildScrollView(
  //                     child: ListView.builder(
  //                       shrinkWrap: true,
  //                       physics: const NeverScrollableScrollPhysics(),
  //                       itemCount: kn.length,
  //                       itemBuilder: (context, index) {
  //                         return Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 kn[index].toString(),
  //                                 style: const TextStyle(
  //                                   fontSize: 18,
  //                                 ),
  //                               ),
  //                               Checkbox(
  //                                 value: _listJob.contains(kn[index]),
  //                                 onChanged: (bool? value) {
  //                                   setModalState(
  //                                     () {
  //                                       if (value == true) {
  //                                         if (_listJob.length < 3) {
  //                                           _listJob.add(kn[index]);
  //                                         }
  //                                       } else {
  //                                         if (_listJob.length > 1) {
  //                                           _listJob.remove(kn[index]);
  //                                         }
  //                                       }
  //                                     },
  //                                   );
  //                                 },
  //                               ),
  //                             ],
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           );
  //         });
  //       });
  // }