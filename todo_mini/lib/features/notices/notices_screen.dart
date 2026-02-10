import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/ui/widgets/empty_view.dart';
import '../../core/ui/widgets/error_view.dart';
import '../../core/ui/widgets/loading_view.dart';

import '../../data/models/notice.dart';
import 'notices_view_model.dart';
import 'notice_detail_screen.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoticesViewModel>(
      builder: (_, vm, __) {
        final s = vm.state;

        Widget body;
        if (s.isLoading) {
          body = const LoadingView();
        } else if (s.isEmpty) {
          body = EmptyView(
            title: '공지사항이 없습니다',
            description: '관리자가 공지를 등록하면 여기에 표시됩니다.',
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
            itemBuilder: (_, i) => _NoticeTile(notice: items[i]),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Notices')),
          body: body,
        );
      },
    );
  }
}

class _NoticeTile extends StatelessWidget {
  final Notice notice;

  const _NoticeTile({required this.notice});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        notice.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        notice.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => NoticeDetailScreen(notice: notice),
          ),
        );
      },
    );
  }
}
