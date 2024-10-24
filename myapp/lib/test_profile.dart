import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ui/screens.dart';

class Profile1 extends StatefulWidget {
  const Profile1({super.key});

  @override
  State<Profile1> createState() => _Profile1State();
}

class _Profile1State extends State<Profile1> {
  List<bool> _isEditing = [];
  DateTime? _selectedDate;
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _genderController = TextEditingController();
  late String? _nameValue;
  late String? _phoneValue;
  late String? _emailValue;
  late String? _descriptionValue;
  late String? _addressValue;
  @override
  void initState() {
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _isEditing = List.generate(7, (index) => false);
//
    _nameController.text = userProvider.userData!.name;
    _birthdayController.text = (userProvider.userData!.birthday);
    _phoneController.text = userProvider.userData!.phone;
    _emailController.text = userProvider.userData!.email;
    _addressController.text = userProvider.userData!.address;
    _descriptionController.text = userProvider.userData!.description;
    _genderController.text = userProvider.userData!.gender;

    //
    _nameValue = userProvider.userData?.name ?? '';
    _phoneValue = userProvider.userData?.phone ?? '';
    _descriptionValue = userProvider.userData?.description ?? '';
    _addressValue = userProvider.userData?.address ?? '';
    _emailValue = userProvider.userData?.email ?? '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        String formattedBirthday = DateFormat('yyyy-MM-dd').format(pickedDate);

        _birthdayController.text = formattedBirthday;
        userProvider.updateUserData(userProvider.userData!
            .copyWith(birthday: _birthdayController.text));
      });
    }
  }

  String? formatDate(DateTime? date) {
    if (date == null) {
      return null;
    }
    // Define your desired format
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  void _showMale(BuildContext ctx) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showModalBottomSheet(
      elevation: 10,
      context: ctx,
      builder: (ctx) => SizedBox(
        width: 410,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              decoration: const BoxDecoration(color: Colors.grey),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tùy chọn',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _genderController.text = 'Nam';
                      userProvider.updateUserData(userProvider.userData!
                          .copyWith(gender: _genderController.text));
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Nam',
                    style: TextStyle(fontSize: 24),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _genderController.text = 'Nữ';
                      userProvider.updateUserData(userProvider.userData!
                          .copyWith(gender: _genderController.text));
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Nữ',
                    style: TextStyle(fontSize: 24),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _genderController.text = 'Khác';
                      userProvider.updateUserData(userProvider.userData!
                          .copyWith(gender: _genderController.text));
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Khác',
                    style: TextStyle(fontSize: 24),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin tài khoản',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 70,
                              height: 70,
                              child: Icon(
                                Icons.account_circle,
                                size: 70,
                                color: Colors.blue[600],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _isEditing[0]
                                    ? SizedBox(
                                        width: 250,
                                        child: TextFormField(
                                          controller: _nameController,
                                          onChanged: (value) {
                                            setState(() {
                                              _nameValue = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 10.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        _nameValue!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                Text(
                                  userProvider.role == 'user'
                                      ? 'Tài khoản ứng viên'
                                      : 'Tài khoản nhà tuyển dụng',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_isEditing[0]) {
                              userProvider.updateUserData(userProvider.userData!
                                  .copyWith(name: _nameController.text));
                            }
                            _isEditing[0] = !_isEditing[0];
                          });
                        },
                        child: FaIcon(
                          _isEditing[0]
                              ? FontAwesomeIcons.check
                              : FontAwesomeIcons.penToSquare,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  const Line(),
                  const Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15),
                    child: Text(
                      'Thông tin cá nhân',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Line1(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Giới tính',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            _genderController.text,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _showMale(context),
                        child: const FaIcon(
                          FontAwesomeIcons.penToSquare,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Line(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ngày sinh',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            _birthdayController.text,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: const FaIcon(
                          FontAwesomeIcons.penToSquare,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Line(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Đ/c email',
                            style: TextStyle(fontSize: 20),
                          ),
                          _isEditing[3]
                              ? SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _emailValue = value;
                                      });
                                    },
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  _emailValue!,
                                ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_isEditing[3]) {
                              userProvider.updateUserData(userProvider.userData!
                                  .copyWith(email: _emailController.text));
                            }
                            _isEditing[3] = !_isEditing[3];
                          });
                        },
                        child: FaIcon(
                          _isEditing[3]
                              ? FontAwesomeIcons.check
                              : FontAwesomeIcons.penToSquare,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  const Line(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Số điện thoại',
                            style: TextStyle(fontSize: 20),
                          ),
                          _isEditing[2]
                              ? SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _phoneValue = value;
                                      });
                                    },
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  _phoneValue!,
                                ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_isEditing[2]) {
                              userProvider.updateUserData(userProvider.userData!
                                  .copyWith(phone: _phoneController.text));
                            }
                            _isEditing[2] = !_isEditing[2];
                          });
                        },
                        child: FaIcon(
                          _isEditing[2]
                              ? FontAwesomeIcons.check
                              : FontAwesomeIcons.penToSquare,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  const Line(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Địa chỉ',
                            style: TextStyle(fontSize: 20),
                          ),
                          _isEditing[4]
                              ? SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    controller: _addressController,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _addressValue = value;
                                      });
                                    },
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  _addressValue!,
                                ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_isEditing[4]) {
                              userProvider.updateUserData(userProvider.userData!
                                  .copyWith(address: _addressController.text));
                            }
                            _isEditing[4] = !_isEditing[4];
                          });
                        },
                        child: FaIcon(
                          _isEditing[4]
                              ? FontAwesomeIcons.check
                              : FontAwesomeIcons.penToSquare,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  const Line(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mô Tả',
                            style: TextStyle(fontSize: 20),
                          ),
                          _isEditing[5]
                              ? SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    controller: _descriptionController,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _descriptionValue = value;
                                      });
                                    },
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  _descriptionValue!,
                                ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_isEditing[5]) {
                              userProvider.updateUserData(userProvider.userData!
                                  .copyWith(
                                      description:
                                          _descriptionController.text));
                            }
                            _isEditing[5] = !_isEditing[5];
                          });
                        },
                        child: FaIcon(
                          _isEditing[5]
                              ? FontAwesomeIcons.check
                              : FontAwesomeIcons.penToSquare,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Line extends StatelessWidget {
  const Line({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 10),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[400],
      ),
    );
  }
}

class Line1 extends StatelessWidget {
  const Line1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, bottom: 10),
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.grey),
      ),
    );
  }
}
