import 'package:flutter/material.dart';
import '../../services/token_storage.dart';
import '../visitor/api/visitor_api.dart';

class ExhibitorTasksScreen extends StatefulWidget {
  const ExhibitorTasksScreen({super.key});

  @override
  State<ExhibitorTasksScreen> createState() => _ExhibitorTasksScreenState();
}

class _ExhibitorTasksScreenState extends State<ExhibitorTasksScreen> {
  List<Map<String, dynamic>> tasks = [];
  final taskCtrl = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    final token = await TokenStorage.getToken();
    final result = await VisitorApi.getMyTasks(token!);
    if (result != null) {
      setState(() {
        tasks = result;
        isLoading = false;
      });
    }
  }

  void addTask() async {
    final text = taskCtrl.text.trim();
    if (text.isEmpty) return;

    final token = await TokenStorage.getToken();
    final success = await VisitorApi.addTask({'description': text}, token!);
    if (success) {
      taskCtrl.clear();
      loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مهام الجناح')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: taskCtrl,
              decoration: const InputDecoration(
                labelText: 'مهمة جديدة',
                suffixIcon: Icon(Icons.add_task),
              ),
              onSubmitted: (_) => addTask(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(task['description']),
                    trailing: Icon(
                      task['isCompleted'] ? Icons.check_circle : Icons.circle_outlined,
                      color: task['isCompleted'] ? Colors.green : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
