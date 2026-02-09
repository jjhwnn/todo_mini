import 'package:flutter/material.dart';

/// "로딩" 화면을 공통 컴포넌트로 분리합니다.
/// 화면마다 로딩 UI를 따로 만들면, 디자인/동작이 분산되어 관리가 힘들어집니다.
class LoadingView extends StatelessWidget {
  final String? message;

  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final text = message ?? '불러오는 중...';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(text),
        ],
      ),
    );
  }
}
