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

import 'package:qrcode/ui/pages/result/QrContact.dart';
import 'package:qrcode/ui/widget/AdNative.dart';

class ContactToQrPage extends StatefulWidget {
  const ContactToQrPage({super.key});

  @override
  State<ContactToQrPage> createState() => _ContactToQrPageState();
}

class _ContactToQrPageState extends State<ContactToQrPage> {
  final TextEditingController _firstNameEditingController =
      TextEditingController();
  final TextEditingController _surNameEditingController =
      TextEditingController();
  final TextEditingController _locationEditingController =
      TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _noteEditingController = TextEditingController();

  final TextEditingController _contactSearch = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final PhoneToQrBloc _phoneToQrBloc = PhoneToQrBloc();

  List<TextEditingController> importantField = <TextEditingController>[];

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
                    decoration: InputDecoration(
                      hintText: 'Search'.tr(),
                      prefixIcon: const Icon(Icons.search),
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
                                        List<String> contactName =
                                            contact.displayName.split(" ");
                                        return InkWell(
                                          onTap: () {
                                            _firstNameEditingController.text =
                                                contactName[0];
                                            if (contactName.length > 1) {
                                              _surNameEditingController.text =
                                                  contactName[1];
                                            }

                                            if (contact.addresses.isNotEmpty) {
                                              _locationEditingController.text =
                                                  contact.addresses
                                                      .elementAt(0)
                                                      .address;
                                            }
                                            if (contact.notes.isNotEmpty) {
                                              _noteEditingController.text =
                                                  contact.notes
                                                      .elementAt(0)
                                                      .note;
                                            }
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

  bool checkEmpty() {
    for (TextEditingController member in importantField) {
      if (member.text.trimRight().isEmpty) return false;
    }
    return true;
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
    importantField = [
      _firstNameEditingController,
      _surNameEditingController,
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('contact').tr(),
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
                var data = 'BEGIN:VCARD\n'
                    'VERSION:3.0\n'
                    'FN:${_firstNameEditingController.text.trimRight()} ${_surNameEditingController.text.trimRight()}\n'
                    'TEL:${_phoneEditingController.text.trimRight()}\n'
                    'ADR: ${_locationEditingController.text.trimRight()}\n'
                    'NOTE: ${_noteEditingController.text.trimRight()}\n'
                    'END:VCARD';
                HistoryItem tmp = HistoryItem(
                    type: 'contact', datetime: DateTime.now(), content: data);
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
                controller: _scrollController,
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.only(top: 20),
                        child: Card(
                            elevation: 4,
                            clipBehavior: Clip.hardEdge,
                            child: IntrinsicHeight(
                              child: SizedBox(
                                  width: screenWidth * 0.8,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
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
                                                    left: 10,
                                                    right: 3,
                                                    bottom: 10),
                                                child: TextField(
                                                  controller:
                                                      _firstNameEditingController,
                                                  decoration: InputDecoration(
                                                    hintText: 'name'.tr(),
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    border: InputBorder.none,
                                                  ),
                                                  maxLines: null,
                                                ),
                                              ),
                                            ),
                                            if (importantField.contains(
                                                _firstNameEditingController))
                                              const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '*',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  SizedBox(height: 40)
                                                ],
                                              )
                                          ],
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
                                                    left: 10,
                                                    right: 3,
                                                    bottom: 10),
                                                child: TextField(
                                                  controller:
                                                      _surNameEditingController,
                                                  decoration: InputDecoration(
                                                    hintText: 'surname'.tr(),
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    border: InputBorder.none,
                                                  ),
                                                  maxLines: null,
                                                ),
                                              ),
                                            ),
                                            if (importantField.contains(
                                                _surNameEditingController))
                                              const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '*',
                                                    style: TextStyle(
                                                        color: Colors.red),
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
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller:
                                                      _locationEditingController,
                                                  decoration: InputDecoration(
                                                    hintText: 'address'.tr(),
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    border: InputBorder.none,
                                                  ),
                                                  maxLines: null,
                                                ),
                                              ),
                                              if (importantField.contains(
                                                  _locationEditingController))
                                                const Text(
                                                  '*',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                            ],
                                          ),
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
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller:
                                                      _phoneEditingController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  decoration: InputDecoration(
                                                    hintText: 'phone'.tr(),
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    border: InputBorder.none,
                                                  ),
                                                  maxLines: null,
                                                ),
                                              ),
                                              if (importantField.contains(
                                                  _phoneEditingController))
                                                const Text(
                                                  '*',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                            ],
                                          ),
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
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller:
                                                      _noteEditingController,
                                                  decoration: InputDecoration(
                                                    hintText: 'note'.tr(),
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    border: InputBorder.none,
                                                  ),
                                                  maxLines: null,
                                                ),
                                              ),
                                            ],
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
                            padding: const EdgeInsets.only(top: 10),
                            child: Card(
                                color: Theme.of(context).colorScheme.primary,
                                elevation: 4,
                                child: InkWell(
                                    onTap: () {
                                      _phoneToQrBloc
                                          .add(PhoneToQrEventLoadData());
                                      _showContact();
                                    },
                                    child: Center(
                                        child: Text(
                                      'enter'.tr(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Roboto'),
                                    ))))),
                      ),
                    ),
                  ],
                ),
              ),
              //const SizedBox(height: 20),
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
