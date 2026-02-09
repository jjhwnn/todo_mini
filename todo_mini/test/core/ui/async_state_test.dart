import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mini/core/ui/async_state.dart';

void main() {
  group('AsyncState', () {
    test('idle state should be idle', () {
      const state = AsyncState<int>.idle();
      expect(state.isIdle, true);
      expect(state.isLoading, false);
      expect(state.isSuccess, false);
      expect(state.isEmpty, false);
      expect(state.isError, false);
      expect(state.data, isNull);
      expect(state.message, isNull);
      expect(state.code, isNull);
    });

    test('loading state should be loading', () {
      const state = AsyncState<int>.loading();
      expect(state.isLoading, true);
      expect(state.data, isNull);
    });

    test('success state should hold data', () {
      const state = AsyncState<int>.success(42);
      expect(state.isSuccess, true);
      expect(state.data, 42);
      expect(state.message, isNull);
    });

    test('empty state should be empty', () {
      const state = AsyncState<List<int>>.empty();
      expect(state.isEmpty, true);
      expect(state.data, isNull);
    });

    test('error state should include message and optional code', () {
      const state = AsyncState<void>.error(message: 'boom', code: 'permission-denied');
      expect(state.isError, true);
      expect(state.message, 'boom');
      expect(state.code, 'permission-denied');
    });
  });
}
