import 'package:flutter/material.dart';
import 'package:expo_master/config/theme.dart';

// شاشات تسجيل الدخول والتسجيل واستعادة كلمة المرور
import 'package:expo_master/screens_login_and_registar/login_screen.dart';
import 'package:expo_master/screens_login_and_registar/register_screen.dart';
import 'package:expo_master/screens_login_and_registar/forgot_password_screen.dart';
import 'package:expo_master/screens_login_and_registar/reset_password_screen.dart';

// شاشات المسؤول (Admin)
import 'Features/create_department_screen.dart';
import 'Features/manage_departments_screen.dart';
import 'Features/sinup_screen_for_manger_section.dart';
import 'Features/welcome_screen.dart';

// شاشات العارض (Exhibitor)
import 'Exhibitor/ExhibitorRequestFormPage.dart';
import 'Exhibitor/RentPaymentPage.dart';
import 'Exhibitor/RequestStatusPage.dart';

// شاشات مدير القسم (Section Manager)
import 'manager/screen/RequestDetailsPage.dart';
import 'manager/screen/section_manager_home.dart';
import 'manager/screen/wing_list_page.dart';
import 'manager/screen/requests_list_page.dart';
import 'manager/screen/add_wing_page.dart';
import 'manager/screen/edit_wing_page.dart';

void main() {
  runApp(const ExpoMasterApp());
}

class ExpoMasterApp extends StatelessWidget {
  const ExpoMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expo Master',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      initialRoute: '/login',
      routes: {
        // 🔐 المصادقة
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignUpScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),

        // 👨‍💼 المسؤول
        '/admin/welcome': (context) => const WelcomeScreen(),
        '/ManageDepartmentsScreen': (context) => const ManageDepartmentsScreen(),
        '/SignUpManagerScreen': (context) => const SignUpManagerScreen(),

        // 🧑‍💼 مدير القسم
        '/section-manager/home': (context) => const SectionManagerHome(),
        '/section-manager/wings': (context) => const WingListPage(),
      //  '/section-manager/wings/add': (context) => const AddWingPage(),
      //  '/section-manager/wings/edit': (context) => const EditWingPage(),
        '/section-manager/requests': (context) => const RequestsListPage(),
      //  '/section-manager/request-details': (context) => const RequestDetailsPage(),

        // 🏢 العارض
        '/exhibitor/request-form': (context) => ExhibitorRequestFormPage(),
        '/exhibitor/request-status': (context) => RequestStatusPage(),
        '/exhibitor/rent-payment': (context) => RentPaymentPage(),

        // 🌐 الزائر (صفحة مؤقتة)
        '/visitor/home': (context) => const Placeholder(),
      },
    );
  }
}
