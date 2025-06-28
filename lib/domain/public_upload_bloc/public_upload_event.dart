import "dart:io";

import "package:equatable/equatable.dart";
// lib/domain/public_uploads/public_uploads_event.dart
abstract class PublicUploadsEvent extends Equatable{
  const PublicUploadsEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchPublicUploadsEvent extends PublicUploadsEvent {
  const FetchPublicUploadsEvent();
}

class DeletePublicUploadEvent extends PublicUploadsEvent {
  final String id;
  final String mediaUrl;

  const DeletePublicUploadEvent({required this.id, required this.mediaUrl});

  @override
  // TODO: implement props
  List<Object?> get props => [id, mediaUrl];
}

class UploadPublicImageEvent extends PublicUploadsEvent {
  final String fileName;
  final File media;
  final String price;

  const UploadPublicImageEvent({
    required this.fileName,
    required this.media,
    required this.price,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [fileName, media, price];
}