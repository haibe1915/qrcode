import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

import 'dart:async';

import 'package:qrcode/ui/pages/result/QrEvent.dart';
import 'package:qrcode/ui/widget/AdNative.dart';

class EventToQrPage extends StatefulWidget {
  const EventToQrPage({super.key});

  @override
  State<EventToQrPage> createState() => _EventToQrPageState();
}

class _EventToQrPageState extends State<EventToQrPage> {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _locationEditingController =
      TextEditingController();
  final TextEditingController _describeEditingController =
      TextEditingController();
  final TextEditingController _urlEditingController = TextEditingController();

  final StreamController<DateTime> _streamStartDateTimeController =
      StreamController<DateTime>.broadcast();
  final StreamController<DateTime> _streamEndDateTimeController =
      StreamController<DateTime>.broadcast();
  final ScrollController _scrollController = ScrollController();
  DateTime dateTimeStart = DateTime.now();
  DateTime dateTimeEnd = DateTime.now();

  _calendarPermissions() async {
    Map<Permission, PermissionStatus> permissionStatus =
        await [Permission.calendarFullAccess].request();
    return permissionStatus[Permission.calendarFullAccess];
  }

  addEvent(String data) async {
    PermissionStatus calendarPermissionsStatus = await _calendarPermissions();

    if (calendarPermissionsStatus.isGranted) {
      final Event event = Event(
          title: _titleEditingController.text,
          description: _describeEditingController.text,
          location: _locationEditingController.text,
          startDate: dateTimeStart,
          endDate: dateTimeEnd);
      await Add2Calendar.addEvent2Cal(event).then((_) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: SizedBox(
                  width: 200, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                  child: Center(child: const Text('addSuccess').tr()),
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
      });
    }
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _locationEditingController.dispose();
    _describeEditingController.dispose();
    _urlEditingController.dispose();
    _streamStartDateTimeController.close();
    _streamEndDateTimeController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Text('event').tr(),
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
                var data = 'BEGIN:VCALENDAR\n'
                    'VERSION:2.0\n'
                    'BEGIN:VEVENT\n'
                    'DTSTART:${DateFormat("yyyyMMdd'T'HHmmss").format(dateTimeStart)}\n'
                    'DTEND:${DateFormat("yyyyMMdd'T'HHmmss").format(dateTimeEnd)}\n'
                    'SUMMARY:${_titleEditingController.text}\n'
                    'DESCRIPTION:${_describeEditingController.text}\n'
                    'LOCATION:${_locationEditingController.text}\n'
                    'END:VEVENT\n'
                    'END:VCALENDAR';
                HistoryItem tmp = HistoryItem(
                    type: 'event', datetime: DateTime.now(), content: data);
                StaticVariable.createdController.add(tmp);
                StaticVariable.conn.insertCreated(tmp);
                _titleEditingController.clear();
                _locationEditingController.clear();
                _describeEditingController.clear();
                _urlEditingController.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QrEventPage(
                            historyItem: tmp,
                          )),
                );
              },
            )
          ],
        ),
        body: SingleChildScrollView(
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
                                      controller: _titleEditingController,
                                      decoration: InputDecoration(
                                        hintText: 'title'.tr(),
                                        contentPadding:
                                            const EdgeInsets.all(10),
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
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    child: TextField(
                                      controller: _locationEditingController,
                                      decoration: InputDecoration(
                                        hintText: 'location'.tr(),
                                        contentPadding:
                                            const EdgeInsets.all(10),
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
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    child: TextField(
                                      controller: _describeEditingController,
                                      decoration: InputDecoration(
                                        hintText: 'description'.tr(),
                                        contentPadding:
                                            const EdgeInsets.all(10),
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
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    child: TextField(
                                      controller: _urlEditingController,
                                      decoration: InputDecoration(
                                        hintText: 'url'.tr(),
                                        contentPadding:
                                            const EdgeInsets.all(10),
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
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    child: Center(
                                        child: StreamBuilder(
                                      stream:
                                          _streamStartDateTimeController.stream,
                                      builder: ((context, snapshot) {
                                        if (snapshot.hasData) {
                                          dateTimeStart = snapshot.data!;
                                        } else {
                                          dateTimeStart = DateTime.now();
                                        }
                                        return CupertinoButton(
                                            child: Text(StaticVariable
                                                .formattedDateTime
                                                .format(dateTimeStart)
                                                .toString()),
                                            onPressed: () {
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SizedBox(
                                                        height: 250,
                                                        width: screenWidth,
                                                        child:
                                                            CupertinoDatePicker(
                                                          backgroundColor:
                                                              Colors.white,
                                                          initialDateTime:
                                                              DateTime.now(),
                                                          onDateTimeChanged:
                                                              (DateTime
                                                                  newTime) {
                                                            _streamStartDateTimeController
                                                                .sink
                                                                .add(newTime);
                                                          },
                                                        ));
                                                  });
                                            });
                                      }),
                                    )),
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
                                    child: Center(
                                        child: StreamBuilder(
                                      stream:
                                          _streamEndDateTimeController.stream,
                                      builder: ((context, snapshot) {
                                        if (snapshot.hasData) {
                                          dateTimeEnd = snapshot.data!;
                                        } else {
                                          dateTimeEnd = DateTime.now();
                                        }
                                        return CupertinoButton(
                                            child: Text(StaticVariable
                                                .formattedDateTime
                                                .format(dateTimeEnd)
                                                .toString()),
                                            onPressed: () {
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SizedBox(
                                                        height: 250,
                                                        child:
                                                            CupertinoDatePicker(
                                                          backgroundColor:
                                                              Colors.white,
                                                          initialDateTime:
                                                              DateTime.now(),
                                                          onDateTimeChanged:
                                                              (DateTime
                                                                  newTime) {
                                                            _streamEndDateTimeController
                                                                .sink
                                                                .add(newTime);
                                                          },
                                                        ));
                                                  });
                                            });
                                      }),
                                    )),
                                  ),
                                ],
                              ),
                            )),
                      ))),
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
        ));
  }
}
