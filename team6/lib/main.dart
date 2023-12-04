import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team6/add_cvs.dart';
import 'package:team6/cvs_page.dart';
import 'package:team6/login_page.dart';
import 'package:team6/map_page.dart';
import 'package:team6/profile.dart';
import 'package:team6/shared_widgets.dart';

import 'sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

final GoRouter _router = GoRouter(
  initialLocation: "/",
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/SignUp',
      builder: (context, state) {
        return const SignUpPage();
      },
    ),
    GoRoute(
      path: '/CVS',
      builder: (context, state) {
        return const CVSPage();
      },
    ),
    GoRoute(
      path: '/CVSList',
      builder: (context, state) {
        return const CVSListPage();
      },
    ),
    GoRoute(
      path: '/Map',
      builder: (context, state) {
        return const MapPage();
      },
    ),
    GoRoute(
      path: '/AddCVS',
      builder: (context, state) {
        return const AddCVSPage();
      },
    ),
    GoRoute(
      path: '/Profile',
      builder: (context, state) {
        return const ProfilePage();
      },
    ),
    GoRoute(
      path: '/OwnerProfile',
      builder: (context, state) {
        return const OwnerProfile();
      },
    ),
    GoRoute(
      path: '/Waiting',
      builder: (context, state) {
        return const WaitingPage();
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: color1,
          primary: color5,
          secondary: color3,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
