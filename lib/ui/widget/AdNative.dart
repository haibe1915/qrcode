import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/blocs/Ad/ad_event.dart';
import 'package:qrcode/blocs/Ad/ad_state.dart';

class AdNative extends StatefulWidget {
  const AdNative({Key? key, required this.tempType}) : super(key: key);
  final TemplateType tempType;

  @override
  State<AdNative> createState() => _AdNativeState();
}

class _AdNativeState extends State<AdNative> {
  late AdsBloc adsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adsBloc = context.watch<AdsBloc>()
      ..add(AdNativeRequestEvent(tempType: widget.tempType));
  }

  @override
  void dispose() {
    adsBloc.add(AdNativeDisposeEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double adHeight = 100.0;
    if (widget.tempType == TemplateType.small) {
      adHeight = 100; // Change the height for small template type
    } else if (widget.tempType == TemplateType.medium) {
      adHeight = 260; // Change the height for medium template type
    }
    return BlocBuilder<AdsBloc, AdState>(
      buildWhen: (pre, cur) => pre.nativeAd != cur.nativeAd,
      builder: (context, state) {
        if (!state.didNativeAdLoad) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: adHeight,
          child: Stack(
            children: [
              AdWidget(ad: state.nativeAd!),
              Positioned(
                left: -10,
                top: -10,
                child: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    adsBloc.add(AdNativeDisposeEvent());
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
