import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/layers/bloc/single_ticket_content_details/bloc.dart';
import 'package:rp_mobile/layers/bloc/single_ticket_content_details/single_ticket_content_details_event.dart';
import 'package:rp_mobile/layers/bloc/single_ticket_content_details/single_ticket_content_details_models.dart';
import 'package:rp_mobile/layers/services/tickets_services.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/fade_background.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:rp_mobile/locale/localized_string.dart';
import 'dart:math' as math;

import 'package:yandex_mapkit/yandex_mapkit.dart';

class SingleTicketContentDetailsPageProvider extends StatelessWidget {
  final String ref;

  const SingleTicketContentDetailsPageProvider(this.ref, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SingleTicketContentDetailsBloc(GetIt.instance<TicketsService>())
            ..add(OnLoad(ref)),
      child: SingleTicketContentDetailsPage(),
    );
  }
}

class SingleTicketContentDetailsPage extends StatelessWidget {
  static route(String ref) => MaterialPageRoute(
      builder: (context) => SingleTicketContentDetailsPageProvider(ref));

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.pageBrightnessLightTheme(),
      body: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.ticket),
          body: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: <Widget>[
              _Header(),
              _SliverContent(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 80.0 + mediaQuery.padding.top,
        maxHeight: 200.0 + mediaQuery.padding.top,
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: BlocBuilder<SingleTicketContentDetailsBloc,
                    SingleTicketContentDetailsState>(builder: (context, state) {
                  if (state is LoadedState) {
                    return FadeBackgroundImage(
                      state.details.headerThumbnail.match(
                        (asset) => AssetImage(asset),
                        (url) => CachedNetworkImageProvider(url),
                      ),
                      backgroundColor: Color(0xFFD8D8D8),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
              ),
              SafeArea(bottom: false, child: _AppBar()),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleTicketContentDetailsBloc,
        SingleTicketContentDetailsState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return _SliverProgressBar();
        } else if (state is LoadedState) {
          return _Details(state.details);
        } else {
          return SliverFillRemaining(child: SizedBox.shrink());
        }
      },
    );
  }
}

class _SliverProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        color: AppColors.primaryRed,
        child: Center(
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.white),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final SingleTicketContentDetails details;

  const _Details(this.details, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final redSections = <Widget>[];
    final whiteSections = <Widget>[];
    final children = <Widget>[];

    redSections.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 6,
            ),
            child: Text(
              details.title.localize(context),
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: NamedFontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              children:
                  details.tags.map((it) => _Tag(it.localize(context))).toList(),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );

    for (final section in details.sections) {
      final redSection = _mapRedSections(section, context);
      final whiteSection = _mapWhiteSections(section, context);

      if (redSection != null) {
        redSections.add(redSection);
      }

      if (whiteSection != null) {
        whiteSections.add(whiteSection);
      }
    }

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            color: AppColors.primaryRed,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: redSections,
            ),
          ),
          Container(
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: whiteSections,
            ),
          ),
        ],
      ),
    );
  }

  IconData _mapIcon(SingleTicketContentSectionIcon icon) {
    switch (icon) {
      case SingleTicketContentSectionIcon.calendar:
        return Icons.event;

      case SingleTicketContentSectionIcon.disabled:
        return Icons.accessible;
    }
  }

  Widget _mapRedSections(
    SingleTicketContentSection section,
    BuildContext context,
  ) {
    if (section is SingleTicketContentAddressSection) {
      return _AddressPanel(
        address: section.address,
        webSite: section.webSite,
      );
    } else if (section is SingleTicketContentIconInfoBarSection) {
      return _IconBar(
        title: section.text.localize(context),
        icon: _mapIcon(section.icon),
      );
    } else if (section is SingleTicketContentInfoBarSection) {
      return _InfoBar(
        title: section.text.localize(context),
      );
    } else if (section is SingleTicketContentIconInfoSpoilerBarSection) {
      return _InfoBarSpoiler(
        title: section.text.localize(context),
        icon: _mapIcon(section.icon),
        spoilerText: section.spoilerText.localize(context),
      );
    } else if (section is SingleTicketContentInfoBarTariffSection) {
      return _InfoBar(
        title: section.text.localize(context),
        value: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _Time(section.time.localize(context)),
            _Price(section.price.localize(context)),
          ],
        ),
      );
    }

    return null;
  }

  Widget _mapWhiteSections(
    SingleTicketContentSection section,
    BuildContext context,
  ) {
    if (section is SingleTicketContentDescSection) {
      return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 21, 18, 8),
          child: Text(section.text.localize(context)),
        ),
      );
    } else if (section is SingleTicketContentMapSection) {
      return _Map(
        latitude: section.latitude,
        longitude: section.longitude,
      );
    } else {
      return null;
    }
  }
}

