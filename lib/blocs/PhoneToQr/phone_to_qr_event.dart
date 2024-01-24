import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/contact.dart';

class PhoneToQrEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PhoneToQrEventLoadData extends PhoneToQrEvent {}

class PhoneToQrEventSearch extends PhoneToQrEvent {
  final String str;
  final List<Contact> contacts;
  PhoneToQrEventSearch({required this.str, required this.contacts});
}
