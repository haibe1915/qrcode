import 'package:bloc/bloc.dart';

class QrObserver extends BlocObserver {
  const QrObserver();

  @override
  void onChange(BlocBase bloc, Change change) {
    // TODO: implement onChange
    super.onChange(bloc, change);
    print('${bloc.runtimeType}: $change');
  }
}
