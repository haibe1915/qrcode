import 'package:bloc/bloc.dart';
import 'package:qrcode/blocs/scanImage/scan_image_event.dart';
import 'package:qrcode/blocs/scanImage/scan_image_state.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/utils/image_gallery/getImage.dart';
import 'package:qrcode/utils/scan_image/addImageToDatabase.dart';
import 'package:qrcode/utils/scan_image/scan_image.dart';

class ScanImageBloc extends Bloc<ScanImageEvent, ScanImageState> {
  @override
  ScanImageBloc() : super(ScanImageNotScan()) {
    on<ScanImageScan>(_handleScanImageScan);
    on<ScanImageCapture>(_handleScanImageCapture);
  }

  void _handleScanImageScan(
      ScanImageScan event, Emitter<ScanImageState> emit) async {
    emit(ScanImageLoading());
    try {
      final imagePath = await GetImage.getImageFromGallery();
      final result = await ScanImage.scanImageFromImage(imagePath!.path);
      HistoryItem tmp = await AddImageToDb.addImage(result!);
      emit(ScanImageScaned(tmp));
    } catch (e) {
      emit(ScanImageError(e));
    }
  }

  void _handleScanImageCapture(
      ScanImageCapture event, Emitter<ScanImageState> emit) async {
    emit(ScanImageLoading());
    try {
      HistoryItem tmp = await AddImageToDb.addImage(event.str);
      emit(ScanImageScaned(tmp));
    } catch (e) {
      emit(ScanImageError(e));
    }
  }

  @override
  void onTransition(Transition<ScanImageEvent, ScanImageState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
