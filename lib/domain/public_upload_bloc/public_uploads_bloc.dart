// lib/domain/public_uploads/public_uploads_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:technical_test/Services/upload_service.dart';
import 'package:technical_test/domain/public_upload_bloc/public_upload_event.dart';
import 'package:technical_test/domain/public_upload_bloc/public_upload_state.dart';


class PublicUploadsBloc extends Bloc<PublicUploadsEvent, PublicUploadsState> {
  final UploadService uploadService;
  final SupabaseClient supabase = Supabase.instance.client;

  PublicUploadsBloc({required this.uploadService}) : super(const PublicUploadsInitial()) {
    on<FetchPublicUploadsEvent>(_onFetchPublicUploads);
    on<DeletePublicUploadEvent>(_onDeletePublicUpload);
    on<UploadPublicImageEvent>(_onUploadPublicImage);
  }

  Future<void> _onFetchPublicUploads(FetchPublicUploadsEvent event, Emitter<PublicUploadsState> emit) async {
    emit(const PublicUploadsLoading());
    try {
      final uploads = await uploadService.fetchUploads();
      emit(PublicUploadsLoaded(uploads));
    } catch (error) {
      emit(PublicUploadsFailure('Failed to fetch public uploads: $error'));
    }
  }

  Future<void> _onDeletePublicUpload(DeletePublicUploadEvent event, Emitter<PublicUploadsState> emit) async {
    emit(const PublicUploadsLoading());
    try {
      await supabase.from('bundle').delete().eq('id', event.id);
      final fileName = event.mediaUrl.split('/').last;
      await supabase.storage.from('public-uploads').remove([fileName]);
      final uploads = await uploadService.fetchUploads();
      emit(PublicUploadsLoaded(uploads));
    } catch (error) {
      emit(PublicUploadsFailure('Failed to delete public upload: $error'));
    }
  }

  Future<void> _onUploadPublicImage(UploadPublicImageEvent event, Emitter<PublicUploadsState> emit) async {
    emit(const PublicUploadsLoading());
    try {
      await supabase.storage.from('public-uploads').upload(event.fileName, event.media);
      final mediaUrl = supabase.storage.from('public-uploads').getPublicUrl(event.fileName);
      await uploadService.uploadData(mediaUrl, event.price);
      final uploads = await uploadService.fetchUploads();
      emit(PublicUploadsLoaded(uploads));
    } catch (error) {
      emit(PublicUploadsFailure('Failed to upload image: $error'));
    }
  }
}