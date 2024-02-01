import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/blocs/PhoneToQr/phone_to_qr_bloc.dart';
import 'package:qrcode/blocs/PhoneToQr/phone_to_qr_event.dart';
import 'package:qrcode/blocs/PhoneToQr/phone_to_qr_state.dart';
import 'package:qrcode/ui/pages/convert/convert_function/TextToQR.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrcode/ui/pages/result/QrSms.dart';
import 'package:qrcode/ui/pages/result/QrText.dart';

class SmsToQrPage extends StatefulWidget {
  const SmsToQrPage({super.key});

  @override
  State<SmsToQrPage> createState() => _SmsToQrPageState();
}

class _SmsToQrPageState extends State<SmsToQrPage> {
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _contactSearch = TextEditingController();

  PhoneToQrBloc _phoneToQrBloc = PhoneToQrBloc();
  TextEditingController _textEditingController = TextEditingController();
  StreamController<int> _textLengthStream = StreamController<int>();

  @override
  void dispose() {
    _textEditingController.dispose();
    _textLengthStream.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textLengthStream.sink.add(1000);
    _textEditingController.addListener(() {
      _textLengthStream.sink.add(1000 - _textEditingController.text.length);
    });
  }

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
                                            _nameEditingController.text =
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
                                            _nameEditingController.text =
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

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('Tin nhắn'),
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
                var data =
                    'sms:${_nameEditingController.text}?body=${Uri.encodeQueryComponent(_textEditingController.text)}';
                HistoryItem tmp = HistoryItem(
                    type: 'tin nhắn', datetime: DateTime.now(), content: data);
                StaticVariable.createdController.add(tmp);
                StaticVariable.conn.insertCreated(tmp);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QrSmsPage(
                            historyItem: tmp,
                          )),
                );
                _nameEditingController.clear();
                _textEditingController.clear();
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
                    child: Container(
                        height: screenHeight * 0.4,
                        width: screenWidth * 0.8,
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _nameEditingController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                        hintText: 'Đến',
                                        contentPadding: EdgeInsets.all(10),
                                        border: InputBorder.none,
                                      ),
                                      maxLines: null,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _phoneToQrBloc
                                            .add(PhoneToQrEventLoadData());
                                        _showContact();
                                      },
                                      icon: Icon(Icons.add))
                                ],
                              ),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  StreamBuilder<int>(
                                    stream: _textLengthStream.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data.toString());
                                      } else {
                                        return Text('');
                                      }
                                    },
                                  ),
                                ]),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: TextField(
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Văn bản',
                                  contentPadding: EdgeInsets.all(10),
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                              ),
                            ))
                          ],
                        )))),
          ],
        ));
  }
}
