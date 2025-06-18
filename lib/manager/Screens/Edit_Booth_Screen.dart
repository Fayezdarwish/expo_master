import 'package:flutter/material.dart';
import '../api/BoothApi.dart';

class EditBoothScreen extends StatefulWidget {
  @override
  _EditBoothScreenState createState() => _EditBoothScreenState();
}

class _EditBoothScreenState extends State<EditBoothScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '', description = '', imageUrl = '', contactLink = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooth();
  }

  Future<void> _loadBooth() async {
    final booth = await BoothApi.getBooth();
    if (booth != null) {
      setState(() {
        name = booth['name'] ?? '';
        description = booth['description'] ?? '';
        imageUrl = booth['image_url'] ?? '';
        contactLink = booth['contact_link'] ?? '';
        isLoading = false;
      });
    } else {
      // إذا حصل خطأ بالتحميل، نوقف الـ loading ويمكن تعرض رسالة خطأ
      setState(() => isLoading = false);
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    final ok = await BoothApi.updateBooth(
      name: name,
      description: description,
      imageUrl: imageUrl,
      contactLink: contactLink,
    );
    setState(() => isLoading = false);
    if (ok) Navigator.pop(context);
    else {
      // ممكن تعرض رسالة خطأ هنا
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء حفظ البيانات')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تعديل بيانات الجناح')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'اسم الجناح'),
                onChanged: (v) => name = v,
                validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'الوصف'),
                onChanged: (v) => description = v,
                validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                initialValue: imageUrl,
                decoration: InputDecoration(labelText: 'رابط الصورة'),
                onChanged: (v) => imageUrl = v,
                validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                initialValue: contactLink,
                decoration: InputDecoration(labelText: 'رابط التواصل'),
                onChanged: (v) => contactLink = v,
                validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: save,
                child: Text('حفظ التغييرات'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
