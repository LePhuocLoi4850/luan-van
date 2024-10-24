import 'package:flutter/material.dart';
import 'package:myapp/test_profile.dart';
import '../../../ui/screens.dart';

class ProfileCScreen extends StatefulWidget {
  const ProfileCScreen({super.key});

  @override
  State<ProfileCScreen> createState() => _ProfileCScreenState();
}

class _ProfileCScreenState extends State<ProfileCScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${companyProvider.companyData?.name}'),
      ),
      body: Container(
        color: Color.fromARGB(255, 234, 234, 234),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: 400,
                height: 209,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: const Color.fromARGB(255, 230, 230, 230))),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile1()));
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FaIcon(
                                FontAwesomeIcons.solidUser,
                                color: Colors.blue[700],
                              ),
                            ),
                            const Text(
                              'Thông tin tài khoản',
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FaIcon(
                                FontAwesomeIcons.mobileScreenButton,
                                color: Colors.blue[700],
                              ),
                            ),
                            const Text(
                              'Thêm số điện thoại',
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FaIcon(
                                FontAwesomeIcons.universalAccess,
                                color: Colors.blue[700],
                              ),
                            ),
                            const Text(
                              'Xác thực tài khoản',
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: 400,
                height: 209,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: const Color.fromARGB(255, 230, 230, 230))),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FaIcon(
                                FontAwesomeIcons.fileInvoice,
                                color: Colors.blue[700],
                              ),
                            ),
                            const Text(
                              'Điều khoản dịch vụ',
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FaIcon(
                                FontAwesomeIcons.fileShield,
                                color: Colors.blue[700],
                              ),
                            ),
                            const Text(
                              'Chính sách bảo mật',
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FaIcon(
                                FontAwesomeIcons.book,
                                color: Colors.blue[700],
                              ),
                            ),
                            const Text(
                              'HƯớng dẫn sử dụng',
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: 400,
                height: 160,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: const Color.fromARGB(255, 230, 230, 230))),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FaIcon(
                                FontAwesomeIcons.circleMinus,
                                color: Colors.red[700],
                              ),
                            ),
                            const Text(
                              'Xóa tài khoản',
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        onTap: () {
                          companyProvider.clearCompany();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthScreen()),
                          );
                        },
                        leading: const FaIcon(
                          FontAwesomeIcons.rightFromBracket,
                          color: Colors.red,
                        ),
                        title: Text(
                          'Đăng xuất',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
