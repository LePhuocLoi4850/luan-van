import 'package:flutter/material.dart';
import '../../../ui/screens.dart';

class HomeCScreen extends StatelessWidget {
  const HomeCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 900,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/companybackground.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 60, left: 40, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Xin chào nhà tuyển dụng',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.person_2_rounded,
                                size: 40,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 240,
                            height: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    '${companyProvider.companyData?.name}',
                                    style: TextStyle(fontSize: 22),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 18,
                          ),
                        ],
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10),
                            child: Text(
                              'Danh mục của bạn ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          //Danh mục
                          Category(),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10),
                            child: Text(
                              'Dịch vụ của bạn',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          //Dịch vụ
                          Service(),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10),
                            child: Text(
                              'Dành cho bạn',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          //Dành cho bạn
                          ForYou(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                child: Container(
                  width: 400,
                  height: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 180,
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Tổng số tin đã đăng',
                                      style: TextStyle(fontSize: 15),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '0',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text('Tuần này'), Text('0 tin')],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text('Tháng này'), Text('0 tin')],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Ứng viên đã ứng tuyển',
                                      style: TextStyle(fontSize: 15),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                                  Text(
                                    '0',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tuần này'),
                                  Text(
                                    '0 ứng viên',
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tháng này'),
                                  Text('0 ứng viên')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
