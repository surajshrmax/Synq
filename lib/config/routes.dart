import 'package:go_router/go_router.dart';
import 'package:synq/features/auth/presentation/pages/login_page.dart';
import 'package:synq/features/auth/presentation/pages/register_page.dart';
import 'package:synq/features/auth/presentation/pages/welcome_page.dart';
import 'package:synq/features/chat/presentation/pages/chat_page.dart';
import 'package:synq/features/chat/presentation/pages/search_user_page.dart';
import 'package:synq/features/message/presentation/pages/message_page.dart';
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
    GoRoute(path: "/home", builder: (context, state) => ChatPage()),
    GoRoute(path: "/search", builder: (context, state) => SearchUserPage()),
    GoRoute(
      path: "/message/:conversationId/:userId",
      builder: (context, state) {
        final conversationId = state.pathParameters['conversationId'];
        final userID = state.pathParameters['userId'];
        return MessagePage(chatId: conversationId!, userId: userID!);
      },
    ),
  ],
);
