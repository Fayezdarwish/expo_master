import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';

/// شاشة عرض الأقسام التي يمكن للعارض التقديم عليها
class VendorSectionsScreen extends StatefulWidget {
  @override
  _VendorSectionsScreenState createState() => _VendorSectionsScreenState();
}

class _VendorSectionsScreenState extends State<VendorSectionsScreen> {
  List sections = [];

  @override
  void initState() {
    super.initState();
    fetchSections();
  }

  /// جلب الأقسام من السيرفر
  Future<void> fetchSections() async {
    final response = await ApiService.get('/sections');
    if (response != null && response.statusCode == 200) {
      setState(() {
        sections = response.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الأقسام المتاحة')),
      body: ListView.builder(
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
