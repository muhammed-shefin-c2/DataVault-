// lib/domain/my_uploads/my_uploads_event.dart
import 'package:equatable/equatable.dart';

abstract class MyUploadsEvent extends Equatable{
  const MyUploadsEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchMyUploadsEvent extends MyUploadsEvent {
  const FetchMyUploadsEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DeleteUploadEvent extends MyUploadsEvent {
  final String id;
  final String mediaUrl;

  const DeleteUploadEvent({required this.id, required this.mediaUrl});

  @override
  // TODO: implement props
  List<Object?> get props => [id, mediaUrl];
}