import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/ui/widgets/error_view.dart';
import '../../core/ui/widgets/loading_view.dart';
import '../../data/models/todo.dart';

import '../home/home_view_model.dart';
import 'todo_detail_view_model.dart';

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;

  const TodoDetailScreen({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final myUid = context.read<HomeViewModel>().meState.data!.id;

    return ChangeNotifierProvider(
      create: (ctx) => TodoDetailViewModel(ctx.read()),
      child: Consumer<TodoDetailViewModel>(
        builder: (_, vm, __) {
          final s = vm.state;

          return Scaffold(
            appBar: AppBar(title: const Text('Todo Detail')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(todo.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(todo.description ?? '-'),
                  const SizedBox(height: 16),

                  Text('Current status: ${todo.status.name.toUpperCase()}'),

                  const SizedBox(height: 16),

                  if (s.isLoading) const LoadingView(message: '업데이트 중...'),
                  if (s.isError)
                    ErrorView(
                      title: '실패',
                      description: s.message,
                      onRetry: vm.resetError,
                    ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      key: const Key('btn_toggle_status'),
                      onPressed: s.isLoading
                          ? null
                          : () => vm.toggleStatus(todo: todo, myUid: myUid),
                      child: Text(
                        todo.status == TodoStatus.done ? 'DONE → OPEN' : 'OPEN → DONE',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
