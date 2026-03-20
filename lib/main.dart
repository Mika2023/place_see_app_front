import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:place_see_app/core/api/auth_api.dart';
import 'package:place_see_app/core/api/category_api.dart';
import 'package:place_see_app/core/api/favorite_places_api.dart';
import 'package:place_see_app/core/api/photo_api.dart';
import 'package:place_see_app/core/api/places_api.dart';
import 'package:place_see_app/core/api/route_api.dart';
import 'package:place_see_app/core/api/tag_api.dart';
import 'package:place_see_app/core/api/user_api.dart';
import 'package:place_see_app/core/api/user_location_api.dart';
import 'package:place_see_app/core/auth/auth_state.dart';
import 'package:place_see_app/core/auth/auth_state_coordinator.dart';
import 'package:place_see_app/core/location/location_service.dart';
import 'package:place_see_app/core/location/location_tracking_manager.dart';
import 'package:place_see_app/core/model/tag/tag.dart';
import 'package:place_see_app/core/permission/permission_service.dart';
import 'package:place_see_app/features/auth/screen/login_screen.dart';
import 'package:place_see_app/features/auth/screen/registration_screen.dart';
import 'package:place_see_app/features/auth/service/auth_service.dart';
import 'package:place_see_app/features/auth/view_model/login_view_model.dart';
import 'package:place_see_app/features/auth/view_model/registration_view_model.dart';
import 'package:place_see_app/features/main_screens/categories/screen/categories_screen.dart';
import 'package:place_see_app/features/main_screens/categories/service/category_service.dart';
import 'package:place_see_app/features/main_screens/categories/view_model/categories_view_model.dart';
import 'package:place_see_app/features/main_screens/favorite_places/service/favorite_places_service.dart';
import 'package:place_see_app/features/main_screens/favorite_places/view_model/favorite_places_view_model.dart';
import 'package:place_see_app/features/main_screens/filters/service/filters_service.dart';
import 'package:place_see_app/features/main_screens/filters/view_model/filters_view_model.dart';
import 'package:place_see_app/features/main_screens/maps/service/maps_service.dart';
import 'package:place_see_app/features/main_screens/maps/view_model/maps_view_model.dart';
import 'package:place_see_app/features/main_screens/place/view_model/place_view_model.dart';
import 'package:place_see_app/features/main_screens/places/service/places_service.dart';
import 'package:place_see_app/features/main_screens/places/view_model/places_view_model.dart';
import 'package:place_see_app/features/main_screens/profile/service/profile_service.dart';
import 'package:place_see_app/features/main_screens/profile/view_model/profile_view_model.dart';
import 'package:place_see_app/features/user_location/screen/user_location_screen.dart';
import 'package:place_see_app/features/user_location/service/user_location_service.dart';
import 'package:place_see_app/features/user_location/view_model/user_location_view_model.dart';
import 'package:place_see_app/features/onboarding/screen/onboarding_screen.dart';
import 'package:place_see_app/core/local_storage/app_settings.dart';
import 'package:place_see_app/core/local_storage/token_storage.dart';
import 'package:place_see_app/core/network/dio_client.dart';
import 'package:place_see_app/features/onboarding/service/onboarding_service.dart';
import 'package:place_see_app/features/onboarding/view_model/onboarding_view_model.dart';
import 'package:place_see_app/ui/navigator/navigator_service.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/theme/theme.dart';
import 'package:place_see_app/ui/widget/main_scaffold_with_nav_bar.dart';
import 'package:place_see_app/ui/widget/nav_bar/map_data_provider.dart';
import 'package:place_see_app/ui/widget/nav_bar/nav_bar_provider.dart';
import 'package:provider/provider.dart';

