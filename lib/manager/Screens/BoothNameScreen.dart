import 'package:flutter/material.dart';
import '../api/BoothApi.dart';

class BoothNameScreen extends StatefulWidget {
  @override
  _BoothNameScreenState createState() => _BoothNameScreenState();
}

class _BoothNameScreenState extends State<BoothNameScreen> {
  String? boothName;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadBoothName();
  }

  Future<void> loadBoothName() async {
    try {
      final booth = await BoothApi.getBooth();
      setState(() {
        boothName = booth?['name'] ?? 'غير معروف';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'خطأ في جلب بيانات الجناح';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('اسم الجناح')),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : error != null
            ? Text(error!, style: TextStyle(color: Colors.red))
            : Text(boothName ?? 'لا يوجد اسم جناح', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
