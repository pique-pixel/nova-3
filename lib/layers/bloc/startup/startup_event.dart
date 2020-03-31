import 'package:meta/meta.dart';

@immutable
abstract class StartupEvent {}

class OnStart implements StartupEvent {}

class OnCloseTips implements StartupEvent {}
