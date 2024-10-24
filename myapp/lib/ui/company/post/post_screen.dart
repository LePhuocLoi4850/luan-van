import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../ui/company/homec/list_job.dart';
import '../../../ui/screens.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _titleController = TextEditingController();
  final _luongController = TextEditingController();
  final _loaiController = TextEditingController();
  final _soluongController = TextEditingController();
  final _diachiController = TextEditingController();
  final _lichController = TextEditingController();
  final _gioitinhController = TextEditingController();
  final _tuoiController = TextEditingController();
  final _hocvanController = TextEditingController();
  final _nganhngheController = TextEditingController();
  final _kinhnghiemController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _yeucaukhacController = TextEditingController();
  final _phucloiController = TextEditingController();

  final _editForm = GlobalKey<FormState>();

  CareerManager careerManager = CareerManager();
  Career? selectedCareer;

  Future<void> _handlePost() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();
    final companyProvider =
        Provider.of<CompanyProvider>(context, listen: false);
    String? email = companyProvider.companyData?.email;
    final name = _titleController.text;
    final salary = _luongController.text;
    final category = _loaiController.text;
    final quantity = _soluongController.text;
    final address = _diachiController.text;
    final schedule = _lichController.text;
    final gender = _gioitinhController.text;
    final age = _tuoiController.text;
    final education = _hocvanController.text;
    final career = _nganhngheController.text;
    final experience = _kinhnghiemController.text;
    final description = _descriptionController.text;
    final otherRequirements = _yeucaukhacController.text;
    final benefits = _phucloiController.text;

    try {
      print('start post');
      if (_nganhngheController.text == '') {
        setState(() {
          _clearControllers();
        });
        print('post thất bại');
      }
      print("name: $name");
      print("salary: $salary");
      print("category: $category");
      print("quantity: $quantity");
      print("address: $address");
      print("schedule: $schedule");
      print("gender: $gender");
      print("age: $age");
      print("education: $education");
      print("career: $career");
      print("experience: $experience");
      print("description: $description");
      print("otherRequirements: $otherRequirements");
      print("benefits: $benefits");
      await DatabaseConnection().postJob(
          email!,
          name,
          salary,
          category,
          address,
          quantity,
          schedule,
          gender,
          age,
          education,
          experience,
          career,
          description,
          otherRequirements,
          benefits);
      print('post thành công');
      setState(() {
        _clearControllers();
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ListJob(),
        ),
      );
    } catch (e) {
      return;
    }
  }

  void _clearControllers() {
    _nganhngheController.clear();
    _titleController.clear();
    _luongController.clear();
    _loaiController.clear();
    _soluongController.clear();
    _diachiController.clear();
    _lichController.clear();
    _gioitinhController.clear();
    _tuoiController.clear();
    _hocvanController.clear();
    _kinhnghiemController.clear();
    _descriptionController.clear();
    _yeucaukhacController.clear();
    _phucloiController.clear();
  }

  void _fillFormWithTestData() {
    // Thay đổi các giá trị của các controller thành các giá trị mẫu
    _titleController.text = 'Job Title';
    _luongController.text = '1000000';
    _loaiController.text = 'Toàn thời gian';
    _soluongController.text = '5';
    _diachiController.text = '123 ABC Street, XYZ City';
    _lichController.text = 'Monday - Friday, 9 AM - 5 PM';
    _gioitinhController.text = 'Nam';
    _tuoiController.text = '25-40';
    _hocvanController.text = 'Bachelor\'s Degree';
    _kinhnghiemController.text = '2 years';

    _descriptionController.text =
        'This is a job description that describes the responsibilities and requirements for the job.';
    _yeucaukhacController.text = 'Good communication skills';
    _phucloiController.text = 'Health insurance, paid leave';
  }

  void _showCareerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Chọn ngành nghề đăng tuyển',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 900,
                  child: ListView.builder(
                    itemCount: careerManager.allCareer.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: ListTile(
                          title: Text(
                            careerManager.allCareer[index].name,
                          ),
                          onTap: () {
                            setState(() {
                              selectedCareer = careerManager.allCareer[index];

                              _nganhngheController.text =
                                  careerManager.allCareer[index].name;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Đăng tin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _editForm,
          child: ListView(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: RichText(
                      text: const TextSpan(
                          text: 'Tiêu đề tin tuyển dụng',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          children: <TextSpan>[
                        TextSpan(
                            text: '(*)', style: TextStyle(color: Colors.red))
                      ]))),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: buildTitleField(),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: const TextSpan(
                    text: 'Ngành nghề đăng tuyển',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '(*)', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: buildCareerField(),
              ),
              // Loại hình công việc
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: const TextSpan(
                    text: 'Loại hình công việc',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '(*)', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: buildLoaiField(),
              ),
              // Số lượng cần tuyển
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: const TextSpan(
                    text: 'Số lượng cần tuyển',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '(*)', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: buildSoLuongField(),
              ),
              // Mức lương
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: const TextSpan(
                    text: 'Mức lương',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '(*)', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: buildLuongField(),
              ),
              // Địa chỉ nơi làm việc
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: const TextSpan(
                    text: 'Địa chỉ nơi làm việc',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '(*)', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: buildDiaChiField(),
              ),
              // Lịch làm việc
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: const TextSpan(
                    text: 'Lịch làm việc',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '(*)', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: buildLichField(),
              ),
              // Giới tính
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: const TextSpan(
                    text: 'Giới tính yêu cầu',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '(*)', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Nam',
                          groupValue: _gioitinhController.text,
                          onChanged: (value) {
                            setState(() {
                              _gioitinhController.text = value!;
                            });
                          },
                        ),
                        const Text(
                          'Nam',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Nữ',
                          groupValue: _gioitinhController.text,
                          onChanged: (value) {
                            setState(() {
                              _gioitinhController.text = value!;
                            });
                          },
                        ),
                        const Text(
                          'Nữ',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Không yêu cầu',
                          groupValue: _gioitinhController.text,
                          onChanged: (value) {
                            setState(() {
                              _gioitinhController.text = value!;
                            });
                          },
                        ),
                        const Text(
                          'Không yêu cầu',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Độ tuổi
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: const TextSpan(
                    text: 'Độ tuổi yêu cầu',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '(*)', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: buildTuoiField(),
              ),
              // Học vấn
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: const TextSpan(
                    text: 'Trình độ học vấn yêu cầu',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: buildHocVanField(),
              ),
              // Kinh nghiệm
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: const TextSpan(
                    text: 'Kinh nghiệm làm việc yêu cầu',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: buildKinhNghiemField(),
              ),
              // Mô tả công việc
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: const TextSpan(
                    text: 'Mô tả chi tiết công việc',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '(*)', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: buildDescriptionField(),
              ),
              // Yêu cầu khác
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Các yêu cầu khác',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: buildYeuCauKhacField(),
              ),
              // Phúc lợi
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Phúc lợi và quyền lợi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: buildPhucLoiField(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: _handlePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '    Đăng Tin    ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _fillFormWithTestData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Điền Dữ Liệu Mẫu',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        hintText: 'Nhập tiêu đề',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty && value.length <= 10) {
          return 'Tên công việc phải hơn 10 kí tự';
        }
        return null;
      },
    );
  }

  GestureDetector buildCareerField() {
    return GestureDetector(
      onTap: () {
        _showCareerBottomSheet(context);
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _nganhngheController.text.isNotEmpty
                  ? _nganhngheController.text
                  : 'Loại Hình Công Việc',
              style: TextStyle(
                color: _nganhngheController.text.isNotEmpty
                    ? const Color.fromARGB(255, 0, 0, 0)
                    : Colors.grey,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  DropdownButtonFormField<String> buildLoaiField() {
    return DropdownButtonFormField<String>(
      value: _loaiController.text.isNotEmpty
          ? _loaiController.text
          : null, // Set to null initially if the controller is empty
      items: const [
        DropdownMenuItem(
            value: 'Toàn thời gian', child: Text('Toàn thời gian')),
        DropdownMenuItem(value: 'Bán thời gian', child: Text('Bán thời gian')),
        DropdownMenuItem(value: 'Thực tập', child: Text('Thực tập')),
      ],
      onChanged: (value) {
        setState(() {
          _loaiController.text =
              value!; // Update the controller only when a new value is selected
        });
      },
      decoration: InputDecoration(
        hintText: 'Loại hình công việc',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn loại hình công việc.';
        }
        return null;
      },
    );
  }

  TextFormField buildSoLuongField() {
    return TextFormField(
      controller: _soluongController,
      decoration: InputDecoration(
        hintText: 'Số Lượng',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.phone,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
    );
  }

  TextFormField buildLuongField() {
    return TextFormField(
      controller: _luongController,
      decoration: InputDecoration(
        hintText: 'Luong',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a Luong.';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        if (double.parse(value) <= 0) {
          return 'Please enter a number greater than zero.';
        }
        return null;
      },
    );
  }

  TextFormField buildDiaChiField() {
    return TextFormField(
      controller: _diachiController,
      decoration: InputDecoration(
        hintText: 'Địa chỉ làm việc',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
    );
  }

  TextFormField buildLichField() {
    return TextFormField(
      controller: _lichController,
      decoration: InputDecoration(
        hintText: 'Lịch làm việc',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
    );
  }

  TextFormField buildGioiTinhField() {
    return TextFormField(
      controller: _gioitinhController,
      decoration: InputDecoration(
        hintText: 'Giới tính',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
    );
  }

  TextFormField buildTuoiField() {
    return TextFormField(
      controller: _tuoiController,
      decoration: InputDecoration(
        hintText: 'Độ tuổi',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
    );
  }

  TextFormField buildHocVanField() {
    return TextFormField(
      controller: _hocvanController,
      decoration: InputDecoration(
        hintText: 'Học vấn',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
    );
  }

  TextFormField buildKinhNghiemField() {
    return TextFormField(
      controller: _kinhnghiemController,
      decoration: InputDecoration(
        hintText: 'Khinh nghiệm',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
    );
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        hintText: 'description',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description.';
        }
        if (value.length < 10) {
          return 'Should be at least 10 characters long';
        }
        return null;
      },
    );
  }

  TextFormField buildYeuCauKhacField() {
    return TextFormField(
      controller: _yeucaukhacController,
      decoration: InputDecoration(
        hintText: 'Yêu cầu khác',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
    );
  }

  TextFormField buildPhucLoiField() {
    return TextFormField(
      controller: _phucloiController,
      decoration: InputDecoration(
        hintText: 'Phúc lợi',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
    );
  }
}
