part of 'uni_links_bloc.dart';

@immutable
abstract class UniLinksState {}

class UniLinksInitialState extends UniLinksState {}

class UniLinksAllEventsHandledState extends UniLinksState {}

class UniLinksUnhandledEventState extends UniLinksState {
  final Uri file;
  UniLinksUnhandledEventState({required this.file});
}
