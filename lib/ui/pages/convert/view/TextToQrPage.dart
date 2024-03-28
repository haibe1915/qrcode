import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/result/QrText.dart';
import 'package:qrcode/ui/widget/AdNative.dart';

class TextToQrPage extends StatefulWidget {
  const TextToQrPage({super.key});

  @override
  State<TextToQrPage> createState() => _TextToQrPageState();
}

class _TextToQrPageState extends State<TextToQrPage> {
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
    importantField = [_textEditingController];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('text').tr(),
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
                    type: 'text',
                    datetime: DateTime.now(),
                    content: _textEditingController.text.trimRight());
                StaticVariable.createdController.add(tmp);
                StaticVariable.conn.insertCreated(tmp);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QrTextPage(
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
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                                        hintText: 'text'.tr(),
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        border: InputBorder.none,
                                      ),
                                      maxLines: null,
                                    ),
                                  )),
                                ],
                              )))),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Provider(
                    create: (_) => AdsBloc(),
                    builder: (context, child) {
                      return AdNative(
                        tempType: TemplateType.medium,
                        width: MediaQuery.of(context).size.width,
                        factoryId: "adFactoryExample",
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
