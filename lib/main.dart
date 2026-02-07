import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:place_see_app/core/auth/auth_state.dart';
import 'package:place_see_app/features/auth/screen/login_screen.dart';
import 'package:place_see_app/features/auth/service/auth_service.dart';
import 'package:place_see_app/features/main_screens/categories/screen/categories_screen.dart';
import 'package:place_see_app/features/onboarding/screen/onboarding_screen.dart';
import 'package:place_see_app/core/local_storage/app_settings.dart';
import 'package:place_see_app/core/local_storage/token_storage.dart';
import 'package:place_see_app/core/network/dio_client.dart';
import 'package:place_see_app/features/onboarding/service/onboarding_service.dart';
import 'package:place_see_app/features/onboarding/view_model/onboarding_view_model.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/theme/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('settings');

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
        ChangeNotifierProvider(create:
          (_) => AuthState(),
        ),

        Provider(create:
          (_) => AppSettings(Hive.box('settings'))
        ),

        Provider(create:
          (_) => TokenStorage()
        ),

        ProxyProvider2<AuthState, TokenStorage, DioClient>(update:
          (_, authState, tokenStorage, _) =>
              DioClient(tokenStorage, authState),
        ),

        ProxyProvider3<DioClient, AuthState, TokenStorage, AuthService>(update:
            (_, dioClient, authState, tokenStorage, _) =>
            AuthService(dioClient.dio, tokenStorage, authState),
        ),

        ProxyProvider<AppSettings, OnboardingService>(update:
            (_, appSettings, _) =>
            OnboardingService(appSettings),
        ),

        ChangeNotifierProxyProvider<OnboardingService, OnboardingViewModel>(
          create: (_) => OnboardingViewModel(),
          update: (_, onboardingService, previous) {
            previous!.updateService(onboardingService);
            return previous;
          },
        ),


      ],
      child: const AppRoot(),
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final appSettings = context.read<AppSettings>();

    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.primary,
        extendBodyBehindAppBar: true,
        body: SizedBox.expand(
          child: () {
            if (!appSettings.getIsOnboardingCompleted()) {
              return const OnboardingScreen();
            }

            switch (authState.value) {
              case AuthEnum.unauthenticated:
                return const LoginScreen();
              case AuthEnum.authenticated:
                return const CategoriesScreen();
              case AuthEnum.unknown:
                return const OnboardingScreen();
            }
          } (),
        ),
      )
    );
  }
}

