import 'package:go_router/go_router.dart';
import 'package:synq/features/conversation/presentation/pages/conversation_page.dart';
import 'package:synq/features/conversation/presentation/pages/find_user_page.dart';
import 'package:synq/features/conversation/presentation/pages/message_page.dart';

final routes = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: "/", builder: (context, state) => ConversationPage()),
    GoRoute(path: "/search", builder: (context, state) => FindUserPage()),
    GoRoute(
      path: "/message/:id",
      builder: (context, state) {
        final userID = state.pathParameters['id'];
        return MessagePage(userID: userID!);
      },
    ),
  ],
);
