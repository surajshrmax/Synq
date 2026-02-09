import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:synq/config/routes.dart';
import 'package:synq/config/theme/app_theme.dart';
import 'package:synq/core/di/service_locator.dart';
import 'package:synq/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/features/conversation/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_box_cubit.dart';
import 'package:synq/features/conversation/presentation/bloc/search/search_user_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/user/user_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  setUpDI();
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen((record) {
    print(
      '[${record.level.name}] '
      '${record.loggerName}: '
      '${record.message}',
    );
  });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
            BlocProvider<SearchUserBloc>(
              create: (_) => getIt<SearchUserBloc>(),
            ),
            BlocProvider(create: (_) => getIt<ConversationBloc>()),
            BlocProvider(create: (_) => getIt<MessageBloc>()),
            BlocProvider(create: (_) => getIt<UserBloc>()),
            BlocProvider(create: (_) => MessageBoxCubit()),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: lightThemeData,
            darkTheme: darkThemeData,
            themeMode: ThemeMode.system,
            routerConfig: routes,
          ),
        );
      },
    );
  }
}
