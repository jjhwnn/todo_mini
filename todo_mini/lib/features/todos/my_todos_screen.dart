import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/ui/widgets/empty_view.dart';
import '../../core/ui/widgets/error_view.dart';
import '../../core/ui/widgets/loading_view.dart';
import '../../data/models/todo.dart';

import '../home/home_view_model.dart';
import 'my_todos_view_model.dart';
import 'todo_detail_screen.dart';

class MyTodosScreen extends StatefulWidget {
  const MyTodosScreen({super.key});

  @override
  State<MyTodosScreen> createState() => _MyTodosScreenState();
}

class _MyTodosScreenState extends State<MyTodosScreen> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // HomeViewModel에서 me가 준비된 후에만 start 호출
    if (_started) return;
    final homeVm = context.read<HomeViewModel>();
    if (homeVm.meState.isSuccess) {
      final myUid = homeVm.meState.data!.id;
      context.read<MyTodosViewModel>().start(myUid: myUid);
      _started = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyTodosViewModel>(
      builder: (_, vm, __) {
        final s = vm.state;

        Widget body;
        if (s.isLoading) {
          body = const LoadingView();
        } else if (s.isEmpty) {
          body = EmptyView(
            title: '내 할 일이 없습니다',
            description: '관리자가 할 일을 배정하면 여기에 표시됩니다.',
            onRetry: vm.retry,
          );
        } else if (s.isError) {
          body = ErrorView(
            description: s.message,
            onRetry: vm.retry,
          );
        } else {
          final items = s.data!;
          body = ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) => _TodoTile(todo: items[i]),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('My Todos')),
          body: body,
        );
      },
    );
  }
}

class _TodoTile extends StatelessWidget {
  final Todo todo;

  const _TodoTile({required this.todo});

  @override
  Widget build(BuildContext context) {
    final isDone = todo.status == TodoStatus.done;

    return ListTile(
      title: Text(
        todo.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(isDone ? 'DONE' : 'OPEN'),
      trailing: Icon(isDone ? Icons.check_circle : Icons.circle_outlined),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TodoDetailScreen(todo: todo),
          ),
        );
      },
    );
  }
}
