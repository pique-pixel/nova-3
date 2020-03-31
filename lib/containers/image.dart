import 'package:equatable/equatable.dart';

class ImageEither extends Equatable {
  final String assetName;
  final String url;

  ImageEither.url(this.url) : assetName = null;

  ImageEither.asset(this.assetName) : url = null;

  T match<T>(
    T Function(String value) assetNameHandler,
    T Function(String value) urlHandler,
  ) {
    if (assetName == null) {
      return urlHandler(url);
    } else {
      return assetNameHandler(assetName);
    }
  }

  @override
  List<Object> get props => [assetName, url];
}
