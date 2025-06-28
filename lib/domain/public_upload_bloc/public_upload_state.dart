// lib/domain/public_uploads/public_uploads_state.dart
import 'package:equatable/equatable.dart';
import 'package:technical_test/domain/entities/bundle_entity.dart';

abstract class PublicUploadsState extends Equatable {
  const PublicUploadsState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PublicUploadsInitial extends PublicUploadsState {
  const PublicUploadsInitial();
}

class PublicUploadsLoading extends PublicUploadsState {
  const PublicUploadsLoading();
}

class PublicUploadsLoaded extends PublicUploadsState {
  final List<BundleEntity> uploads;

  const PublicUploadsLoaded(this.uploads);

  @override
  // TODO: implement props
  List<Object?> get props => [uploads];
}

class PublicUploadsFailure extends PublicUploadsState {
  final String error;

  const PublicUploadsFailure(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}