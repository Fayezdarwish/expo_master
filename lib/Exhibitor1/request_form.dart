import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';

class RequestFormScreen extends StatefulWidget {
  const RequestFormScreen({super.key});
  @override State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _notesCtl = TextEditingController();
  int? _selectedDeptId;
  bool _isLoading = false;
  List<Map<String, dynamic>> _depts = [];

  @override void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    final res = await ApiService.get('/exhibitor/departments');
    if (res?.statusCode == 200) {
      setState(() {
        _depts = List<Map<String, dynamic>>.from(res!.data['departments']);
        _selectedDeptId = _depts.isNotEmpty ? _depts.first['id'] : null;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDeptId == null) return;
    setState(() => _isLoading = true);
    final token = await TokenStorage.getToken();
    final res = await ApiService.postWithToken(
      '/create-request',
      {
        'exhibitionName': _nameCtl.text,
        'departmentId': _selectedDeptId,
        'contactPhone': _phoneCtl.text,
        'notes': _notesCtl.text,
      },
      token!,
    );
    setState(() => _isLoading = false);
    if (res?.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تم إرسال الطلب')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('فشل الإرسال')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تقديم طلب مشاركة')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _depts.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtl,
                decoration: const InputDecoration(labelText: 'اسم المشروع'),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _phoneCtl,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<int>(
                value: _selectedDeptId,
                decoration: const InputDecoration(labelText: 'القسم'),
                items: _depts
                    .map((d) => DropdownMenuItem(
                    value: d['id'], child: Text(d['name'])))
                    .toList(),
                onChanged: (v) => setState(() => _selectedDeptId = v),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _notesCtl,
                decoration: const InputDecoration(labelText: 'ملاحظات'),
                maxLines: 3,
              ),
              const SizedBox(height: 25),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _submit,
                child: const Text('إرسال الطلب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
