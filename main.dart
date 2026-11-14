import 'package:flutter/material.dart';

void main() => runApp(const TodoApp());

class Task {
  String title, description, priority;
  DateTime? due;
  bool done;
  Task(this.title,
      {this.description = '', this.priority = 'Medium', this.due, this.done = false});
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
        home: const HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> tasks = [
    Task('Buy groceries',
        description: 'Milk, eggs, bread', priority: 'High', due: DateTime(2026, 11, 15)),
    Task('Call mom', priority: 'Low'),
  ];

  Color _color(String p) =>
      p == 'High' ? Colors.red : (p == 'Medium' ? Colors.orange : Colors.green);

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';

  void _showForm({Task? task}) {
    final titleCtrl = TextEditingController(text: task?.title ?? '');
    final descCtrl = TextEditingController(text: task?.description ?? '');
    String priority = task?.priority ?? 'Medium';
    DateTime? due = task?.due;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text(task == null ? 'Add Task' : 'Edit Task'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title')),
              TextField(
                  controller: descCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Description (optional)')),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: priority,
                isExpanded: true,
                items: ['High', 'Medium', 'Low']
                    .map((p) => DropdownMenuItem(value: p, child: Text('Priority: $p')))
                    .toList(),
                onChanged: (v) => setD(() => priority = v!),
              ),
              TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(due == null ? 'Pick due date' : 'Due: ${_fmt(due!)}'),
                onPressed: () async {
                  final d = await showDatePicker(
                    context: ctx,
                    initialDate: due ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (d != null) setD(() => due = d);
                },
              ),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                setState(() {
                  if (task == null) {
                    tasks.add(Task(titleCtrl.text.trim(),
                        description: descCtrl.text.trim(), priority: priority, due: due));
                  } else {
                    task.title = titleCtrl.text.trim();
                    task.description = descCtrl.text.trim();
                    task.priority = priority;
                    task.due = due;
                  }
                });
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My To-Do List'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, i) {
                final t = tasks[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Checkbox(
                      value: t.done,
                      onChanged: (v) => setState(() => t.done = v!),
                    ),
                    title: Text(
                      t.title,
                      style: TextStyle(
                          decoration: t.done ? TextDecoration.lineThrough : null),
                    ),
                    subtitle: Text(
                      [
                        if (t.description.isNotEmpty) t.description,
                        'Priority: ${t.priority}',
                        if (t.due != null) 'Due: ${_fmt(t.due!)}',
                      ].join('\n'),
                    ),
                    isThreeLine: true,
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.flag, color: _color(t.priority)),
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showForm(task: t)),
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => setState(() => tasks.remove(t))),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}
