part of 'uni_links_bloc.dart';

@immutable
abstract class UniLinksEvent {}

class UniLinksFileEvent extends UniLinksEvent {
  final Uri file;
  UniLinksFileEvent({required this.file});
}

class HandleLastEvent extends UniLinksEvent {}
