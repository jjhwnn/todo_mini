import 'package:flutter/material.dart';
import '../../data/models/app_user.dart';

/// Todo 생성 다이얼로그(관리자용)
/// - 필수: title, assignee 선택
/// - 선택: description
class CreateTodoDialog extends StatefulWidget {
  final List<AppUser> users;

  /// (title, description, dueDate, assigneeId)
  final Future<void> Function(String, String?, DateTime?, String) onSubmit;

  const CreateTodoDialog({
    super.key,
    required this.users,
    required this.onSubmit,
  });

  @override
  State<CreateTodoDialog> createState() => _CreateTodoDialogState();
}

class _CreateTodoDialogState extends State<CreateTodoDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String? _assigneeId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.users.isNotEmpty) {
      _assigneeId = widget.users.first.id;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: const Key('admin_todo_title'),
            controller: _titleCtrl,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('admin_todo_desc'),
            controller: _descCtrl,
            decoration: const InputDecoration(labelText: 'Description (optional)'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            key: const Key('admin_todo_assignee'),
            value: _assigneeId,
            items: widget.users
                .map((u) => DropdownMenuItem(
                      value: u.id,
                      child: Text('${u.name} (${u.role.name})'),
                    ))
                .toList(),
            onChanged: _saving ? null : (v) => setState(() => _assigneeId = v),
            decoration: const InputDecoration(labelText: 'Assignee'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          key: const Key('admin_todo_submit'),
          onPressed: _saving
              ? null
              : () async {
                  final title = _titleCtrl.text.trim();
                  final assigneeId = _assigneeId;

                  if (title.isEmpty || assigneeId == null) return;

                  setState(() => _saving = true);
                  await widget.onSubmit(
                    title,
                    _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
                    null,
                    assigneeId,
                  );
                  if (mounted) Navigator.of(context).pop();
                },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
