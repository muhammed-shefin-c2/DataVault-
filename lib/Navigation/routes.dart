
import 'package:go_router/go_router.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:technical_test/Page/create_bundle.dart';
import 'package:technical_test/Page/dashboard.dart';
import 'package:technical_test/Page/login_page.dart';
import 'package:technical_test/Page/public_page.dart';
import 'package:technical_test/Page/sign_up_page.dart';

/// A global instance of Supabase client for authentication checks.
final SupabaseClient _supabase = Supabase.instance.client;

/// Function to check if a user is authenticated.
bool _isUserAuthenticated() => _supabase.auth.currentSession != null;

/// Initializes the GoRouter for app navigation with authentication checks.
final GoRouter router = GoRouter(
  initialLocation: '/login', // Default starting route
  routes: [

    /// Route: Sign-up Page
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignUpPage(),
      redirect: (context, state) => _isUserAuthenticated() ? '/dashboard' : null,
    ),

    /// Route: Login Page
    GoRoute(
      path: '/login',
      builder: (context, state)  =>  LoginPage(),
    redirect: (context, state) => _isUserAuthenticated()? '/dashboard' : null,
    ),

    /// Route: Dashboard (Protected - Requires Authentication)
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => Dashboard(),
      redirect: (context, state) => _isUserAuthenticated() ? null : '/login',
    ),

    /// Route: Create Bundle Page (Protected - Requires Authentication)
    GoRoute(
      path: '/create-bundle',
      builder: (context, state) => CreateBundle(),
      redirect: (context, state) => _isUserAuthenticated() ? null : '/login',
    ),

    /// Route: Public Page (Accessible without authentication)
    GoRoute(
      path: '/public',
      builder: (context, state) => PublicPage(),
    ),
  ],
);