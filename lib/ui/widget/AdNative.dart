import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/blocs/Ad/ad_event.dart';
import 'package:qrcode/blocs/Ad/ad_state.dart';

class AdNative extends StatefulWidget {
  const AdNative({Key? key}) : super(key: key);

  @override
  State<AdNative> createState() => _AdNativeState();
}

class _AdNativeState extends State<AdNative> {
  late AdsBloc adsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adsBloc = context.watch<AdsBloc>()..add(AdNativeRequestEvent());
  }

  @override
  void dispose() {
    adsBloc.add(AdNativeDisposeEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsBloc, AdState>(
      buildWhen: (pre, cur) => pre.bottomBannerAd != cur.bottomBannerAd,
      builder: (context, state) {
        if (state is AdLoading) {
          return SizedBox(
              height: 0.8 * MediaQuery.of(context).size.height,
              child: const Center(child: CircularProgressIndicator()));
        }
        if (!state.didNativeAdLoad) {
          return const SizedBox.shrink();
        }
        return ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 320, // minimum recommended width
            minHeight: 320, // minimum recommended height
            maxHeight: 320,
          ),
          child: Stack(
            children: [
              AdWidget(ad: state.nativeAd!),
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  adsBloc.add(AdNativeDisposeEvent());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
