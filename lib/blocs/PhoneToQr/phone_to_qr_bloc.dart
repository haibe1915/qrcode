import 'package:bloc/bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:qrcode/blocs/PhoneToQr/phone_to_qr_event.dart';
import 'package:qrcode/blocs/PhoneToQr/phone_to_qr_state.dart';
import 'package:qrcode/repositories/contact/getContact.dart';
import 'package:qrcode/repositories/history_function/search.dart';

class PhoneToQrBloc extends Bloc<PhoneToQrEvent, PhoneToQrState> {
  PhoneToQrBloc() : super(PhoneToQrStateNotLoaded()) {
    on<PhoneToQrEventLoadData>(_handlePhoneToQrEventLoadData);
    on<PhoneToQrEventSearch>(_handlePhoneToQrEventSearch);
  }

  List<Contact> contacts = [];
  GetContact _getContact = GetContact();
  Search _search = Search();

  void _handlePhoneToQrEventLoadData(
      PhoneToQrEvent event, Emitter<PhoneToQrState> emit) async {
    emit(PhoneToQrStateLoading());
    try {
      contacts = await _getContact.getAllContact();
      emit(PhoneToQrStateLoaded(contacts));
    } catch (e) {
      emit(PhoneToQrStateError(e.toString()));
    }
  }

  void _handlePhoneToQrEventSearch(
      PhoneToQrEventSearch event, Emitter<PhoneToQrState> emit) async {
    if (event.str.isEmpty) {
      emit(PhoneToQrStateLoaded(contacts));
    } else {
      emit(PhoneToQrStateLoading());
      try {
        List<Contact> searchResult =
            _search.searchContact(event.str, event.contacts);
        emit(PhoneToQrStateSearch(searchResult));
      } catch (e) {
        emit(PhoneToQrStateError(e.toString()));
      }
    }
  }

  @override
  void onTransition(Transition<PhoneToQrEvent, PhoneToQrState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
