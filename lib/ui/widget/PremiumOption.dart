import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/utils/shared_preference/SharedPreference.dart';

class PremiumOption extends StatelessWidget {
  const PremiumOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 160,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey,
            width: 2.0,
          )),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 5,
              ),
              const CircleAvatar(
                radius: 12,
                backgroundColor: Color.fromARGB(255, 233, 218, 4),
                child: Icon(Icons.attach_money, color: Colors.white, size: 20),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'premium',
                style: TextStyle(color: Colors.blueGrey, fontSize: 18),
              ).tr(),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: SizedBox(
                      width: 200, // Adjust the width as needed
                      height: 50, // Adjust the height as needed
                      child: Center(
                        child: const Text("confirmPremium").tr(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('yes').tr(),
                        onPressed: () {
                          SharedPreference.setPremiumPreference(true);
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('no').tr(),
                        onPressed: () {
                          SharedPreference.setPremiumPreference(false);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
