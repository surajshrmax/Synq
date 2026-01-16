import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/config/theme/app_theme.dart';
import 'package:synq/core/di/service_locator.dart';
import 'package:synq/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/features/conversation/presentation/bloc/search_user_bloc.dart';
import 'package:synq/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  setUpDI();
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
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightThemeData,
            darkTheme: darkThemeData,
            themeMode: ThemeMode.system,
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}
