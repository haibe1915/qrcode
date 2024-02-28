import 'package:bloc/bloc.dart';

class QrObserver extends BlocObserver {
  const QrObserver();

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType}: $change');
  }
}
