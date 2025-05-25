import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expo_master/main.dart';
import 'package:expo_master/Features/welcome_screen.dart';

void main() {
  testWidgets('يتم تحميل شاشة الترحيب بشكل صحيح', (WidgetTester tester) async {
    // ضخ التطبيق
    await tester.pumpWidget(const ExpoMasterApp());

    // تحقق من وجود عنصر متوقع في شاشة الترحيب
    expect(find.byType(WelcomeScreen), findsOneWidget);

    // تحقق من وجود نص الترحيب أو عنوان التطبيق
    expect(find.text('Expo Master'), findsWidgets);
  });
}
