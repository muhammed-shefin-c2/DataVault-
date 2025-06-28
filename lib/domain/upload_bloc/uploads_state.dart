abstract class UploadsState {

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class UploadsInitial extends UploadsState {
  UploadsInitial();
}

class UploadsLoading extends UploadsState {
  UploadsLoading();
}

class UploadsSuccess extends UploadsState {
  UploadsSuccess();
}

class UploadsFailure extends UploadsState {
  final String error;
  UploadsFailure(this.error);
}