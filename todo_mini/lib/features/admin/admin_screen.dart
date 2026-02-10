import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/ui/widgets/loading_view.dart';
import '../../core/ui/widgets/empty_view.dart';
import '../../core/ui/widgets/error_view.dart';

import '../../data/models/app_user.dart';
import '../../data/models/todo.dart';
import '../../data/models/notice.dart';

import '../../data/repositories/user_repository.dart';
import '../../data/repositories/todo_repository.dart';
import '../../data/repositories/notice_repository.dart';

import 'admin_view_model.dart';
import 'create_todo_dialog.dart';
import 'create_notice_dialog.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => AdminViewModel(
        ctx.read<UserRepository>(),
        ctx.read<TodoRepository>(),
        ctx.read<NoticeRepository>(),
      )..start(),
      child: Consumer<AdminViewModel>(
        builder: (_, vm, __) {
          final action = vm.actionState;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Admin'),
              actions: [
                IconButton(
                  key: const Key('btn_admin_add_todo'),
                  tooltip: 'Add Todo',
                  onPressed: () async {
                    final users = vm.usersState.data ?? <AppUser>[];
                    await showDialog(
                      context: context,
                      builder: (_) => CreateTodoDialog(
                        users: users,
                        onSubmit: (title, desc, due, assigneeId) async {
                          await vm.createTodo(
                            title: title,
                            description: desc,
                            dueDate: due,
                            assigneeId: assigneeId,
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_task),
                ),
                IconButton(
                  key: const Key('btn_admin_add_notice'),
                  tooltip: 'Add Notice',
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => CreateNoticeDialog(
                        onSubmit: (title, content) async {
                          await vm.createNotice(title: title, content: content);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.campaign),
                ),
              ],
            ),
            body: Column(
              children: [
                if (action.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: LoadingView(message: '처리 중...'),
                  ),
                if (action.isError)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ErrorView(
                      title: '작업 실패',
                      description: action.message,
                      onRetry: vm.resetActionState,
                    ),
                  ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _SectionTitle(
                        title: 'Users',
                        onRefresh: vm.loadUsers,
                      ),
                      _UsersSection(state: vm.usersState),

                      const SizedBox(height: 24),

                      const _SectionTitle(title: 'Todos'),
                      _TodosSection(
                        state: vm.todosState,
                        onDelete: vm.deleteTodo,
                      ),

                      const SizedBox(height: 24),

                      const _SectionTitle(title: 'Notices'),
                      _NoticesSection(
                        state: vm.noticesState,
                        onDelete: vm.deleteNotice,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Future<void> Function()? onRefresh;

  const _SectionTitle({required this.title, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        if (onRefresh != null)
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
          ),
      ],
    );
  }
}

class _UsersSection extends StatelessWidget {
  final state;

  const _UsersSection({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) return const LoadingView();
    if (state.isEmpty) return const EmptyView(title: '유저가 없습니다');
    if (state.isError) return ErrorView(description: state.message);

    final List<AppUser> users = state.data!;
    return Column(
      children: users
          .map(
            (u) => ListTile(
              dense: true,
              title: Text(u.name),
              subtitle: Text('role: ${u.role.name} / uid: ${u.id}'),
            ),
          )
          .toList(),
    );
  }
}

class _TodosSection extends StatelessWidget {
  final state;
  final Future<void> Function(String todoId) onDelete;

  const _TodosSection({required this.state, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) return const LoadingView();
    if (state.isEmpty) return const EmptyView(title: 'Todo가 없습니다');
    if (state.isError) return ErrorView(description: state.message);

    final List<Todo> items = state.data!;
    return Column(
      children: items
          .map(
            (t) => ListTile(
              dense: true,
              title: Text(t.title),
              subtitle: Text('assignee: ${t.assigneeId} / status: ${t.status.name}'),
              trailing: IconButton(
                key: Key('btn_delete_todo_${t.id}'),
                icon: const Icon(Icons.delete),
                onPressed: () => onDelete(t.id),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _NoticesSection extends StatelessWidget {
  final state;
  final Future<void> Function(String noticeId) onDelete;

  const _NoticesSection({required this.state, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) return const LoadingView();
    if (state.isEmpty) return const EmptyView(title: '공지사항이 없습니다');
    if (state.isError) return ErrorView(description: state.message);

    final List<Notice> items = state.data!;
    return Column(
      children: items
          .map(
            (n) => ListTile(
              dense: true,
              title: Text(n.title),
              subtitle: Text(n.content, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: IconButton(
                key: Key('btn_delete_notice_${n.id}'),
                icon: const Icon(Icons.delete),
                onPressed: () => onDelete(n.id),
              ),
            ),
          )
          .toList(),
    );
  }
}
