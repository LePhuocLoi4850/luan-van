import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'test_user.dart';
import 'ui/screens.dart';

class MyCV extends StatefulWidget {
  const MyCV(this.userData, {super.key});
  final Map<String, dynamic> userData;

  @override
  State<MyCV> createState() => _MyCVState();
}

class _MyCVState extends State<MyCV> {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isLoading1 = ValueNotifier<bool>(true);

  String? buttonText1;
  String? buttonText2;
  void initState() {
    super.initState();
    setState(() {
      if (widget.userData['status'] == 'applied') {
        buttonText1 = 'Duyệt';
        buttonText2 = 'Từ chối';
        isLoading.value = false;
        isLoading1.value = false;
      } else if (widget.userData['status'] == 'withdrawn') {
        buttonText1 = 'Liên Hệ';
        buttonText2 = 'Đã hủy';
        isLoading.value = false;
        isLoading1.value = false;
      } else if (widget.userData['status'] == 'received') {
        buttonText1 = 'Đã nhận';
        buttonText2 = 'Đăt lịch';
        isLoading.value = false;
        isLoading1.value = false;
      } else if (widget.userData['status'] == 'refused') {
        buttonText1 = 'Liên hệ';
        buttonText2 = 'Đã từ chối';
        isLoading.value = false;
        isLoading1.value = false;
      }
      ;
    });
  }

  Future<void> received() async {
    setState(() {
      isLoading.value = true;
    });
    final companyProvider =
        Provider.of<CompanyProvider>(context, listen: false);
    String? emailc = companyProvider.email;
    try {
      String status = 'received';
      String? reason = 'Đã nhận';
      String? jobId = widget.userData['jobId'].toString();

      await DatabaseConnection()
          .updateJobSpace(widget.userData['email'], jobId, status, reason);
      await DatabaseConnection().addApplicationHistory(
          widget.userData['email'], emailc!, jobId, status, reason);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã duyệt')),
      );
      buttonText1 = 'Đã duyệt';
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => CompanyScreen()));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => JobApplicationPage()));
    } catch (error) {
      //
    } finally {
      setState(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> refused() async {
    setState(() {
      isLoading1.value = true;
    });
    final companyProvider =
        Provider.of<CompanyProvider>(context, listen: false);
    String? emailc = companyProvider.email;
    try {
      String status = 'refused';
      String? reason = 'Từ chối';
      String? jobId = widget.userData['jobId'].toString();

      await DatabaseConnection()
          .updateJobSpace(widget.userData['email'], jobId, status, reason);
      await DatabaseConnection().addApplicationHistory(
          widget.userData['email'], emailc!, jobId, status, reason);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã từ chối')),
      );
      buttonText1 = 'Đã từ chối';
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => JobApplicationPage()));
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => CompanyScreen()));
    } catch (error) {
      //
    } finally {
      setState(() {
        isLoading1.value = false;
      });
    }
  }

  String calculateAge(String birthDateString) {
    final birthDate =
        DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parse(birthDateString);
    final now = DateTime.now();
    final difference = now.difference(birthDate);

    return (difference.inDays / 365).floor().toString();
  }

  @override
  Widget build(BuildContext context) {
    String age = calculateAge(widget.userData['birthday'].toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('My CV'),
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 0.0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 80,
                                    color: Colors.blue[600],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.userData['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tuổi: $age',
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.black),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          'Giới tính: ${widget.userData['gender']}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  height: 1,
                  width: 360,
                  color: const Color.fromARGB(255, 143, 143, 143),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'THÔNG TIN LIÊN HỆ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Flexible(
                            child: Text(
                              'Địa chỉ: ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              widget.userData['address'],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Text(
                            'Điện thoại: ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              widget.userData['phone'],
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Text(
                            'Email: ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              widget.userData['email'],
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.all(8),
                  height: 1,
                  width: 360,
                  color: const Color.fromARGB(255, 143, 143, 143),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NGHÀNH NGHỀ QUAN TÂM',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              widget.userData['career'],
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.all(8),
                      height: 1,
                      width: 360,
                      color: const Color.fromARGB(255, 143, 143, 143),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HỌC VẤN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            widget.userData['description'],
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 158, 155, 145)),
                            maxLines: 20,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      height: 1,
                      width: 360,
                      color: const Color.fromARGB(255, 143, 143, 143),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CÔNG VIỆC ỨNG TUYỂN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  widget.userData['nameJob'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 41, 119, 238)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(
                                        255, 176, 213, 240)),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => JobDetailScreen(
                                              widget.userData['jobId']),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Chi tiết',
                                      style: TextStyle(fontSize: 20),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      height: 1,
                      width: 360,
                      color: const Color.fromARGB(255, 143, 143, 143),
                    ),
                    const SizedBox(height: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LỊCH SỬ ỨNG TUYỂN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text(
                                  'Lịch sử',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 150,
              height: 50,
              child: ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (context, isLoading, child) {
                  return SizedBox(
                    width: 180,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!isLoading && buttonText1 == 'Duyệt') {
                          print('duyệt');
                          received();
                        } else {
                          buttonText1 = 'Đã duyệt';
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              buttonText1!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: ValueListenableBuilder<bool>(
                valueListenable: isLoading1,
                builder: (context, isLoading1, child) {
                  return SizedBox(
                    width: 180,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!isLoading1 && buttonText2 == 'Từ chối') {
                          refused();
                        } else {
                          buttonText2 = 'Đã từ chối';
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading1
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              buttonText2!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
