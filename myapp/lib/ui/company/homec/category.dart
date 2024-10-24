import 'package:flutter/material.dart';
import 'package:myapp/ui/screens.dart';
import 'package:postgres/postgres.dart';
import '../../../test_user.dart';
import 'list_job.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  Future<List<List<dynamic>>> _selectUser(String emailc, String status) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
 SELECT emailu, jobId, name, address, salary FROM apply where emailc = @emailc AND status = @status
'''), parameters: {
        'emailc': emailc,
        'status': status,
      });
      List<List<dynamic>> userList = [];
      for (final row in result!) {
        userList.add([
          row[0],
          row[1],
          row[2],
          row[3],
          row[4],
        ]);
      }
      return userList;
    } catch (e) {
      print('error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Container(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 255, 235, 222),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.solidPaperPlane,
                            size: 30,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Đăng tin tuyển dụng',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Container(
              width: 80,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ListJob()),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 212, 255, 212),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.clipboardList,
                            size: 30,
                            color: Color.fromARGB(255, 66, 194, 70),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Quản lý tin đăng',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 80,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JobApplicationPage()));
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 220, 238, 255),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.addressBook,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Quản lý ứng viên',
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
