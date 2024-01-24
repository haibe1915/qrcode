import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/qr/view/pages/convert/bloc/PhoneToQr/phone_to_qr_bloc.dart';
import 'package:qrcode/qr/view/pages/convert/bloc/PhoneToQr/phone_to_qr_event.dart';
import 'package:qrcode/qr/view/pages/convert/bloc/PhoneToQr/phone_to_qr_state.dart';
import 'package:qrcode/qr/view/pages/convert/convert_function/TextToQR.dart';
import 'package:flutter/services.dart';
import 'package:qrcode/qr/view/pages/convert/convert_function/contact/getContact.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

import 'dart:async';

import 'package:qrcode/qr/view/pages/result/QrContact.dart';

class ContactToQrPage extends StatefulWidget {
  const ContactToQrPage({super.key});

  @override
  State<ContactToQrPage> createState() => _ContactToQrPageState();
}

class _ContactToQrPageState extends State<ContactToQrPage> {
  TextEditingController _firstNameEditingController = TextEditingController();
  TextEditingController _surNameEditingController = TextEditingController();
  TextEditingController _locationEditingController = TextEditingController();
  TextEditingController _phoneEditingController = TextEditingController();
  TextEditingController _noteEditingController = TextEditingController();

  TextEditingController _contactSearch = TextEditingController();

  ScrollController _scrollController = new ScrollController();

  PhoneToQrBloc _phoneToQrBloc = PhoneToQrBloc();

  void _showContact() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return BlocProvider<PhoneToQrBloc>(
            create: (context) => _phoneToQrBloc,
            child: Container(
              height: 0.8 * MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  TextField(
                    controller: _contactSearch,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<PhoneToQrBloc, PhoneToQrState>(
                      bloc: _phoneToQrBloc,
                      builder: (context, state) {
                        if (state is PhoneToQrStateLoaded) {
                          _contactSearch.addListener(() {
                            _phoneToQrBloc.add(PhoneToQrEventSearch(
                                str: _contactSearch.text,
                                contacts: state.contacts));
                          });
                          return Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  Flexible(
                                    child: ListView.builder(
                                      itemCount: state.contacts.length,
                                      itemBuilder: (context, index) {
                                        Contact contact = state.contacts[index];
                                        return InkWell(
                                          onTap: () {
                                            _firstNameEditingController.text =
                                                contact.displayName;
                                            _phoneEditingController.text =
                                                contact.phones
                                                    .elementAt(0)
                                                    .number;
                                            Navigator.pop(context);
                                          },
                                          child: ListTile(
                                            title: Text(contact.displayName),
                                            subtitle: Text(contact.phones
                                                .elementAt(0)
                                                .number),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ));
                        } else if (state is PhoneToQrStateSearch) {
                          return Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  Flexible(
                                    child: ListView.builder(
                                      itemCount: state.contacts.length,
                                      itemBuilder: (context, index) {
                                        Contact contact = state.contacts[index];
                                        return InkWell(
                                          onTap: () {
                                            _firstNameEditingController.text =
                                                contact.displayName;
                                            _phoneEditingController.text =
                                                contact.phones
                                                    .elementAt(0)
                                                    .number;
                                            Navigator.pop(context);
                                          },
                                          child: ListTile(
                                            title: Text(contact.displayName),
                                            subtitle: Text(contact.phones
                                                .elementAt(0)
                                                .number),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ));
                        } else if (state is PhoneToQrStateLoading) {
                          return Container(
                              height: 0.8 * MediaQuery.of(context).size.height,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        } else if (state is PhoneToQrStateError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return Container(
                            height: 0.8 * MediaQuery.of(context).size.height);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    _firstNameEditingController.dispose();
    _locationEditingController.dispose();
    _surNameEditingController.dispose();
    _phoneEditingController.dispose();
    _noteEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text('Liên hệ'),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(
                  left: 10, top: 20, bottom: 20, right: 10),
              alignment: Alignment.bottomLeft,
              icon: const Icon(
                Icons.check,
                size: 24,
                color: Colors.white,
              ),
              onPressed: () {
                var data = 'BEGIN:VCARD\n'
                    'VERSION:3.0\n'
                    'FN:${_firstNameEditingController.text}\n'
                    'TEL:${_phoneEditingController.text}\n'
                    'END:VCARD';
                HistoryItem tmp = HistoryItem(
                    type: 'liên hệ ', datetime: DateTime.now(), content: data);
                StaticVariable.createdController.add(tmp);
                StaticVariable.conn.insertCreated(tmp);
                _firstNameEditingController.clear();
                _locationEditingController.clear();
                _surNameEditingController.clear();
                _phoneEditingController.clear();
                _noteEditingController.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QrContactPage(
                            historyItem: tmp,
                          )),
                );
              },
            )
          ],
        ),
        body: Column(
          children: [
            Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 20),
                child: Card(
                    elevation: 4,
                    clipBehavior: Clip.hardEdge,
                    child: IntrinsicHeight(
                      child: Container(
                          width: screenWidth * 0.8,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: TextField(
                                    controller: _firstNameEditingController,
                                    decoration: InputDecoration(
                                      hintText: 'Tên',
                                      contentPadding: EdgeInsets.all(10),
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: TextField(
                                    controller: _surNameEditingController,
                                    decoration: InputDecoration(
                                      hintText: 'Họ',
                                      contentPadding: EdgeInsets.all(10),
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: TextField(
                                    controller: _locationEditingController,
                                    decoration: InputDecoration(
                                      hintText: 'Địa chỉ',
                                      contentPadding: EdgeInsets.all(10),
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: TextField(
                                    controller: _phoneEditingController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'Nhập số điện thoại của bạn',
                                      contentPadding: EdgeInsets.all(10),
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: TextField(
                                    controller: _noteEditingController,
                                    decoration: InputDecoration(
                                      hintText: 'Ghi chú',
                                      contentPadding: EdgeInsets.all(10),
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ))),
            Center(
              child: Center(
                child: Container(
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.4,
                    padding: EdgeInsets.only(top: 10),
                    child: Card(
                        elevation: 4,
                        child: InkWell(
                            onTap: () {
                              _phoneToQrBloc.add(PhoneToQrEventLoadData());
                              _showContact();
                            },
                            child: Center(child: Text('Nhập'))))),
              ),
            )
          ],
        ));
  }
}
