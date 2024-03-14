import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/utils/shared_preference/SharedPreference.dart';

class PremiumOption extends StatelessWidget {
  const PremiumOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          )),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          child: CircleAvatar(
            radius: 10,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child:
                const Icon(Icons.attach_money, color: Colors.white, size: 20),
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
