import 'package:go_router/go_router.dart';
import 'package:synq/features/auth/presentation/pages/login_page.dart';
import 'package:synq/features/auth/presentation/pages/register_page.dart';
import 'package:synq/features/auth/presentation/pages/welcome_page.dart';
import 'package:synq/features/conversation/presentation/pages/conversation_page.dart';
import 'package:synq/features/conversation/presentation/pages/find_user_page.dart';
import 'package:synq/features/conversation/presentation/pages/message_page.dart';
import 'package:synq/features/conversation/presentation/pages/message_re_write_page.dart';
import 'package:synq/splash_screen.dart';

final routes = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: "/", builder: (context, state) => SplashScreen()),
    GoRoute(path: "/welcome", builder: (context, state) => WelcomePage()),
    GoRoute(path: "/auth/login", builder: (context, state) => LoginPage()),
    GoRoute(
      path: "/auth/register",
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(path: "/home", builder: (context, state) => ConversationPage()),
    GoRoute(path: "/search", builder: (context, state) => FindUserPage()),
    GoRoute(
      path: "/message/:conversationId/:userId",
      builder: (context, state) {
        final conversationId = state.pathParameters['conversationId'];
        final userID = state.pathParameters['userId'];
        return MessageReWritePage(chatId: conversationId!, userId: userID!);
      },
    ),
  ],
);
