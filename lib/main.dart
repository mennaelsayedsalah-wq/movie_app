import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'constants/app_colors.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/movie/bloc.dart';

import 'view/screen/splash_screen.dart';
import 'bloc/lists/lists_bloc.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CineNovaApp());
}

class CineNovaApp extends StatelessWidget {
  const CineNovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
  BlocProvider(
    create: (_) => AuthBloc()..add(CheckAuth()),
  ),

  BlocProvider(
    create: (_) => MovieBloc(),
  ),

  BlocProvider(
    create: (_) => ListsBloc(),
  ),
],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CineNova',

        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,

          scaffoldBackgroundColor:
              AppColors.background,

          colorScheme: const ColorScheme.dark(
            primary: AppColors.Primary,
            secondary: AppColors.accent,
            surface: AppColors.Surface,
          ),

          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.white,
            elevation: 0,
          ),

          inputDecorationTheme:
              InputDecorationTheme(
            filled: true,
            fillColor: AppColors.Surface,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
              borderSide: BorderSide(
                color: AppColors.Primary,
                width: 1.5,
              ),
            ),
          ),

          elevatedButtonTheme:
              ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.Primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(
                double.infinity,
                52,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        home: const SplashScreen(),
      ),
    );
  }
}