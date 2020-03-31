import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rp_mobile/layers/bloc/services_package_list/bloc.dart';
import 'package:rp_mobile/layers/bloc/services_package_list/services_package_list_bloc.dart';
import 'package:rp_mobile/layers/services/impl/packages_service_mock.dart';
import 'package:rp_mobile/layers/services/impl/tickets_service.dart';
import 'package:rp_mobile/layers/services/packages_service.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/pages/dashboard/qr_code_modal_route.dart';
import 'package:rp_mobile/layers/ui/pages/package_details.dart';

class TouristPackagesProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServicesPackageListBloc(
        GetIt.instance<PackagesService>(),
      )..add(OnLoad()),
      child: _TouristPackages(),
    );
  }
}

class _TouristPackages extends StatefulWidget {
  @override
  _TouristPackagesState createState() => _TouristPackagesState();
}

class _TouristPackagesState extends State<_TouristPackages> {
  final _scrollController = ScrollController();

  final _scrollThreshold = 200.0;

  Completer _refreshCompleter = Completer()..complete();

  bool _allowPaging = true;

  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    BlocProvider.of<ServicesPackageListBloc>(context).listen((state) {
      if (state is LoadedState && state is! RefreshingListState) {
        if (_refreshCompleter != null && !_refreshCompleter.isCompleted) {
          _refreshCompleter.complete();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<ServicesPackageListBloc, ServicesPackageListState>(
        builder: (context, state) {
          if (state is LoadingListState) {
            return _mapToLoadingListState();
          } else if (state is LoadingPageState) {
            return _mapToLoadingPageState(state);
          } else if (state is LoadedState) {
            return _mapToLoadedState(state);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _mapToLoadingListState() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _mapToLoadedState(LoadedState state) {
    _allowPaging = true;

    return RefreshIndicator(
      child: ListView(
        key: _key,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        children: state.items.map((it) => _TouristPackageItem(it)).toList(),
        controller: _scrollController,
      ),
      onRefresh: () async {
        _allowPaging = false;
        _refreshCompleter = Completer();
        BlocProvider.of<ServicesPackageListBloc>(context).add(OnRefresh());
        await _refreshCompleter.future;
      },
    );
  }

  Widget _mapToLoadingPageState(LoadingPageState state) {
    final children = <Widget>[];

    children.addAll(state.items.map((it) => _TouristPackageItem(it)));
    children.add(Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
    ));

    return ListView(
      key: _key,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: children,
      controller: _scrollController,
    );
  }

  void _onScroll() {
    if (!_allowPaging) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      BlocProvider.of<ServicesPackageListBloc>(context).add(OnNextPage());
      _allowPaging = false;
    }
  }
}

class _TouristPackageItem extends StatelessWidget {
  final PackageItemModel item;

  const _TouristPackageItem(this.item, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 22),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(PackagesDetailPage.route('5e55261f826e00001944c576'));
          },
          child: Container(
            height: 168,
            decoration: BoxDecoration(
              color: Color(0xFFD8D8D8),
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: CachedNetworkImageProvider(item.thumbnailUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: 278,
          child: Text(
            item.title,
            style: TextStyle(
              color: Color(0xFF262626),
              fontSize: 20,
              fontWeight: NamedFontWeight.semiBold,
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          '${item.type} • ${item.untilDate}',
          style: TextStyle(
            color: Color(0xFF262626),
            fontSize: 14,
          ),
        ),
        SizedBox(height: 12),
        _Button(
          text: item.openQRCode ? 'Получить' : 'Билеты',
          onPressed: () {
            Navigator.of(context).push(QrCodeModalRoute());
          },
        ),
        SizedBox(height: 42),
      ],
    );
  }
}

class _Button extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const _Button({Key key, @required this.text, this.onPressed})
      : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  bool _isPressed = false;

  buttonStyle(pressed) => TxtStyle()
    ..background.color(pressed ? AppColors.middleRed : AppColors.primaryRed)
    ..alignmentContent.center()
    ..textColor(Colors.white)
    ..borderRadius(all: 6)
    ..height(50)
    ..width(168)
    ..fontSize(17)
    ..fontWeight(NamedFontWeight.semiBold)
    ..ripple(true, splashColor: Colors.white24, highlightColor: Colors.white10)
    ..boxShadow(
        blur: pressed ? 17 : 0,
        offset: [0, pressed ? 4 : 0],
        color: rgba(247, 70, 78, 0.5))
    ..animate(150, Curves.easeOut);

  GestureClass buttonGestures() => GestureClass()
    ..isTap((isPressed) => setState(() => _isPressed = isPressed))
    ..onTap(widget.onPressed);

  @override
  Widget build(BuildContext context) {
    return Txt(
      widget.text,
      style: buttonStyle(_isPressed),
      gesture: buttonGestures(),
    );
  }
}
