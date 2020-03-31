//import 'dart:async';

import 'package:division/division.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

//import 'package:optional/optional.dart';
import 'package:rp_mobile/layers/bloc/services_package_details/services_package_details_bloc.dart';
import 'package:rp_mobile/layers/bloc/services_package_details/services_package_details_event.dart';
import 'package:rp_mobile/layers/bloc/services_package_details/services_package_details_state.dart';
import 'package:rp_mobile/layers/bloc/services_package_details/services_package_details_models.dart';
import 'package:rp_mobile/layers/services/packages_service.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/fade_background.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:rp_mobile/layers/ui/pages/event_details.dart';

//import 'package:rp_mobile/locale/localized_string.dart';
import 'dart:math' as math;
//import 'package:rp_mobile/layers/ui/widgets/base/divider.dart';

class PackagesDetailProvider extends StatelessWidget {
  final String ref;

  const PackagesDetailProvider(this.ref, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ServicesPackageDetailsBloc(ref, GetIt.instance<PackagesService>())
            ..add(OnLoad()),
      child: PackagesDetailPage(),
    );
  }
}

class PackagesDetailPage extends StatelessWidget {
  static route(String ref) =>
      MaterialPageRoute(builder: (context) => PackagesDetailProvider(ref));

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.pageBrightnessLightTheme(),
      body: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BlocBuilder<ServicesPackageDetailsBloc,
              ServicesPackageDetailsState>(
            builder: (context, state) {
              if (state is LoadedState) {
                return _PackagesDetailBuy();
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          body: BlocBuilder<ServicesPackageDetailsBloc,
              ServicesPackageDetailsState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is LoadedState) {
                return _PackagesDetailBody();
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
class _PackagesDetailBuy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child:
      BlocBuilder<ServicesPackageDetailsBloc,
          ServicesPackageDetailsState>(
        builder: (context, state) {
          if (state is LoadedState) {
            final HeaderSection section = state.sections
                .firstWhere((it) => it is HeaderSection);
            final price = section.price.toString();
            return
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                height: 80,
                color: AppColors.white,
                child:
                Row(
                    children: <Widget>[
                      Expanded(child:
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '$price Р',
                              style: TextStyle(
                                color: AppColors.darkGray,
                                fontSize: 18,
                                fontWeight: NamedFontWeight.bold,
                              ),
                            ),
                            Text(
                              '1 взрослый',
                              style: TextStyle(color: AppColors.gray),
                            ),
                          ]
                      ),
                      ),
                      _BuyButton(),
                    ]
                ),
              );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
class _PackagesDetailBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return CustomScrollView(
      physics: ClampingScrollPhysics(),
      slivers: <Widget>[
        SliverPersistentHeader(
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
                    child: BlocBuilder<ServicesPackageDetailsBloc,
                        ServicesPackageDetailsState>(
                      builder: (context, state) {
                        if (state is LoadedState) {
                          final HeaderSection section = state.sections
                              .firstWhere((it) => it is HeaderSection);
                          return FadeBackgroundImage(
                            CachedNetworkImageProvider(section.thumbnailUrl),
                            backgroundColor: Color(0xFFD8D8D8),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  SafeArea(bottom: false, child: _AppBar()),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _Header(),
              _PackageConsistsFrom(),
              _LocationsAndActivities(),
              SizedBox(height: mediaQuery.padding.bottom),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 4),
            child: BlocBuilder<ServicesPackageDetailsBloc,
                ServicesPackageDetailsState>(builder: (context, state) {
              if (state is LoadedState) {
                final HeaderSection section =
                    state.sections.firstWhere((it) => it is HeaderSection);
                final subTitle = section.subTitle;
                final ActivitiesSection activitiesSection =
                    state.sections.firstWhere((it) => it is ActivitiesSection);
                final subTitleString = subTitle
                    .map(
                      (it) => it.data,
                    )
                    .toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      section.title,
                      style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 24,
                        fontWeight: NamedFontWeight.bold,
                      ),
                    ),
                    Text(
                      subTitleString.join(' • '),
                      style: TextStyle(color: AppColors.gray),
                    ),
                    SizedBox(height: 26),
                    Text(
                      'Чтобы использовать пакет получите карту RUSSPASS в течение 46 дней с момента покупки.',
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.darkGray,
                      ),
                    ),
                    Text(
                      'Пункты выдачи пакета',
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.primaryRed,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Описание',
                      style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 18,
                        fontWeight: NamedFontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      activitiesSection.description,
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            }),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _LocationsAndActivities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child:
          BlocBuilder<ServicesPackageDetailsBloc, ServicesPackageDetailsState>(
              builder: (context, state) {
        if (state is LoadedState) {
          final HeaderSection section =
              state.sections.firstWhere((it) => it is HeaderSection);
          final ActivitiesSection activitiesSection =
              state.sections.firstWhere((it) => it is ActivitiesSection);
          final List<ActivityModel> items = activitiesSection.activities;
          final int itemLength = items.length;
          final List<ActivityFilter> tags = activitiesSection.filters;
          final cityDefault =
              section.cities.firstWhere((city) => city.isSelected == true);
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 24, 6, 8),
                child: Text(
                  activitiesSection.title,
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 18,
                    fontWeight: NamedFontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: tags
                      .map(
                        (it) => _Tag(it.ref, it.title),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: ListView.builder(
                  itemCount: (itemLength / 2).ceil(),
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int row) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        2,
                        (int column) {
                          final rowIndex = row * 2 + column;
                          return Expanded(
                            child: items.asMap().containsKey(rowIndex)
                                ? _LocationsAndActivitiesCard(
                                    id: items[rowIndex].id,
                                    image: CachedNetworkImageProvider(
                                        items[rowIndex].thumbnailUrl),
                                    title: items[rowIndex].title,
                                    city: cityDefault.name,
                                  )
                                : SizedBox.shrink(),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return SizedBox.shrink();
        }
      }),
    );
  }
}

class _LocationsAndActivitiesCard extends StatelessWidget {
  final String id;
  final String title;
  final String city;
  final ImageProvider image;

  const _LocationsAndActivitiesCard({
    Key key,
    @required this.id,
    @required this.title,
    @required this.city,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(EventDetailPage.route(id));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 202,
                decoration: BoxDecoration(
                  color: Color(0xFFD8D8D8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: FadeBackgroundImage(
                          image,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.darkGray,
                  fontSize: 14,
                  fontWeight: NamedFontWeight.bold,
                ),
              ),
              Text(
                city,
                style: TextStyle(
                  color: AppColors.gray,
                  fontSize: 12,
                  fontWeight: NamedFontWeight.regular,
                ),
              ),
            ]),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String ref;
  final String text;

  const _Tag(this.ref, this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gray, width: 1),
      ),
      child: Text(text),
    );
  }
}

class _PackageConsistsFrom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesPackageDetailsBloc, ServicesPackageDetailsState>(
      builder: (context, state) {
        if (state is LoadedState) {
          final PackageConstitutionSection packageConstitution = state.sections
              .firstWhere((it) => it is PackageConstitutionSection);
          final List<PackageConstitutionItem> items = packageConstitution.items;
          return items.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        packageConstitution.title,
                        style: TextStyle(
                          color: AppColors.darkGray,
                          fontSize: 18,
                          fontWeight: NamedFontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: items
                            .map(
                              (it) => _Item(
                                it.title,
                                it.thumbnailUrl,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                )
              : SizedBox.shrink();
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class _Item extends StatelessWidget {
  final String text;
  final String img;

  const _Item(this.text, this.img, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 120,
            height: 160,
            decoration:
            //TODO переделать на ImageEither
            img != ""
            ? BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: CachedNetworkImageProvider(img),
                fit: BoxFit.cover,
              ),
            )
            : BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.backgroundGray
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              text,
              style: TextStyle(
                fontWeight: NamedFontWeight.regular,
                color: AppColors.darkGray,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
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
            IconButton(
              padding: EdgeInsets.all(0),
              icon:
              Icon(
                Icons.favorite_border,
                color: AppColors.white,
              ),
//              Icon(
//                Icons.favorite,
//                color: AppColors.primaryRed,
//              ),
              onPressed: () {},
            ),
            IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.add,
                color: AppColors.white,
              ),
              onPressed: () {},
            ),
            SizedBox(width: 18),
          ],
        ),
      ),
    );
  }
}
class _BuyButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _BuyButton({Key key, this.onPressed}) : super(key: key);

  @override
  _BuyButtonState createState() => _BuyButtonState();
}

class _BuyButtonState extends State<_BuyButton> {
  bool _isPressed = false;

  buttonStyle(pressed) => ParentStyle()
    ..background.color(AppColors.primaryRed)
    ..alignmentContent.center()
    ..borderRadius(all: 4)
    ..height(42)
    ..margin(left: 6, right: 6)
    ..padding(left: 10, right: 10)
    ..ripple(true)
//    ..elevation(pressed ? 6 : 2)
    ..animate(150, Curves.easeOut);

  GestureClass buttonGestures() => GestureClass()
    ..isTap((isPressed) => setState(() => _isPressed = isPressed))
    ..onTap(widget.onPressed);

  @override
  Widget build(BuildContext context) {
    return Parent(
        style: buttonStyle(_isPressed),
        gesture: buttonGestures(),
        child: Text(
          'Купить',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ));
  }
}
