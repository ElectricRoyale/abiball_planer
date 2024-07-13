import 'package:abiball_planer/core/managment/stateManagementEmail.dart';
import 'package:flutter/cupertino.dart';

class ManagerProviderEmail extends InheritedNotifier<StateManagerEmail> {
  const ManagerProviderEmail({super.key, super.notifier, required super.child});

  static StateManagerEmail of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ManagerProviderEmail>()!
        .notifier!;
  }

  @override
  bool updateShouldNotify(ManagerProviderEmail oldWidget) {
    return notifier != oldWidget.notifier;
  }
}