class _AddressPanel extends StatelessWidget {
  final Optional<LocalizedString> address;
  final Optional<String> webSite;

  const _AddressPanel({
    Key key,
    this.address,
    this.webSite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        address.isPresent
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  address.value.localize(context),
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              )
            : SizedBox.shrink(),
        webSite.isPresent
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  'Официальный сайт',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: NamedFontWeight.semiBold,
                  ),
                ),
              )
            : SizedBox.shrink(),
        address.isPresent || webSite.isPresent
            ? SizedBox(height: 24)
            : SizedBox.shrink(),
      ],
    );
  }
}

class _Time extends StatelessWidget {
  final String time;

  const _Time(this.time, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(Icons.access_time, size: 16, color: Colors.white),
        SizedBox(width: 5),
        Text(time, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

class _Price extends StatelessWidget {
  final String price;

  const _Price(this.price, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(price, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

class _InfoBar extends StatelessWidget {
  final String title;
  final Widget value;

  const _InfoBar({
    Key key,
    @required this.title,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title,
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ),
          (value != null ? value : Container()),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            BackButton(color: Colors.white),
            Expanded(child: SizedBox.shrink()),
            SizedBox(width: 18),
          ],
        ),
      ),
    );
  }
}

class _IconBar extends StatefulWidget {
  final String title;
  final IconData icon;

  const _IconBar({
    Key key,
    this.title,
    this.icon,
  }) : super(key: key);

  @override
  _IconBarState createState() => _IconBarState();
}

class _IconBarState extends State<_IconBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Icon(widget.icon, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: Color(0xffd34047),
        ),
      ],
    );
  }
}

class _InfoBarSpoiler extends StatefulWidget {
  final String title;
  final IconData icon;
  final String spoilerText;

  const _InfoBarSpoiler({
    Key key,
    this.title,
    this.icon,
    this.spoilerText,
  }) : super(key: key);

  @override
  _InfoBarSpoilerState createState() => _InfoBarSpoilerState();
}

class _InfoBarSpoilerState extends State<_InfoBarSpoiler>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  AnimationController _animation;
  StreamSubscription _scrollDelaySubscription;
  final key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0.0,
    );
  }

  @override
  void dispose() {
    _animation.dispose();

    if (_scrollDelaySubscription != null) {
      _scrollDelaySubscription.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 56,
          child: Material(
            color: AppColors.primaryRed,
            child: InkWell(
              highlightColor: Colors.white24,
              splashColor: Colors.white30,
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                  _updateAnim();
                  if (_isExpanded) _ensureVisible();
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(widget.icon, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: _isExpanded ? 1 : 3,
                      child: Icon(Icons.chevron_left, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          color: Color(0xffd34047),
        ),
        SizeTransition(
          axisAlignment: 0.0,
          sizeFactor: _animation,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            color: Color(0xffeb474f),
            child: Text(
              widget.spoilerText,
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ),
      ],
    );
  }

  void _updateAnim() {
    _animation.fling(velocity: _isExpanded ? 1.0 : -1.0);
  }

  _ensureVisible() {
    if (_scrollDelaySubscription != null) {
      _scrollDelaySubscription.cancel();
      _scrollDelaySubscription = null;
    }
    final delay = Future.delayed(const Duration(milliseconds: 400));
    _scrollDelaySubscription = delay.asStream().listen((_) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 300),
        alignment: 0.5,
      );
    });
  }
}

class _Map extends StatelessWidget {
  final double latitude;
  final double longitude;

  const _Map({
    Key key,
    @required this.latitude,
    @required this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 142,
      width: double.infinity,
      child: YandexMap(
        onMapCreated: (controller) async {
          await controller.setBounds(
            southWestPoint: Point(
              latitude: latitude - 0.02,
              longitude: longitude - 0.02,
            ),
            northEastPoint: Point(
              latitude: latitude + 0.02,
              longitude: longitude + 0.02,
            ),
          );
        },
      ),
    );
  }
}
