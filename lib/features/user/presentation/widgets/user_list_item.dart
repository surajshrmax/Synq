import 'package:flutter/material.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/features/auth/domain/entities/user.dart';
import 'package:synq/features/user/presentation/widgets/profile_image.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onPressed;
  const UserListItem({super.key, required this.user, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    return GestureDetector(
      onTap: () => onPressed(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          spacing: 10,
          children: [
            ProfileImage(letter: user.name.characters.first.toUpperCase()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    color: textTheme?.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "@${user.userName}",
                  style: TextStyle(color: textTheme?.secondaryTextColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
