import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/result/QrUrl.dart';
import 'package:qrcode/ui/widget/AdNative.dart';

class UrlToQrPage extends StatelessWidget {
  final TextEditingController _textEditingController =
      TextEditingController(text: 'http://');

  UrlToQrPage({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('url').tr(),
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
              HistoryItem tmp = HistoryItem(
                  type: 'url',
                  datetime: DateTime.now(),
                  content: _textEditingController.text);
              StaticVariable.createdController.add(tmp);
              StaticVariable.conn.insertCreated(tmp);
              _textEditingController.clear();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QrUrlPage(
                          historyItem: tmp,
                        )),
              );
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
                                  const SizedBox(
                                    height: 10,
                                  ),
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
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
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
