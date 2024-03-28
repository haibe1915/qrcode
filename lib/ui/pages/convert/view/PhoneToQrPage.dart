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
import 'package:qrcode/ui/pages/result/QrPhone.dart';
import 'package:qrcode/ui/widget/AdNative.dart';

class PhoneToQrPage extends StatefulWidget {
  const PhoneToQrPage({super.key});

  @override
  State<PhoneToQrPage> createState() => _PhoneToQrPageState();
}

class _PhoneToQrPageState extends State<PhoneToQrPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _contactSearch = TextEditingController();

  final PhoneToQrBloc _phoneToQrBloc = PhoneToQrBloc();

  List<TextEditingController> importantField = <TextEditingController>[];

  bool checkEmpty() {
    for (TextEditingController member in importantField) {
      if (member.text.trimRight().isEmpty) return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    importantField = [_textEditingController];
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
                    decoration: InputDecoration(
                      hintText: 'search'.tr(),
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
                                        return InkWell(
                                          onTap: () {
                                            _textEditingController.text =
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
                                            _textEditingController.text =
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('phone').tr(),
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
                HistoryItem tmp = HistoryItem(
                    type: 'phone',
                    datetime: DateTime.now(),
                    content: _textEditingController.text.trimRight());
                StaticVariable.createdController.add(tmp);
                StaticVariable.conn.insertCreated(tmp);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QrPhonePage(
                            historyItem: tmp,
                          )),
                );
                _textEditingController.clear();
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
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.only(top: 20),
                          child: Card(
                              elevation: 4,
                              clipBehavior: Clip.hardEdge,
                              child: SizedBox(
                                  height: 70,
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
                                                  left: 10, right: 3),
                                              child: TextField(
                                                controller:
                                                    _textEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                decoration: InputDecoration(
                                                  hintText: 'phone'.tr(),
                                                  contentPadding:
                                                      const EdgeInsets.all(10),
                                                  border: InputBorder.none,
                                                ),
                                                maxLines: null,
                                              ),
                                            ),
                                          ),
                                          const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '*',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              SizedBox(height: 30)
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  )))),
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
                                          child: const Text('enter',
                                                  style: TextStyle(
                                                      color: Colors.white))
                                              .tr())))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: Provider(
                      create: (_) => AdsBloc(),
                      builder: (context, child) {
                        return AdNative(
                          tempType: TemplateType.medium,
                          width: MediaQuery.of(context).size.width,
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
