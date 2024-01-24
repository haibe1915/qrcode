import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class PhoneToQrState extends Equatable {
  @override
  List<Object> get props => [];
}

class PhoneToQrStateNotLoaded extends PhoneToQrState {}

class PhoneToQrStateLoading extends PhoneToQrState {}

class PhoneToQrStateLoaded extends PhoneToQrState {
  final List<Contact> contacts;
  PhoneToQrStateLoaded(this.contacts);
}

class PhoneToQrStateSearch extends PhoneToQrState {
  final List<Contact> contacts;
  PhoneToQrStateSearch(this.contacts);
}

class PhoneToQrStateError extends PhoneToQrState {
  final message;
  PhoneToQrStateError(this.message);
}
