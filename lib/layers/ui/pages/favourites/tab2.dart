import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/widgets/base/fade_background.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/pages/package_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rp_mobile/layers/bloc/favorites/bloc.dart';

class FavouritesTabView2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child:
          BlocBuilder<FavoriteBloc, FavoriteState>(builder: (context, state) {
        if (state is LoadingState) {
          return CircularProgressIndicator();
        } else if (state is LoadedState) {
          final itemsTourPackages = state.items.tourPackages;
          return ListView.builder(
            itemCount: (itemsTourPackages.length / 2).ceil(),
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
                      child: itemsTourPackages.asMap().containsKey(rowIndex)
                          ? _PackageCard(
                              id: itemsTourPackages[rowIndex].id,
                              image: CachedNetworkImageProvider(
                                  itemsTourPackages[rowIndex].image),
                              title: itemsTourPackages[rowIndex].name,
                              price: itemsTourPackages[rowIndex].price,
                            )
                          : SizedBox.shrink(),
                    );
                  },
                ),
              );
            },
          );
        } else {
          return SizedBox.shrink();
        }
      }),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final String id;
  final String title;
  final String price;
  final ImageProvider image;

  const _PackageCard({
    Key key,
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PackagesDetailPage.route(id),
        );
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
              'Туристический пакет',
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 12,
                fontWeight: NamedFontWeight.regular,
              ),
            ),
            _Price(price),
          ],
        ),
      ),
    );
  }
}

class _Price extends StatelessWidget {
  final String text;

  const _Price(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$text Р'),
    );
  }
}
