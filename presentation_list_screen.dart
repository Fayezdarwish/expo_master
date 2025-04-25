import 'package:flutter/material.dart';

import '../../../../config/theme.dart';

class Exhibitionlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          title: Text('قائمة المعارض'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'اسم المعرض',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),


                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                  label: Text('تعديل المعرض'),
                ),
                SizedBox(height: 10),

                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                  label: Text('حذف المعرض'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
