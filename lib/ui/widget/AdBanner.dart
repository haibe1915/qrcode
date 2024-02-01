import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrcode/blocs/AdBanner/ad_banner_bloc.dart';
import 'package:qrcode/blocs/AdBanner/ad_banner_event.dart';
import 'package:qrcode/blocs/AdBanner/ad_banner_state.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({Key? key}) : super(key: key);

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  late AdsBloc adsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adsBloc = context.read<AdsBloc>()..add(AdBannerRequestEvent());
  }

  @override
  void dispose() {
    adsBloc.add(AdBannerDisposeEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsBloc, AdBannerState>(
      buildWhen: (pre, cur) => pre.bottomBannerAd != cur.bottomBannerAd,
      builder: (context, state) {
        if (!state.didBottomBannerAdLoad) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: Stack(
            children: [
              AdWidget(ad: state.bottomBannerAd!),
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  adsBloc.add(AdBannerDisposeEvent());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
