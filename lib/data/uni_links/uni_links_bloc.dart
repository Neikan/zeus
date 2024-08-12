import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_links/uni_links.dart';

part 'uni_links_state.dart';
part 'uni_links_event.dart';

class UniLinksBloc extends Bloc<UniLinksEvent, UniLinksState> {
  late BuildContext context;

  late StreamController<String> promoStreamController;
  Stream<String> get promoStream => promoStreamController.stream;

  late StreamSubscription uniLinksListener;

  UniLinksBloc() : super(UniLinksInitialState()) {
    promoStreamController = StreamController<String>();

    on<UniLinksFileEvent>(_onUniLinksFileEvent);
    on<HandleLastEvent>(_onHandleLastEvent);

    uniLinksListener = uriLinkStream.listen(parseUri);

    initUniLink();
  }

  void dispose() {
    promoStreamController.close();
    uniLinksListener.cancel();
  }

  void initUniLink() {
    initUniLinks().then((initialPath) => initialPath != null
        ? add(UniLinksFileEvent(file: Uri.parse(initialPath)))
        : null);
  }

  void parseUri(Uri? newLinkUri) =>
      newLinkUri != null ? add(UniLinksFileEvent(file: newLinkUri)) : null;

  FutureOr<void> _onUniLinksFileEvent(
      UniLinksFileEvent event, Emitter<UniLinksState> emit) {
    emit(UniLinksUnhandledEventState(file: event.file));
  }

  FutureOr<void> _onHandleLastEvent(
      HandleLastEvent event, Emitter<UniLinksState> emit) {
    emit(UniLinksAllEventsHandledState());
  }

  Future<String?> initUniLinks() async {
    try {
      return await getInitialLink();
    } on PlatformException {
      return null;
    }
  }
}
