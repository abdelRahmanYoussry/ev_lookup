import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/services_locator.dart';

void main() {
  setupServiceLocator();
  runApp(const App());
}
