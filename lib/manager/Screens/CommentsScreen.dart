import 'package:flutter/material.dart';
import '../api/BoothApi.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<Map<String, dynamic>>? comments;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Future<void> loadComments() async {
    final data = await BoothApi.getComments();
    setState(() {
      comments = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('التعليقات')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (comments == null || comments!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('التعليقات')),
        body: Center(child: Text('لا توجد تعليقات')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('التعليقات')),
      body: ListView.builder(
        itemCount: comments!.length,
        itemBuilder: (_, i) {
          final c = comments![i];
          final userName = c['user_name'] ?? 'مستخدم';
          final content = c['content'] ?? '';
          final createdAt = c['created_at'] != null
              ? (c['created_at'] as String).split('T')[0]
              : '';

          return ListTile(
            leading: CircleAvatar(
              child: Text(userName.isNotEmpty ? userName[0] : '?'),
            ),
            title: Text(userName),
            subtitle: Text(content),
            trailing: Text(createdAt),
          );
        },
      ),
    );
  }
}
