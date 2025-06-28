// lib/Page/dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/my_upload_bloc/my_upload_event.dart';
import '../domain/my_upload_bloc/my_upload_state.dart';
import '../domain/my_upload_bloc/my_uploads_bloc.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();
      context.go('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trigger initial fetch if not already triggered
    context.read<MyUploadsBloc>().add(const FetchMyUploadsEvent());

    return Scaffold(
      backgroundColor: Colors.pink,
      appBar: AppBar(
        title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: BlocListener<MyUploadsBloc, MyUploadsState>(
        listener: (context, state) {
          if (state is MyUploadsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<MyUploadsBloc, MyUploadsState>(
          builder: (context, state) {
            if (state is MyUploadsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MyUploadsLoaded) {
              if (state.uploads.isEmpty) {
                return const Center(
                  child: Text('No uploads yet', style: TextStyle(color: Colors.white)),
                );
              }
              return ListView.builder(
                itemCount: state.uploads.length,
                itemBuilder: (context, index) {
                  final upload = state.uploads[index];
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      color: Colors.black,
                      child: SizedBox(
                        height: 300,
                        child: ListTile(
                          subtitle: Padding(
                            padding: const EdgeInsets.only(right: 0.0, left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Image.network(
                                  upload.media,
                                  width: 500,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.image_not_supported, color: Colors.white);
                                  },
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Price: \$${upload.price}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'UUID: ${upload.id}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 0),
                                    IconButton(
                                      onPressed: () => context.read<MyUploadsBloc>().add(
                                            DeleteUploadEvent(id: upload.id, mediaUrl: upload.media),
                                          ),
                                      icon: const Icon(Icons.delete, color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink(); // Fallback for initial state
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/create-bundle'),
        backgroundColor: Colors.grey,
        child: const Icon(Icons.create_new_folder_outlined, size: 35, color: Colors.black),
      ),
    );
  }
}