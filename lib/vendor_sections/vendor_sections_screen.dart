import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'vendor_request_form.dart';

class VendorSectionsScreen extends StatefulWidget {
  @override
  _VendorSectionsScreenState createState() => _VendorSectionsScreenState();
}

class _VendorSectionsScreenState extends State<VendorSectionsScreen> {
  List sections = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchSections();
  }

  Future<void> fetchSections() async {
    final response = await ApiService.get('/sections');
    if (response != null && response.statusCode == 200) {
      setState(() {
        sections = response.data;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      // يمكن عرض رسالة خطأ أو إعادة المحاولة
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الأقسام المتاحة')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return ListTile(
            title: Text(section['name'], style: Theme.of(context).textTheme.titleLarge),
            trailing: ElevatedButton(
              child: Text('تقديم طلب'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VendorRequestForm(sectionId: section['id']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
