import 'package:flutter_driver/driver_extension.dart';
import 'package:${projectName}/main.dart' as app;
import 'package:flutter/material.dart';

void main() {

   //Remove debug banner for screenshots
  WidgetsApp.debugAllowBannerOverride = false;

  // This line enables the extension
  enableFlutterDriverExtension();

  // Call the `main()` function of your app or call `runApp` with any widget you
  // are interested in testing.
  app.main();
}

