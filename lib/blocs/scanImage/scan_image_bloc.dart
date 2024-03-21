import 'package:bloc/bloc.dart';
import 'package:qrcode/blocs/scanImage/scan_image_event.dart';
import 'package:qrcode/blocs/scanImage/scan_image_state.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/utils/Ads/firebase.dart';
import 'package:qrcode/utils/image_gallery/getImage.dart';
import 'package:qrcode/utils/scan_image/addImageToDatabase.dart';
import 'package:qrcode/utils/scan_image/scan_image.dart';

class ScanImageBloc extends Bloc<ScanImageEvent, ScanImageState> {
  @override
  ScanImageBloc() : super(ScanImageNotScan()) {
    on<ScanImageScan>(_handleScanImageScan);
    on<ScanImageCapture>(_handleScanImageCapture);
    on<ScanImageEndError>(_handleCloseErrorDialog);
  }

  void _handleScanImageScan(
      ScanImageScan event, Emitter<ScanImageState> emit) async {
    emit(ScanImageLoading());
    if (!StaticVariable.premiumState) {
      await StaticVariable.rewardedAd
          .populateRewardedAd(adUnitId: StaticVariable.adRewarded);
    }
    try {
      final imagePath = await GetImage.getImageFromGallery();
      final result = await ScanImage.scanImageFromImage(imagePath!.path);
      logEvent(name: 'get_gallery_image_success', parameters: {});
      HistoryItem tmp = await AddImageToDb.addImage(result!);
      emit(ScanImageScaned(tmp));
    } catch (e) {
      emit(ScanImageError(e));
    }
  }

  void _handleScanImageCapture(
      ScanImageCapture event, Emitter<ScanImageState> emit) async {
    emit(ScanImageLoading());
    if (!StaticVariable.premiumState) {
      await StaticVariable.rewardedAd
          .populateRewardedAd(adUnitId: StaticVariable.adRewarded);
    }
    try {
      HistoryItem tmp = await AddImageToDb.addImage(event.str);
      emit(ScanImageScaned(tmp));
    } catch (e) {
      emit(ScanImageError(e));
    }
  }

  void _handleCloseErrorDialog(
      ScanImageEndError event, Emitter<ScanImageState> emit) async {
    emit(ScanImageNotScan());
  }

  @override
  void onTransition(Transition<ScanImageEvent, ScanImageState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
