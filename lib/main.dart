import 'package:flutter/material.dart';
import 'package:expo_master/config/theme.dart';

// شاشات تسجيل الدخول والتسجيل واستعادة كلمة المرور
import 'package:expo_master/screens_login_and_registar/login_screen.dart';
import 'package:expo_master/screens_login_and_registar/register_screen.dart';
import 'package:expo_master/screens_login_and_registar/forgot_password_screen.dart';
import 'package:expo_master/screens_login_and_registar/reset_password_screen.dart';

// شاشات المسؤول (Admin)
import 'Features/create_department_screen.dart';
import 'Features/sinup_screen_for_manger_section.dart';
import 'Features/welcome_screen.dart';
import 'Features/manage_departments_screen.dart';

// شاشات مدير القسم (Section Manager)
import 'manager/screen/RequestDetailsPage.dart';
import 'manager/screen/add_wing_page.dart';
import 'manager/screen/edit_wing_page.dart';
import 'manager/screen/requests_list_page.dart';
import 'manager/screen/section_manager_home.dart';
import 'manager/screen/wing_list_page.dart';

// شاشات العارض (Exhibitor)
import 'package:expo_master/vendor_sections/vendor_booth_tasks_screen.dart';
import 'package:expo_master/vendor_sections/vendor_create_booth_screen.dart';
import 'package:expo_master/vendor_sections/vendor_final_payment_screen.dart';
import 'package:expo_master/vendor_sections/vendor_initial_payment_screen.dart';
import 'package:expo_master/vendor_sections/vendor_request_form.dart';
import 'package:expo_master/vendor_sections/vendor_requests_status_screen.dart';
import 'package:expo_master/vendor_sections/vendor_sections_screen.dart';

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
        // شاشات تسجيل الدخول والمصادقة
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignUpScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),

        // شاشات المسؤول (Admin)
        '/admin/welcome': (context) => const WelcomeScreen(),
        '/ManageDepartmentsScreen': (context) => const ManageDepartmentsScreen(),
        '/SignUpManagerScreen': (context) => const SignUpManagerScreen(),

        // شاشات مدير القسم (Section Manager)
        '/section-manager/home': (context) => const SectionManagerHome(),
        '/section-manager/wings': (context) => const WingListPage(),
       // '/section-manager/wings/add': (context) => const AddWingPage(),
        // '/section-manager/wings/edit': (context) => const EditWingPage(),
        '/section-manager/requests': (context) => const RequestsListPage(),

        // شاشات العارض (Exhibitor)
        '/exhibitor/home': (context) =>  VendorSectionsScreen(),
        '/VendorInitialPaymentScreen': (context) => VendorInitialPaymentScreen(),
        '/VendorRequestsStatusScreen': (context) => VendorRequestsStatusScreen(),
        '/VendorSectionsScreen': (context) => VendorSectionsScreen(),
       // '/VendorBoothTasksScreen': (context) => VendorBoothTasksScreen(),
       // '/VendorCreateBoothScreen': (context) => VendorCreateBoothScreen(),
       // '/VendorFinalPaymentScreen': (context) => VendorFinalPaymentScreen(),

        // صفحة الزائر - مؤقتة Placeholder
        '/visitor/home': (context) => const Placeholder(),
      },
    );
  }
}
