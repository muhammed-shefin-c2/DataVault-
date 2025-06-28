// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:technical_test/Navigation/routes.dart';
import 'package:technical_test/Services/auth_service.dart';
import 'package:technical_test/Services/upload_service.dart';
import 'package:technical_test/domain/auths_bloc/auth_bloc.dart';
import 'package:technical_test/domain/auths_bloc/auth_event.dart';
import 'package:technical_test/domain/my_upload_bloc/my_uploads_bloc.dart';
import 'domain/public_upload_bloc/public_uploads_bloc.dart';
import 'domain/upload_bloc/uploads_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://jemcvlckhanaihsigrlu.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImplbWN2bGNraGFuYWloc2lncmx1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI0Mjg3MTcsImV4cCI6MjA1ODAwNDcxN30.8D-9cSQdCxyVNQp_BQy5Gs78ijFS_plKq4p4xEvKnu4",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(authService: AuthService())..add(AppStartEvent())),
        BlocProvider(create: (context) => UploadsBloc(uploadService: UploadService())),
        BlocProvider(create: (context) => MyUploadsBloc(uploadService: UploadService())),
        BlocProvider(create: (context) => PublicUploadsBloc(uploadService: UploadService())),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Supabase',
      ),
    );
  }
}