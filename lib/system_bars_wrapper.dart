import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synq/config/theme/app_theme.dart';

class SystemBarsWrapper extends StatelessWidget {
  final Color? statusBarColor;
  final Brightness? statusBarIconBrightness;
  final Color? navigtaionBarColor;
  final Brightness? navigationBarIconBrightness;
  final Widget child;
  const SystemBarsWrapper({
    super.key,
    required this.child,
    this.statusBarColor,
    this.statusBarIconBrightness,
    this.navigtaionBarColor,
    this.navigationBarIconBrightness,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconBrightness = isDark ? Brightness.light : Brightness.dark;
    final scaffoldColor = theme.scaffoldBackgroundColor;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: statusBarColor ?? scaffoldColor,
          systemNavigationBarColor: navigtaionBarColor ?? scaffoldColor,
          statusBarIconBrightness: statusBarIconBrightness ?? iconBrightness,
          systemNavigationBarIconBrightness:
              navigationBarIconBrightness ?? iconBrightness,
        ),
      );
    });
    return child;
  }
}
