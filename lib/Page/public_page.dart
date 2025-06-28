// lib/Page/public_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../domain/public_upload_bloc/public_upload_event.dart';
import '../domain/public_upload_bloc/public_upload_state.dart';
import '../domain/public_upload_bloc/public_uploads_bloc.dart';

class PublicPage extends StatelessWidget {
  const PublicPage({super.key});

  Future<void> _uploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final fileName = 'media_${DateTime.now().millisecondsSinceEpoch}.jpg';
    context.read<PublicUploadsBloc>().add(
          UploadPublicImageEvent(fileName: fileName, media: file, price: '10.99'),
        );
  }

  @override
  Widget build(BuildContext context) {
    // Trigger initial fetch
    context.read<PublicUploadsBloc>().add(const FetchPublicUploadsEvent());

    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        title: const Text("Public Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard, color: Colors.white),
            onPressed: () => context.go('/dashboard'),
            tooltip: 'Back to Dashboard',
          ),
        ],
      ),
      body: BlocListener<PublicUploadsBloc, PublicUploadsState>(
        listener: (context, state) {
          if (state is PublicUploadsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<PublicUploadsBloc, PublicUploadsState>(
          builder: (context, state) {
            if (state is PublicUploadsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PublicUploadsLoaded) {
              if (state.uploads.isEmpty) {
                return const Center(
                  child: Text('No uploads available', style: TextStyle(color: Colors.white)),
                );
              }
              return ListView.builder(
                itemCount: state.uploads.length,
                itemBuilder: (context, index) {
                  final upload = state.uploads[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.black,
                      child: Column(
                        children: [
                          Image.network(
                            upload.media,
                            width: 500,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported, color: Colors.white);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
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
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () => context.read<PublicUploadsBloc>().add(
                                          DeletePublicUploadEvent(id: upload.id, mediaUrl: upload.media),
                                        ),
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
        onPressed: () => _uploadImage(context),
        child: const Icon(Icons.upload, color: Colors.black),
        backgroundColor: Colors.grey,
      ),
    );
  }
}