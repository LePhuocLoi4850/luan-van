import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  static Future<void> storeUserInfo(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }
}
// import 'dart:convert';
// import 'dart:io';
// import 'package:image/image.dart' as img;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:jobapp/models/career.dart';

// import 'auth_controller.dart';

// class UpdateProfileUser extends StatefulWidget {
//   const UpdateProfileUser({super.key});

//   @override
//   State<UpdateProfileUser> createState() => _UpdateProfileUserState();
// }

// class _UpdateProfileUserState extends State<UpdateProfileUser> {
//   final AuthController controller = Get.find<AuthController>();
//   final _formKey = GlobalKey<FormState>();
//   DateTime? _selectedDate;
//   Career? selectedCareer;
//   CareerManager careerManager = CareerManager();
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   String? base64String;
//   final _ngaysinhController = TextEditingController();
//   final _gioitinhController = TextEditingController();
//   final _careerController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _gioithieuController = TextEditingController();

//   // Future<void> _takePhoto() async {
//   //   final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       _image = File(pickedFile.path);
//   //     });
//   //     List<int> imageBytes = File(_image!.path).readAsBytesSync();
//   //     base64String = base64Encode(imageBytes);
//   //     Provider.of<MyBase64>(context, listen: false).updateBase64(base64String!);
//   //   }
//   // }
//   Future<void> _handleUpdateUser() async {
//     if (_formKey.currentState!.validate()) {
//       final email = controller.email!;
//       int phone = (int.tryParse(_phoneController.text) ?? 0);
//       String? birthday = formatDate(_selectedDate);
//       final gender = _gioitinhController.text;
//       final career = _careerController.text;
//       final address = _addressController.text;
//       final description = _gioithieuController.text;
//       final image = base64String;
//       try {
//         controller.updateUserData(email, phone, birthday!, gender, career,
//             address, description, image!);
//       } catch (e) {
//         return;
//       }
//     }
//   }

//   // Future<void> _takePhotoGallery() async {
//   //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       _image = File(pickedFile.path);
//   //     });
//   //     List<int> imageBytes = File(_image!.path).readAsBytesSync();
//   //     base64String = base64Encode(imageBytes);
//   //     print(base64String);
//   //   }
//   // }
//   Future<void> _takePhotoGallery() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });

//       img.Image? image = img.decodeImage(File(_image!.path).readAsBytesSync());

//       img.Image resizedImage = img.copyResize(image!, width: 50, height: 50);

//       List<int> imageBytes = img.encodePng(resizedImage);

//       base64String = base64Encode(imageBytes);
//       // print(base64String);
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//         _ngaysinhController.text =
//             "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
//       });
//     }
//   }

//   String? formatDate(DateTime? date) {
//     if (date == null) {
//       return null;
//     }
//     final DateFormat formatter = DateFormat('yyyy-MM-dd');
//     return formatter.format(date);
//   }

//   void _showCareerBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   'Chọn ngành nghề',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18.0,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 900,
//                 child: ListView.builder(
//                   itemCount: careerManager.allCareer.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(left: 16.0, right: 16),
//                       child: ListTile(
//                         title: Text(
//                           careerManager.allCareer[index].name,
//                         ),
//                         onTap: () {
//                           setState(() {
//                             selectedCareer = careerManager.allCareer[index];
//                             _careerController.text =
//                                 careerManager.allCareer[index].name;
//                           });
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: FocusScope.of(context).unfocus,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Profile',
//             style: TextStyle(
//                 fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           centerTitle: true,
//           backgroundColor: Colors.blue,
//         ),
//         body: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Container(
//                   decoration: const BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius:
//                           BorderRadius.vertical(bottom: Radius.circular(30))),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             _takePhotoGallery();
//                           },
//                           child: Center(
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(100),
//                                   ),
//                                   width: 100,
//                                   height: 100,
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(100),
//                                     child: _image == null
//                                         ? const Image(
//                                             image: AssetImage(
//                                               'assets/images/user.png',
//                                             ),
//                                             fit: BoxFit.cover,
//                                           )
//                                         : Image.file(
//                                             _image!,
//                                             fit: BoxFit.cover,
//                                           ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: -10,
//                                   right: 0,
//                                   child: Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(100),
//                                     ),
//                                     child: const Icon(
//                                       Icons.camera_alt_rounded,
//                                       color: Color.fromARGB(255, 49, 49, 49),
//                                       size: 30,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               controller.name!,
//                               style: const TextStyle(
//                                   fontSize: 24,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               controller.email!,
//                               style: const TextStyle(
//                                   fontSize: 20, color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           _showCareerBottomSheet(context);
//                         },
//                         child: Container(
//                           height: 55,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.black),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           padding: const EdgeInsets.all(10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Icon(Icons.card_travel_outlined),
//                               const SizedBox(
//                                 width: 15,
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   _careerController.text.isNotEmpty
//                                       ? _careerController.text
//                                       : 'Loại Hình Công Việc',
//                                   style: TextStyle(
//                                     color: _careerController.text.isNotEmpty
//                                         ? Colors.black
//                                         : Color.fromARGB(255, 69, 69, 69),
//                                   ),
//                                 ),
//                               ),
//                               const Icon(Icons.arrow_drop_down),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(
//                             Icons.phone_android_rounded,
//                             color: Colors.grey[800],
//                           ),
//                           hintText: 'Nhập số điện thoại',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         controller: _phoneController,
//                         keyboardType: TextInputType.phone,
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       TextFormField(
//                         readOnly: true,
//                         onTap: () => _selectDate(context),
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(
//                             Icons.date_range_outlined,
//                             color: Colors.grey[800],
//                           ),
//                           hintText: 'Ngày tháng năm sinh',
//                           suffixIcon: Icon(
//                             Icons.arrow_drop_down,
//                             color: Colors.grey[800],
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         controller: _ngaysinhController,
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           const Text(
//                             'Giới tính:',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           Row(
//                             children: [
//                               Radio<String>(
//                                 value: 'Nam',
//                                 groupValue: _gioitinhController.text,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _gioitinhController.text = value!;
//                                   });
//                                 },
//                               ),
//                               const Text(
//                                 'Nam',
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Radio<String>(
//                                 value: 'Nữ',
//                                 groupValue: _gioitinhController.text,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _gioitinhController.text = value!;
//                                   });
//                                 },
//                               ),
//                               const Text(
//                                 'Nữ',
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(
//                             Icons.location_on_rounded,
//                             color: Colors.grey[800],
//                           ),
//                           hintText: 'Nhập địa chỉ',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         controller: _addressController,
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       TextField(
//                         decoration: InputDecoration(
//                           hintText: 'Giới thiệu',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         maxLines: 5,
//                         controller: _gioithieuController,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: PreferredSize(
//           preferredSize: const Size.fromHeight(200),
//           child: BottomAppBar(
//             child: Padding(
//               padding: const EdgeInsets.only(right: 5),
//               child: SizedBox(
//                 width: 180,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     await _handleUpdateUser();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     'Cập nhật thông tin',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 22),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }