import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:division/division.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:optional/optional_internal.dart';
import 'package:rp_mobile/containers/image.dart';
import 'package:rp_mobile/layers/bloc/tickets/bloc.dart';
import 'package:rp_mobile/layers/bloc/tickets/tickets_models.dart';
import 'package:rp_mobile/layers/services/tickets_services.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/pages/tickets/single_ticket_content_details.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';
import 'package:rp_mobile/layers/ui/widgets/base/custom_app_bar.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/pages/package_details.dart';
import 'package:rp_mobile/utils/bloc.dart';

class TicketsPageProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
     create: (context) =>
          TicketsBloc(GetIt.instance<TicketsService>())..add(OnLoad()),
      child: TicketsPage(),
    );
  }
}

TicketsBloc _bloc(BuildContext context) =>
    BlocProvider.of<TicketsBloc>(context);

class TicketsPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => TicketsPageProvider());

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  StreamSubscription _subscription;

  final _scrollController = ScrollController();

  final _scrollThreshold = 200.0;

  Completer _refreshCompleter = Completer()..complete();

  bool _allowPaging = true;

  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _subscription = _bloc(context).listen(_handleRouting);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }

    super.dispose();
  }

  void _handleRouting(TicketsState state) async {
    if (context == null) {
      return;
    }

    if (state is BottomSheetState && !state.hasTriggeredRoute) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) {
          return _BottomSheet(_bloc(context));
        },
      );

      _bloc(context).add(OnCloseBottomSheet());
    }

    if (state is RouteToTransportState) {
      Navigator.of(context).push(
        SingleTicketContentDetailsPage.route(state.ref),
      );
      _bloc(context).add(OnTriggerRoute());
    }

    if (state is RouteToMuseumState) {
      Navigator.of(context).push(
        SingleTicketContentDetailsPage.route(state.ref),
      );
      _bloc(context).add(OnTriggerRoute());
    }

    if (state is! RefreshingListState) {
      if (_refreshCompleter != null && !_refreshCompleter.isCompleted) {
        _refreshCompleter.complete();
      }
    }
  }

  void _onScroll() {
    if (!_allowPaging) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      _bloc(context).add(OnNextPage());
      _allowPaging = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeArea: false,
      theme: AppThemes.materialAppTheme(),
      body: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(height: 90, title: "Мои билеты"),
//          bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.ticket),
          body: BlocBuilder<TicketsBloc, TicketsState>(
            builder: (context, _state) {
              final state = unwindCascadeState(_state);

              if (state is LoadingListState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is LoadingPageState) {
                return _mapToLoadingPageState(state);
              } else if (state is LoadedState) {
                return _mapToLoadedState(state);
              } else if (state is LoadingListErrorState) {
                return _mapToLoadingListErrorState();
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _mapToLoadedState(LoadedState state) {
    _allowPaging = true;

    return RefreshIndicator(
      child: ListView(
        key: _key,
        controller: _scrollController,
        children: state.items.map((it) => _TicketCart(it)).toList(),
      ),
      onRefresh: () async {
        _allowPaging = false;
        _refreshCompleter = Completer();
        _bloc(context).add(OnRefresh());
        await _refreshCompleter.future;
      },
    );
  }

  Widget _mapToLoadingListErrorState() {
    _allowPaging = false;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Не удалось загрузить билеты',
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 24),
          RaisedButton(
            child: Text('Повторить попытку'),
            onPressed: () {
              _bloc(context).add(OnLoad());
            },
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _mapToLoadingPageState(LoadingPageState state) {
    final children = <Widget>[];

    children.addAll(state.items.map((it) => _TicketCart(it)));
    children.add(Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
    ));

    return ListView(
      key: _key,
      children: children,
      controller: _scrollController,
    );
  }
}

class _TicketCart extends StatelessWidget {
  final TicketItemModel item;

  const _TicketCart(this.item, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _bloc(context).add(OnShowBottomSheet(item.ref));
            },
            child: Container(
              height: 188,
              decoration: BoxDecoration(
                color: Color(0xFFD8D8D8),
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: item.thumbnail.match(
                    (asset) => AssetImage(asset),
                    (url) => CachedNetworkImageProvider(url),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  Container(
                    height: 80.0,
                    width: 80.0,
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: CircleAvatar(
                          backgroundColor: AppColors.primaryRed,
                          radius: 10,
                          child: new Image.asset('images/qr_icon.png'),
                        )),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              _bloc(context).add(OnRouteDetails(item.ref));
//              Navigator.of(context).push(ActivityPage.route());
//              switch (page) {
//                case "detail":
//                  Navigator.of(context).push(PackageDetailsPage.route());
//                  break;
//                case "aero":
//                  Navigator.of(context).push(AeroexpressPage.route());
//                  break;
//                case "troika":
//                  Navigator.of(context).push(TroikaPage.route());
//                  break;
//              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    item.title.localize(context),
                    style: TextStyle(
                      color: AppColors.darkGray,
                      fontWeight: NamedFontWeight.semiBold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward, color: AppColors.darkGray)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final TicketsBloc _bloc;

  const _BottomSheet(this._bloc, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketsBloc, TicketsState>(
      bloc: _bloc,
      condition: (prev, current) => current is BottomSheetState,
      builder: (context, state) {
        if (state is BottomSheetState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFC4C4C4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.fromLTRB(16, 14, 16, 24),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(8),
                    topRight: const Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      state.ticketInfo.subTitle.localize(context),
                      style: TextStyle(
                        fontFamily: 'PT Russia Text',
                        fontSize: 12,
                        fontWeight: NamedFontWeight.semiBold,
                        height: 18 / 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      state.ticketInfo.title.localize(context),
                      style: TempTextStyles.subTitle1.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 32),
                    _mapQrCode(state.ticketInfo.qrCode),
                    _mapThumbnail(state.ticketInfo.thumbnail),
                    SizedBox(height: 6),
                    Text(
                      state.ticketInfo.hint.localize(context),
                      style: TextStyle(
                        fontFamily: 'PT Russia Text',
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 32),
                    _Button(
                      text: 'Подробнее',
                      onPressed: () {
                        Navigator.of(context).push(PackagesDetailPage.route('5e55261f826e00001944c576'));
                      },
                    ),
                    SizedBox(height: 34),
                  ],
                ),
              )
            ],
          );
        } else {
          throw UnsupportedError('Unknown state $state');
        }
      },
    );
  }

  Widget _mapQrCode(Optional<String> qrCode) {
    return qrCode
        .map<Widget>((it) => _QRCode(code: it))
        .orElse(SizedBox.shrink());
  }

  Widget _mapThumbnail(Optional<ImageEither> thumbnail) {
    return thumbnail
        .map<Widget>(
          (it) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: it.match(
              (asset) => Image.asset(asset),
              (url) => CachedNetworkImage(imageUrl: url),
            ),
          ),
        )
        .orElse(SizedBox.shrink());
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
    ..background.color(Color(0xFFF8F8F8))
    ..alignmentContent.center()
    ..textColor(AppColors.primaryRed)
    ..borderRadius(all: 8)
    ..height(54)
    ..width(343)
    ..fontSize(17)
    ..fontWeight(NamedFontWeight.semiBold)
    ..ripple(true, splashColor: Colors.white24, highlightColor: Colors.white10)
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

class _QRCode extends StatelessWidget {
  final String code;

  const _QRCode({
    Key key,
    @required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(23),
      child: QrImage(
        data: code,
        version: QrVersions.auto,
        size: 165.0,
      ),
    );
  }
}
