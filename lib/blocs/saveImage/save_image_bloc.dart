import 'package:bloc/bloc.dart';
import 'package:qrcode/blocs/saveImage/save_image_event.dart';
import 'package:qrcode/blocs/saveImage/save_image_state.dart';

class SaveImageBloc extends Bloc<SaveImageEvent, SaveImageState> {
  SaveImageBloc() : super(SaveImageNotSave()) {
    on<SaveImageSaveEvent>(_handleSaveImage);
  }

  void _handleSaveImage(SaveImageEvent event, Emitter<SaveImageState> emit) {
    emit(SaveImageLoading());
  }
}
