import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:technical_test/Page/create_bundle.dart';
import 'package:technical_test/Page/login_page.dart';

/// `AuthGate` handles authentication state changes and redirects
/// users to the appropriate page based on their session status.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Show a loading indicator while waiting for the authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Get the current authentication session
        final session = snapshot.data?.session;

        // If a session exists, navigate to the CreateBundle page
        if (session != null) {
          return const CreateBundle();
        }

        // Otherwise, navigate to the LoginPage
        return  LoginPage();
      },
    );
  }
}
