import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/core/di/service_locator.dart';
import 'package:synq/core/storage/secure_storage.dart';
import 'package:synq/features/auth/presentation/pages/welcome_page.dart';
import 'package:synq/features/conversation/presentation/pages/conversation_page.dart';
import 'package:synq/system_bars_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  final SecureStorage storage = getIt<SecureStorage>();
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);
    if (!mounted) return;
    checkIfUserLoggedIn();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  checkIfUserLoggedIn() async {
    await Future.delayed(Duration(seconds: 2), () async {
      var token = await storage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ConversationPage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SystemBarsWrapper(
      child: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              Text(
                "Synq",
                style: TextStyle(fontSize: 48.sp, fontFamily: "Neue"),
              ),
              FadeTransition(
                opacity: controller,
                child: Container(
                  height: 80.h,
                  width: 10.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
