import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/provider/user_provider.dart';
import 'package:jobapp/ui/admin/admin_job/admin_job.dart';
import 'package:jobapp/ui/auth/login_screen.dart';
import 'package:jobapp/ui/auth/register_screen.dart';
import 'package:jobapp/ui/nhatuyendung/list_job.dart';
import 'package:jobapp/ui/nhatuyendung/management/calender_screen.dart';
import 'package:jobapp/ui/nhatuyendung/management/management_uv.dart';
import 'package:jobapp/ui/nhatuyendung/post_job_screen.dart';
import 'package:jobapp/ui/ungvien/cv_uv/cv_update/update_cv.dart';
import 'package:jobapp/ui/ungvien/cv_uv/cv_update/update/update_description.dart';
import 'package:jobapp/ui/ungvien/cv_uv/cv_update/update/update_information.dart';
import 'package:jobapp/ui/ungvien/cv_uv/upload_cv/upload_cv.dart';
import 'package:jobapp/ui/ungvien/home_uv/apply.dart';
import 'package:jobapp/ui/ungvien/home_uv/job_detail_screen.dart';
import 'package:jobapp/ui/ungvien/home_uv/notification.dart';
import 'package:jobapp/ui/ungvien/mycv/job_pending.dart';
import 'package:jobapp/ui/ungvien/search_uv/search_job/filter_search.dart';
import 'package:jobapp/ui/ungvien/search_uv/search_job/search_screen.dart';
import 'package:provider/provider.dart';
import 'provider/provider.dart';
import 'server/database_connection.dart';
import 'share/splash_screen.dart';
import 'ui/admin/admin_pay/admin_pay.dart';
import 'ui/admin/admin_pay/pay_detail_screen_admin.dart';
import 'ui/admin/admin_service/add_service.dart';
import 'ui/admin/admin_company/admin_company.dart';
import 'ui/admin/admin_home.dart';
import 'ui/admin/admin_service/admin_service.dart';
import 'ui/admin/admin_user/admin_user.dart';
import 'ui/admin/admin_company/company_detail_admin.dart';
import 'ui/admin/admin_service/edit_service.dart';
import 'ui/admin/admin_job/job_detail_screen_admin.dart';
import 'ui/admin/admin_service/service_detail.dart';
import 'ui/admin/admin_user/user_detail_admin.dart';
import 'ui/admin/chart.dart';
import 'ui/admin/uv_detail_admin.dart';
import 'ui/auth/auth_controller.dart';
import 'ui/auth/choose_role.dart';
import 'ui/auth/update_profile_company.dart';
import 'ui/auth/update_profile_user.dart';
import 'ui/nhatuyendung/company_detail_screen.dart';
import 'ui/nhatuyendung/company_gird_title.dart';
import 'ui/nhatuyendung/edit_job.dart';
import 'ui/nhatuyendung/home_company.dart';
import 'ui/nhatuyendung/management/calender_detail.dart';
import 'ui/nhatuyendung/management/uv_detail.dart';
import 'ui/nhatuyendung/profile_ntd/profile_screen.dart';
import 'ui/nhatuyendung/profile_ntd/profile_update.dart';
import 'ui/nhatuyendung/screen_company.dart';