import 'features/main_screens/place/service/place_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  await Hive.openBox('settings');

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
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

        Provider(create:
            (_) => NavigatorService()
        ),

        Provider(create:
          (_) => PermissionService()
        ),

        ProxyProvider<PermissionService, LocationService>(update:
          (_, permissionService, _) => LocationService(permissionService),
        ),

        ProxyProvider2<AuthState, TokenStorage, DioClient>(update:
          (_, authState, tokenStorage, _) =>
              DioClient(tokenStorage, authState),
        ),

        ProxyProvider<DioClient, AuthApi>(update:
            (_, dioClient, _) => AuthApi(dioClient.dio),
        ),

        ProxyProvider<DioClient, UserLocationApi>(update:
            (_, dioClient, _) => UserLocationApi(dioClient.dio),
        ),

        ProxyProvider<DioClient, CategoryApi>(update:
            (_, dioClient, _) => CategoryApi(dioClient.dio),
        ),

        ProxyProvider<DioClient, PlacesApi>(update:
            (_, dioClient, _) => PlacesApi(dioClient.dio),
        ),

        ProxyProvider<DioClient, FavoritePlacesApi>(update:
            (_, dioClient, _) => FavoritePlacesApi(dioClient.dio),
        ),

        ProxyProvider<DioClient, TagApi>(update:
            (_, dioClient, _) => TagApi(dioClient.dio),
        ),

        ProxyProvider<DioClient, RouteApi>(update:
            (_, dioClient, _) => RouteApi(dioClient.dio),
        ),

        ProxyProvider<DioClient, PhotoApi>(update:
            (_, dioClient, _) => PhotoApi(dioClient.dio),
        ),

        ProxyProvider<DioClient, UserApi>(update:
            (_, dioClient, _) => UserApi(dioClient.dio),
        ),

        ProxyProvider2<PlacesApi, FavoritePlacesApi, PlacesService>(update:
            (_, placesApi, favPlacesApi, _) => PlacesService(placesApi, favPlacesApi),
        ),

        ProxyProvider3<CategoryApi, TagApi, PlacesApi, FiltersService>(update:
            (_, categoryApi, tagApi, placesApi, _) => FiltersService(placesApi, tagApi, categoryApi),
        ),

        ProxyProvider<CategoryApi, CategoryService>(update:
            (_, categoryApi, _) => CategoryService(categoryApi),
        ),

        ProxyProvider2<LocationService, UserLocationApi, LocationTrackingManager>(update:
            (_, locationService, userLocationApi, _) =>
            LocationTrackingManager(locationService, userLocationApi),
        ),

        ProxyProvider3<LocationTrackingManager, AuthState, AppSettings, AuthStateCoordinator>(update:
            (_, locationTrackingManager, authState, appSettings, _) =>
            AuthStateCoordinator(authState, locationTrackingManager, appSettings),
        ),

        ProxyProvider3<AuthApi, AuthState, TokenStorage, AuthService>(update:
            (_, authApi, authState, tokenStorage, _) =>
            AuthService(authApi, tokenStorage, authState),
        ),

        ProxyProvider2<AppSettings, AuthService, OnboardingService>(update:
            (_, appSettings, authService, _) =>
            OnboardingService(appSettings, authService),
        ),

        ProxyProvider2<PermissionService, AppSettings, UserLocationService>(update:
            (_, permissionService, appSettings, _) =>
            UserLocationService(permissionService, appSettings),
        ),

        ProxyProvider2<PlacesApi, FavoritePlacesApi, PlaceService>(update:
            (_, placesApi, favoritePlacesApi, _) =>
            PlaceService(favoritePlacesApi, placesApi),
        ),

        ProxyProvider<FavoritePlacesApi, FavoritePlacesService>(update:
            (_, favoritePlacesApi, _) =>
            FavoritePlacesService(favoritePlacesApi),
        ),

        ProxyProvider2<RouteApi, PlacesApi, MapsService>(update:
            (_, routeApi, placesApi, _) => MapsService(routeApi, placesApi),
        ),

        ProxyProvider5<UserApi, RouteApi, PhotoApi, PlacesApi, AuthService, ProfileService>(update:
            (_, userApi, routeApi, photoApi, placesApi, authService, _) =>
                ProfileService(userApi, routeApi, photoApi, authService, placesApi),
        ),

        ChangeNotifierProxyProvider2<OnboardingService, NavigatorService, OnboardingViewModel>(
          create: (_) => OnboardingViewModel(),
          update: (_, onboardingService, navigatorService, previous) {
            previous!.updateService(onboardingService, navigatorService);
            return previous;
          },
        ),

        ChangeNotifierProxyProvider2<AuthService, NavigatorService, RegistrationViewModel>(
          create: (_) => RegistrationViewModel(),
          update: (_, authService, navigatorService, previous) {
            previous!.updateRegistrationVM(authService, navigatorService);
            return previous;
          },
        ),

        ChangeNotifierProxyProvider2<AuthService, NavigatorService, LoginViewModel>(
          create: (_) => LoginViewModel(),
          update: (_, authService, navigatorService, previous) {
            previous!.updateLoginVm(authService, navigatorService);
            return previous;
          },
        ),

        ChangeNotifierProxyProvider2<UserLocationService, AuthState, UserLocationViewModel>(
          create: (_) => UserLocationViewModel(),
          update: (_, userLocationService, authState, previous) {
            previous!.updateService(userLocationService, authState);
            return previous;
          },
        ),

        ChangeNotifierProxyProvider<CategoryService, CategoriesViewModel>(
          create: (_) => CategoriesViewModel(),
          update: (_, categoryService, previous) {
            previous!.update(categoryService);
            return previous;
          },
        ),

        ChangeNotifierProxyProvider<FiltersService, FiltersViewModel>(
          create: (_) => FiltersViewModel(),
          update: (_, filterService, previous) {
            previous!.update(filterService);
            return previous;
          },
        ),

        ChangeNotifierProxyProvider<FavoritePlacesService, FavoritePlacesViewModel>(
          create: (_) => FavoritePlacesViewModel(),
          update: (_, favPlaceService, previous) {
            previous!.update(favPlaceService);
            return previous;
          },
        ),

        ChangeNotifierProxyProvider2<PlacesService, FavoritePlacesViewModel, PlacesViewModel>(
          create: (_) => PlacesViewModel(),
          update: (_, placesService, favPlacesVm, previous) {
            previous!.update(placesService, favPlacesVm);
            return previous;
          },
        ),

        ChangeNotifierProxyProvider2<PlaceService, FavoritePlacesViewModel, PlaceViewModel>(
          create: (_) => PlaceViewModel(),
          update: (_, placeService, favPlacesVm, previous) {
            previous!.update(placeService, favPlacesVm);
            return previous;
          },
        ),

        ChangeNotifierProxyProvider<ProfileService, ProfileViewModel>(
          create: (_) => ProfileViewModel(),
          update: (_, profileService, previous) {
            previous!.update(profileService);
            return previous;
          },
        ),

        ChangeNotifierProxyProvider4<MapsService, LocationTrackingManager, LocationService, ProfileViewModel, MapsViewModel>(
          create: (_) => MapsViewModel(),
          update: (_, mapsService, locationTrackingManager, locationService, profileVm, previous) {
            previous!.update(mapsService, locationTrackingManager, locationService, profileVm);
            previous.initLocationListener();
            return previous;
          },
        ),

        ChangeNotifierProvider(
          create: (_) => NavBarProvider(),
          child: const MainScaffoldWithNavBar(),
        ),

        ChangeNotifierProvider(
            create: (_) => MapDataProvider(),
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
    final navigation = context.read<NavigatorService>();
    final authStateCoordinator = context.read<AuthStateCoordinator>();

    return MaterialApp(
      navigatorKey: navigation.navigatorKey,
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.primary,
        extendBodyBehindAppBar: true,
        body: SizedBox.expand(
          child: () {
            switch (authState.value) {
              case AuthEnum.unauthenticated:
                final vm = context.read<LoginViewModel>();
                vm.resetState();
                return const LoginScreen();
              case AuthEnum.authenticated:
                return MainScaffoldWithNavBar();
              case AuthEnum.unknown:
                return const OnboardingScreen();
              case AuthEnum.afterRegistration:
                return const UserLocationScreen();
              case AuthEnum.registration:
                return const RegistrationScreen();
            }
          } (),
        ),
      )
    );
  }
}

