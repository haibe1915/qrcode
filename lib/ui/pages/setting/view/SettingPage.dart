import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/widget/LanguageOption.dart';
import 'package:qrcode/utils/shared_preference/SharedPreference.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isMusicSwitched = true;
  bool _isVibrationSwitched = true;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _loadVibrationPreference();
  }

  Future<void> _loadVibrationPreference() async {
    bool vibrationPreference = await SharedPreference.getVibrationPreference();
    setState(() {
      _isVibrationSwitched = vibrationPreference;
    });
  }

  void changeLanguage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('setting').tr(),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 30,
                ),
                const Text(
                  "general",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ).tr()
              ],
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.volume_down),
                    title: const Text("sound").tr(),
                    trailing: Switch(
                      value: _isMusicSwitched,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          _isMusicSwitched = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.vibration),
                    title: const Text("vibration").tr(),
                    trailing: Switch(
                      value: _isVibrationSwitched,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        SharedPreference.setVibrationPreference(value);
                        setState(() {
                          _isVibrationSwitched = value;
                        });
                      },
                    ),
                  ),
                  LanguageOption(onLanguageChanged: changeLanguage),
                  ListTile(
                    leading: const Icon(Icons.money),
                    title: const Text("Premium"),
                    trailing: Switch(
                      value: _isPremium,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        SharedPreference.setPremiumPreference(value);
                        setState(() {
                          _isPremium = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 30,
                ),
                const Text(
                  "developer",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ).tr(),
              ],
            ),
            Card(
              child: Column(
                children: [
                  InkWell(
                    child: ListTile(
                      leading: const Icon(Icons.mail),
                      title: const Text("response").tr(),
                    ),
                    onTap: () {
                      TextEditingController _nameController =
                          TextEditingController(text: "abcd@gmail.com");
                      TextEditingController _descriptionEditingController =
                          TextEditingController(text: "Response about qrcode");
                      TextEditingController _textEditingController =
                          TextEditingController();
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 0.9 * MediaQuery.of(context).size.height,
                              child: Scaffold(
                                appBar: AppBar(
                                    title: const Text('Phản hồi').tr(),
                                    actions: [
                                      IconButton(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            top: 20,
                                            bottom: 20,
                                            right: 10),
                                        alignment: Alignment.bottomLeft,
                                        icon: const Icon(
                                          Icons.send,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          var data =
                                              'mailto:${_nameController.text}?subject=${Uri.encodeQueryComponent(_descriptionEditingController.text)}&body=${Uri.encodeQueryComponent(_textEditingController.text)}';
                                          _textEditingController.clear();
                                          Navigator.pop(context);
                                          launchUrl(Uri.parse(data));
                                        },
                                      )
                                    ]),
                                body: Column(
                                  children: [
                                    const SizedBox(height: 10),
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
                                              enabled: false,
                                              controller: _nameController,
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                              decoration: const InputDecoration(
                                                hintText: 'Đến',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                border: InputBorder.none,
                                              ),
                                              maxLines: null,
                                            ),
                                          ),
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
                                      child: TextField(
                                        enabled: false,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        controller:
                                            _descriptionEditingController,
                                        decoration: const InputDecoration(
                                          hintText: 'Chủ đề',
                                          contentPadding: EdgeInsets.all(10),
                                          border: InputBorder.none,
                                        ),
                                        maxLines: null,
                                      ),
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
                                          hintText: 'Văn bản',
                                          contentPadding: EdgeInsets.all(10),
                                          border: InputBorder.none,
                                        ),
                                        maxLines: null,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
