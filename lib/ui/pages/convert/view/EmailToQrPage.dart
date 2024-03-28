import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/blocs/PhoneToQr/phone_to_qr_bloc.dart';
import 'package:qrcode/blocs/PhoneToQr/phone_to_qr_event.dart';
import 'package:qrcode/blocs/PhoneToQr/phone_to_qr_state.dart';
import 'package:flutter/services.dart';
import 'package:qrcode/ui/pages/result/QrEmail.dart';
import 'package:qrcode/ui/widget/AdNative.dart';

class EmailToQrPage extends StatefulWidget {
  const EmailToQrPage({super.key});

  @override
  State<EmailToQrPage> createState() => _EmailToQrPageState();
}

class _EmailToQrPageState extends State<EmailToQrPage> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _contactSearch = TextEditingController();
  final TextEditingController _descriptionEditingController =
      TextEditingController();

  final PhoneToQrBloc _phoneToQrBloc = PhoneToQrBloc();
  final TextEditingController _textEditingController = TextEditingController();
  final StreamController<int> _textLengthStream = StreamController<int>();
  List<TextEditingController> importantField = <TextEditingController>[];

  bool checkEmpty() {
    for (TextEditingController member in importantField) {
      if (member.text.trimRight().isEmpty) return false;
    }
    return true;
  }

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
    importantField = [
      _nameEditingController,
    ];
  }

  void _showContact() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return BlocProvider<PhoneToQrBloc>(
            create: (context) => _phoneToQrBloc,
            child: SizedBox(
              height: 0.8 * MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  TextField(
                    controller: _contactSearch,
                    onChanged: (value) {},
                    decoration: const InputDecoration(
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
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
                                                contact.emails.isEmpty
                                                    ? ""
                                                    : contact.emails
                                                        .elementAt(0)
                                                        .address;
                                            Navigator.pop(context);
                                          },
                                          child: ListTile(
                                            title: Text(contact.displayName),
                                            subtitle: Text(
                                                contact.emails.isEmpty
                                                    ? ""
                                                    : contact.emails
                                                        .elementAt(0)
                                                        .address),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ));
                        } else if (state is PhoneToQrStateSearch) {
                          return Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
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
                                                contact.emails.isEmpty
                                                    ? ""
                                                    : contact.emails
                                                        .elementAt(0)
                                                        .address;
                                            Navigator.pop(context);
                                          },
                                          child: ListTile(
                                            title: Text(contact.displayName),
                                            subtitle: Text(
                                                contact.emails.isEmpty
                                                    ? ""
                                                    : contact.emails
                                                        .elementAt(0)
                                                        .address),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ));
                        } else if (state is PhoneToQrStateLoading) {
                          return SizedBox(
                              height: 0.8 * MediaQuery.of(context).size.height,
                              child: const Center(
                                  child: CircularProgressIndicator()));
                        } else if (state is PhoneToQrStateError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
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
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('email').tr(),
        actions: [
          IconButton(
            padding:
                const EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 10),
            alignment: Alignment.bottomLeft,
            icon: const Icon(
              Icons.check,
              size: 24,
              color: Colors.white,
            ),
            onPressed: () {
              if (checkEmpty()) {
                var data =
                    'mailto:${_nameEditingController.text.trimRight()}?subject=${Uri.encodeQueryComponent(_descriptionEditingController.text.trimRight())}&body=${Uri.encodeQueryComponent(_textEditingController.text.trimRight())}';
                HistoryItem tmp = HistoryItem(
                    type: 'email', datetime: DateTime.now(), content: data);
                StaticVariable.createdController.add(tmp);
                StaticVariable.conn.insertCreated(tmp);
                _nameEditingController.clear();
                _descriptionEditingController.clear();
                _textEditingController.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QrEmailPage(
                            historyItem: tmp,
                          )),
                );
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: SizedBox(
                          width: 200, // Adjust the width as needed
                          height: 50, // Adjust the height as needed
                          child: Center(
                            child: const Text("required_field_is_empty").tr(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('close').tr(),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9),
          child: Column(
            children: [
              SingleChildScrollView(
                child: Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(top: 20),
                    child: Card(
                        elevation: 4,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                            height: screenHeight * 0.4,
                            width: screenWidth * 0.8,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 3, bottom: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    _nameEditingController,
                                                decoration: InputDecoration(
                                                  hintText: 'email'.tr(),
                                                  contentPadding:
                                                      const EdgeInsets.all(10),
                                                  border: InputBorder.none,
                                                ),
                                                maxLines: null,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  _phoneToQrBloc.add(
                                                      PhoneToQrEventLoadData());
                                                  _showContact();
                                                },
                                                icon: const Icon(Icons.add))
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (importantField
                                        .contains(_nameEditingController))
                                      const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '*',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          SizedBox(height: 40)
                                        ],
                                      )
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: TextField(
                                    controller: _descriptionEditingController,
                                    decoration: InputDecoration(
                                      hintText: 'subject'.tr(),
                                      contentPadding: const EdgeInsets.all(10),
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      StreamBuilder<int>(
                                        stream: _textLengthStream.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                                snapshot.data.toString());
                                          } else {
                                            return const Text('');
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      )
                                    ]),
                                Expanded(
                                    child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: TextField(
                                    controller: _textEditingController,
                                    decoration: InputDecoration(
                                      hintText: 'message'.tr(),
                                      contentPadding: const EdgeInsets.all(10),
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null,
                                  ),
                                )),
                              ],
                            )))),
              ),
              const SizedBox(height: 20),
              Center(
                child: Provider(
                    create: (_) => AdsBloc(),
                    builder: (context, child) {
                      return AdNative(
                        tempType: TemplateType.medium,
                        width: MediaQuery.of(context).size.width,
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
