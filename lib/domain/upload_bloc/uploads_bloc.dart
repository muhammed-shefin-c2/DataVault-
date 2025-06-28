import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:technical_test/Services/upload_service.dart';
import 'package:technical_test/domain/upload_bloc/uploads_event.dart';
import 'package:technical_test/domain/upload_bloc/uploads_state.dart';


class UploadsBloc extends Bloc<UploadsEvent, UploadsState> {
  final UploadService uploadService;
  final SupabaseClient supabase = Supabase.instance.client;

  UploadsBloc({required this.uploadService}) : super(UploadsInitial()) {
    on<UploadingEvent>(_onUploadData);
  }

  Future<void> _onUploadData(UploadingEvent event, Emitter<UploadsState> emit) async {
    emit(UploadsLoading());
    try {
      // Upload file to Supabase Storage
      await supabase.storage.from('public-uploads').upload(event.fileName, event.media);
      final mediaUrl = supabase.storage.from('public-uploads').getPublicUrl(event.fileName);

      // Insert record into database using UploadService
      await uploadService.uploadData(mediaUrl, event.price);

      emit(UploadsSuccess());
    } catch (error) {
      emit(UploadsFailure('Failed to upload data: $error'));
    }
  }
}