import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../screens.dart';

class CompanyDetailScreen extends StatefulWidget {
  const CompanyDetailScreen(this.emailCompany, {super.key});
  final String emailCompany;
  @override
  State<CompanyDetailScreen> createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {
  late Future<List<dynamic>> _companyData;
  @override
  void initState() {
    super.initState();
    _companyData =
        DatabaseConnection().selectCompanyWithEmail(widget.emailCompany);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Giới thiệu công ty',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
          future: _companyData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Company not found'));
            } else {
              final companyDetail = snapshot.data![0];
              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 180.0),
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            )),
                        constraints: const BoxConstraints(minHeight: 700),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 40),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border:
                                              Border.all(color: Colors.grey)),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      companyDetail[3],
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child:
                                            Icon(Icons.phone_in_talk_rounded),
                                      ),
                                      Text(
                                        companyDetail[8],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Icon(Icons.email_rounded),
                                      ),
                                      Text(
                                        companyDetail[1],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Icon(Icons.fmd_good_sharp),
                                      ),
                                      Text(
                                        companyDetail[5],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(),
                                const Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'Quy mô',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          Alignment.centerLeft, // Căn trái
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          '1000 nhân viên',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'Giới thiệu',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          Alignment.centerLeft, // Căn trái
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          companyDetail[7],
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                ],
              );
            }
          }),
    );
  }
}
