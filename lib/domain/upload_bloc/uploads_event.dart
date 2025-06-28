import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:technical_test/domain/entities/bundle_entity.dart';

abstract class UploadsEvent extends Equatable {
  UploadsEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UploadingEvent extends UploadsEvent {
  final String fileName;
  final File media;
  final String price;

  UploadingEvent({
    required this.fileName,
    required this.media,
    required this.price,});

  @override
  // TODO: implement props
  List<Object?> get props => [fileName, media, price];
}