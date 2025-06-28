// lib/domain/my_uploads/my_uploads_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:technical_test/Services/upload_service.dart';
import 'my_upload_event.dart';
import 'my_upload_state.dart';

class MyUploadsBloc extends Bloc<MyUploadsEvent, MyUploadsState> {
  final UploadService uploadService;
  final SupabaseClient supabase = Supabase.instance.client;

  MyUploadsBloc({required this.uploadService}) : super(const MyUploadsInitial()) {
    on<FetchMyUploadsEvent>(_onFetchMyUploads);
    on<DeleteUploadEvent>(_onDeleteUpload);
  }

  Future<void> _onFetchMyUploads(FetchMyUploadsEvent event, Emitter<MyUploadsState> emit) async {
    emit(const MyUploadsLoading());
    try {
      final uploads = await uploadService.fetchMyUploads();
      emit(MyUploadsLoaded(uploads));
    } catch (error) {
      emit(MyUploadsFailure('Failed to fetch uploads: $error'));
    }
  }

  Future<void> _onDeleteUpload(DeleteUploadEvent event, Emitter<MyUploadsState> emit) async {
    emit(const MyUploadsLoading());
    try {
      await supabase.from('bundle').delete().eq('id', event.id);
      final fileName = event.mediaUrl.split('/').last;
      await supabase.storage.from('public-uploads').remove([fileName]);
      final uploads = await uploadService.fetchMyUploads();
      emit(MyUploadsLoaded(uploads));
    } catch (error) {
      emit(MyUploadsFailure('Failed to delete upload: $error'));
    }
  }
}