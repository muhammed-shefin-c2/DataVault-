import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:technical_test/domain/upload_bloc/uploads_event.dart';
import '../domain/upload_bloc/uploads_bloc.dart';
import '../domain/upload_bloc/uploads_state.dart';

class CreateBundle extends StatefulWidget {
  const CreateBundle({super.key});

  @override
  _CreateBundleState createState() => _CreateBundleState();
}

class _CreateBundleState extends State<CreateBundle> {
  final TextEditingController priceController = TextEditingController();
  File? media; // Stores selected image file
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      media = File(pickedFile.path);
    });
  }

  /// Triggers the upload via UploadsBloc
  void _uploadData(BuildContext context) {
    if (priceController.text.isEmpty || media == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields and pick an image")),
      );
      return;
    }

    if (Supabase.instance.client.auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in to upload")),
      );
      return;
    }

    final fileName = 'media_${DateTime.now().millisecondsSinceEpoch}.jpg';
    context.read<UploadsBloc>().add(UploadingEvent(fileName: fileName, media: media!, price: priceController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Create Bundle", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: BlocListener<UploadsBloc, UploadsState>(
        listener: (context, state) {
          if (state is UploadsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Upload successful"), backgroundColor: Colors.green),
            );
            priceController.clear();
            setState(() => media = null);
            context.go('/dashboard');
          } else if (state is UploadsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}"), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<UploadsBloc, UploadsState>(
          builder: (context, state) {
            final isLoading = state is UploadsLoading;
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Price Input Field
                    TextField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: "Price",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),

                    // Display Selected Image
                    media != null
                        ? Image.file(media!, height: 250, width: double.infinity, fit: BoxFit.cover)
                        : const Text("No Image Selected", style: TextStyle(color: Colors.black)),
                    const SizedBox(height: 20),

                    // Pick Image Button
                    ElevatedButton.icon(
                      onPressed: _pickImage, // Fixed reference
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      icon: const Icon(Icons.image, color: Colors.white),
                      label: const Text("Pick Image", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 10),

                    // Upload Button
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : () => _uploadData(context), // Fixed reference
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      icon: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(Icons.upload, color: Colors.white),
                      label: const Text("Upload", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 20),

                    // Navigation Buttons
                    ElevatedButton(
                      onPressed: () => context.go('/public'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Public Page", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => context.go('/dashboard'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Dashboard", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
