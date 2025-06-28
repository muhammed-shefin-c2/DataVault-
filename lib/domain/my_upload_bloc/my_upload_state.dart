// lib/domain/my_uploads/my_uploads_state.dart
import 'package:equatable/equatable.dart';
import 'package:technical_test/domain/entities/bundle_entity.dart';

abstract class MyUploadsState extends Equatable {
  const MyUploadsState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MyUploadsInitial extends MyUploadsState {
  const MyUploadsInitial();
}

class MyUploadsLoading extends MyUploadsState {
  const MyUploadsLoading();
}

class MyUploadsLoaded extends MyUploadsState {
  final List<BundleEntity> uploads;
  MyUploadsLoaded(this.uploads);

  @override
  // TODO: implement props
  List<Object?> get props => [uploads];
}


class MyUploadsFailure extends MyUploadsState {
  final String error;

  const MyUploadsFailure(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
