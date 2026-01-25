import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_nav_provider.g.dart';

// State: Index of the selected tab (0: Home, 1: Stats, 2: Goals)
@riverpod
class NavIndex extends _$NavIndex {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}