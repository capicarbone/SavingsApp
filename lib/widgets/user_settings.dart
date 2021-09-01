import 'package:flutter/material.dart';
import 'package:savings_app/blocs/settings_data.dart';

class UserSettings extends InheritedWidget {
  const UserSettings({
    Key key,
    Widget child,
    this.settings
  }) : super(key: key, child: child);

  final SettingsData settings;

  static SettingsData of(BuildContext context) {
    final UserSettings result =
        context.dependOnInheritedWidgetOfExactType<UserSettings>();
    assert(result != null, 'No UserSettings found in context');
    return result.settings;
  }

  @override
  bool updateShouldNotify(UserSettings old) {
    // TODO Implement correctly
    return true;
  }
}
