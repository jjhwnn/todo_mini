import 'package:flutter/material.dart';

class CreateNoticeDialog extends StatefulWidget {
  final Future<void> Function(String title, String content) onSubmit;

  const CreateNoticeDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<CreateNoticeDialog> createState() => _CreateNoticeDialogState();
}

class _CreateNoticeDialogState extends State<CreateNoticeDialog> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Notice'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: const Key('admin_notice_title'),
            controller: _titleCtrl,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('admin_notice_content'),
            controller: _contentCtrl,
            decoration: const InputDecoration(labelText: 'Content'),
            maxLines: 4,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          key: const Key('admin_notice_submit'),
          onPressed: _saving
              ? null
              : () async {
                  final title = _titleCtrl.text.trim();
                  final content = _contentCtrl.text.trim();
                  if (title.isEmpty || content.isEmpty) return;

                  setState(() => _saving = true);
                  await widget.onSubmit(title, content);
                  if (mounted) Navigator.of(context).pop();
                },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
