    import 'package:flutter/material.dart';
    import 'package:expo_master/config/theme.dart';

    // شاشات تسجيل الدخول والتسجيل واستعادة كلمة المرور
    import 'package:expo_master/screens_login_and_registar/login_screen.dart';
    import 'package:expo_master/screens_login_and_registar/register_screen.dart';
    import 'package:expo_master/screens_login_and_registar/forgot_password_screen.dart';
    import 'package:expo_master/screens_login_and_registar/reset_password_screen.dart';

    // شاشات المسؤول (Admin)
    import 'Exhibitor/select_department_screen.dart';
    import 'Features/create_department_screen.dart';
    import 'Features/manage_departments_screen.dart';
    import 'Features/sinup_screen_for_manger_section.dart';
    import 'Features/welcome_screen.dart';

    // شاشات مدير القسم (Section Manager)
    import 'User/BoothProductsScreen.dart';
    import 'User/DepartmentsScreen.dart';
    import 'User/ReservedBoothsScreen.dart';
    import 'User/SectionsScreen.dart';
    import 'User/TicketPurchaseScreen.dart';
    import 'User/VisitorSectionSelectionScreen.dart';
    import 'manager/screen/RequestDetailsPage.dart';
    import 'manager/screen/section_manager_home.dart';
    import 'manager/screen/wing_list_page.dart';
    import 'manager/screen/requests_list_page.dart';
    import 'manager/screen/add_wing_page.dart';
    import 'manager/screen/edit_wing_page.dart';

    // شاشات العارض (Exhibitor)
    import 'Exhibitor/AddProductScreen.dart';
    import 'Exhibitor/ExhibitorHome.dart';
    import 'Exhibitor/MyProductsScreen.dart';
    import 'Exhibitor/create_wing_screen.dart';
    import 'Exhibitor/payment_screen.dart';
    import 'Exhibitor/submit_request_screen.dart';

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
          initialRoute: '/exhibitor/select-department',
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
            '/section-manager/requests': (context) => const RequestsListPage(),

            // 🏢 العارض (Exhibitor)
            '/exhibitor/home': (context) => const ExhibitorHomeScreen(),
            '/exhibitor/submit-request': (context) => const SubmitRequestScreen(),
            '/exhibitor/payment': (context) => const PaymentScreen(),
            '/exhibitor/create-wing': (context) => const CreateWingScreen(),
            '/exhibitor/add-product': (context) => const AddProductScreen(),
            '/exhibitor/my-products': (context) => const MyProductsScreen(),
            '/exhibitor/select-department': (context) => const SelectDepartmentScreen(),
            '/exhibitor/dashboard': (context) => const MyProductsScreen(), // اختياري: يمكن تغيير الوجهة

            // 🌐 الزائر
            '/user/DepartmentsScreen': (context) => const DepartmentsScreen(),
           // '/user/ReservedBoothsScreen': (context) => const ReservedBoothsScreen(),
            '/user/DepartmentsScreen': (context) => const DepartmentsScreen(), // شاشة ترحيبية للزائر
          },
        );
      }
    }



