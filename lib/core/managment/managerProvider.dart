import 'package:abiball_planer/core/managment/stateManagment.dart';
import 'package:flutter/cupertino.dart';

class ManagerProvider extends InheritedNotifier<StateManager> {
  const ManagerProvider({super.key, super.notifier, required super.child});

  static StateManager of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ManagerProvider>()!
        .notifier!;
  }

  @override
  bool updateShouldNotify(ManagerProvider oldWidget) {
    return notifier != oldWidget.notifier;
  }
}
