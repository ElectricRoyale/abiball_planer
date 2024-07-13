import 'package:abiball_planer/core/managment/stateManagementStudents.dart';
import 'package:flutter/cupertino.dart';

class ManagerProviderStudents extends InheritedNotifier<StateManagerStudents> {
  const ManagerProviderStudents({super.key, super.notifier, required super.child});

  static StateManagerStudents of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ManagerProviderStudents>()!
        .notifier!;
  }

  @override
  bool updateShouldNotify(ManagerProviderStudents oldWidget) {
    return notifier != oldWidget.notifier;
  }
}