import 'ui/payment/history.dart';
import 'ui/payment/momo.dart';
import 'ui/payment/view_momo.dart';
import 'ui/ungvien/home_uv/cv_profile_screen.dart';
import 'ui/ungvien/home_uv/job_of_company.dart';
import 'ui/nhatuyendung/search/search_uv.dart';
import 'ui/nhatuyendung/search/user_detail_screen.dart';
import 'ui/nhatuyendung/search/user_gird.dart';
import 'ui/ungvien/cv_uv/cv_update/insert/insert_certificate.dart';
import 'ui/ungvien/cv_uv/cv_update/insert/insert_education.dart';
import 'ui/ungvien/cv_uv/cv_update/insert/insert_experience.dart';
import 'ui/ungvien/cv_uv/cv_update/insert/insert_skill.dart';
import 'ui/ungvien/cv_uv/cv_update/update/update_certificate.dart';
import 'ui/ungvien/cv_uv/cv_update/update/update_education.dart';
import 'ui/ungvien/cv_uv/cv_update/update/update_experience.dart';
import 'ui/ungvien/cv_uv/cv_update/update/update_name.dart';
import 'ui/ungvien/cv_uv/cv_update/update/update_skill.dart';
import 'ui/ungvien/home_uv/home_uv_screen.dart';
import 'ui/ungvien/mycv/favorites_screen.dart';
import 'ui/ungvien/mycv/job_approved.dart';
import 'ui/ungvien/mycv/job_rejected.dart';
import 'ui/ungvien/screen_uv.dart';
import 'ui/ungvien/search_uv/search_company/search_company_screen.dart';
import 'ui/ungvien/search_uv/search_job/search_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseConnection().initialize();
  AuthController controller = Get.put(AuthController());
  await controller.loadSaveLoginStatus();
  runApp(const MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isLoading;
  AuthController controller = Get.put(AuthController());
  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  final routes = [
    GetPage(name: '/login', page: () => const LoginScreen()),
    GetPage(name: '/homeScreen', page: () => const UserScreen()),
    GetPage(name: '/homeUV', page: () => const HomeUV()),
    GetPage(name: '/companyScreen', page: () => const CompanyScreen()),
    GetPage(name: '/homeNTD', page: () => const HomeNTD()),
    GetPage(name: '/chooseRole', page: () => const ChooseRole()),
    GetPage(name: '/updateUser', page: () => const UpdateProfileUser()),
    GetPage(name: '/updateCompany', page: () => const UpdateProfileCompany()),
    GetPage(name: '/postJob', page: () => const PostJobScreen()),
    GetPage(name: '/listJob', page: () => const ListJob()),
    GetPage(name: '/editJob', page: () => const EditJob()),
    GetPage(name: '/jobDetailScreen', page: () => const JobDetailScreen()),
    GetPage(name: '/jobOfCompany', page: () => const JobOfCompany()),
    GetPage(name: '/companyGirdTitle', page: () => const CompanyGirdTitle()),
    GetPage(
        name: '/companyDetailScreen', page: () => const CompanyDetailScreen()),
    GetPage(name: '/uploadCV', page: () => const UploadCv()),
    GetPage(name: '/updateCV', page: () => const UpdateCv()),
    GetPage(name: '/updateInformation', page: () => const UpdateInformation()),
    GetPage(name: '/searchScreen', page: () => const SearchScreen()),
    GetPage(name: '/searchDetail', page: () => const SearchDetail()),
    GetPage(name: '/filterSearch', page: () => const FilterSearch()),
    GetPage(name: '/jobPending', page: () => const JobPending()),
    GetPage(name: '/jobApproved', page: () => const JobApproved()),
    GetPage(name: '/jobRejected', page: () => const JobRejected()),
    GetPage(name: '/managementUV', page: () => const ManagementUv()),
    GetPage(name: '/uvDetail', page: () => const UvDetail()),
    GetPage(name: '/uvDetailScreen', page: () => const UserDetailScreen()),
    GetPage(name: '/searchUvScreen', page: () => const SearchUvScreen()),
    GetPage(
        name: '/searchCompanyScreen', page: () => const SearchCompanyScreen()),
    GetPage(name: '/userGird', page: () => const UserGird()),
    GetPage(name: '/profileUpdate', page: () => const ProfileUpdate()),
    GetPage(name: '/profileScreen', page: () => const ProfileScreen()),
    GetPage(name: '/updateDescription', page: () => const UpdateDescription()),
    GetPage(name: '/updateName', page: () => const UpdateName()),
    GetPage(name: '/updateEducation', page: () => const UpdateEducation()),
    GetPage(name: '/updateCertificate', page: () => const UpdateCertificate()),
    GetPage(name: '/updateExperience', page: () => const UpdateExperience()),
    GetPage(name: '/updateSkill', page: () => const UpdateSkill()),
    GetPage(name: '/insertEducation', page: () => const InsertEducation()),
    GetPage(name: '/insertExperience', page: () => const InsertExperience()),
    GetPage(name: '/insertCertificate', page: () => const InsertCertificate()),
    GetPage(name: '/insertSkill', page: () => const InsertSkill()),
    GetPage(name: '/apply', page: () => const Apply()),
    GetPage(name: '/notificationApply', page: () => const NotificationApply()),
    GetPage(name: '/cvProfileScreen', page: () => const CvProfileScreen()),
    GetPage(name: '/favoritesScreen', page: () => const FavoritesScreen()),
    GetPage(name: '/adminHome', page: () => const AdminHome()),
    GetPage(name: '/adminService', page: () => const AdminService()),
    GetPage(name: '/editService', page: () => const EditService()),
    GetPage(name: '/addService', page: () => const AddService()),
    GetPage(name: '/calenderScreen', page: () => const CalenderScreen()),
    GetPage(name: '/calenderDetail', page: () => const CalenderDetail()),
    GetPage(name: '/web', page: () => const Web()),
    GetPage(name: '/momo', page: () => const Momo()),
    GetPage(name: '/history', page: () => const History()),
    GetPage(name: '/adminJob', page: () => const AdminJob()),
    GetPage(name: '/adminUser', page: () => const AdminUser()),
    GetPage(name: '/adminCompany', page: () => const AdminCompany()),
    GetPage(name: '/serviceDetail', page: () => const ServiceDetail()),
    GetPage(name: '/uvDetailAdmin', page: () => const UvDetailAdmin()),
    GetPage(name: '/userDetailAdmin', page: () => const UserDetailAdmin()),
    GetPage(name: '/jobChart', page: () => const RevenueChart()),
    GetPage(name: '/adminPay', page: () => const AdminPay()),
    GetPage(
        name: '/companyDetailAdmin', page: () => const CompanyDetailAdmin()),
    GetPage(name: '/jobDetailAdmin', page: () => const JobDetailAdmin()),
    GetPage(
        name: '/payDetailScreenAdmin',
        page: () => const PayDetailScreenAdmin()),
    GetPage(
        transition: Transition.rightToLeftWithFade,
        curve: Curves.easeInOutCubicEmphasized,
        transitionDuration: const Duration(milliseconds: 1000),
        name: '/register',
        page: () => const RegisterScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginState()),
        ChangeNotifierProvider(create: (_) => RegisterState()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (context) => MyBase64())
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        getPages: routes,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(color: Colors.white),
        ),
        home: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _isLoading
              ? const SplashScreen()
              : Obx(() {
                  if (controller.isLoggedIn.value) {
                    switch (controller.role) {
                      case 'company':
                        return const CompanyScreen();
                      case 'user':
                        return const UserScreen();
                      case 'admin':
                        return const AdminHome();
                      default:
                        return const ChooseRole();
                    }
                  } else {
                    return const LoginScreen();
                  }
                }),
          // ChooseRole(),
          // UpdateProfileUser(),
        ),
      ),
    );
  }
}
