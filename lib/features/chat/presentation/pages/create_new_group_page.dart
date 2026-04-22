import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_text_field.dart';
import 'package:synq/system_bars_wrapper.dart';

class CreateNewGroupPage extends StatelessWidget {
  const CreateNewGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    return SystemBarsWrapper(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push("/select_members/Dhoom");
          },
          shape: CircleBorder(),

          child: HugeIcon(icon: HugeIcons.strokeRoundedTick01),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: mediaQuery.padding.top + 40,
            left: 15,
            right: 15,
            bottom: mediaQuery.padding.bottom,
          ),
          child: Column(
            children: [
              Row(
                spacing: 5,
                children: [
                  HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01),
                  Text("Back"),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "What's this group called?",
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.w700),
              ),

              SizedBox(height: 30),

              SynqTextField(hintText: "Group Name"),
            ],
          ),
        ),
      ),
    );
  }
}
