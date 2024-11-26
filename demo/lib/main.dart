import 'package:demo/provider.dart';
import 'package:demo/screen.dart';
import 'package:demo/web.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'controller.dart';
// import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  runApp(const MyApp());
}

final routes = [
  GetPage(name: '/vnpay', page: () => const Web()),
];

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthController _authController = Get.find();

  @override
  void initState() {
    super.initState();
    _authController.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => MyBase64())],
      child: GetMaterialApp(
        getPages: routes,
        home: Obx(() => _authController.isLoggedIn.value
            ? CompanyScreen()
            : CompanyScreen()),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
