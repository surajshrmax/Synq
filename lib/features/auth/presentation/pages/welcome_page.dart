import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_button.dart';
import 'package:synq/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/config/theme/app_theme.dart';
import 'package:synq/system_bars_wrapper.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SystemBarsWrapper(
      child: Scaffold(
        backgroundColor: lightBackgroundColor,
        body: Padding(
          padding: EdgeInsets.all(13.r),
          child: Column(
            children: [
              SizedBox(height: 60.h),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "synq provides best chatting experience with security."
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Neue",
                      fontSize: 22.sp,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ),

              Flexible(
                flex: 8,
                child: RotationTransition(
                  turns: controller,
                  child: AnimatedContainer(
                    duration: Duration(seconds: 10),
                    child: SvgPicture.asset(
                      "assets/images/group.svg",
                      fit: BoxFit.fitHeight,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SynqButton(
                  title: 'Continue',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
