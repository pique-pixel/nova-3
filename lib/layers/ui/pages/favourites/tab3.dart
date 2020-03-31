import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/widgets/base/fade_background.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rp_mobile/layers/bloc/favorites/bloc.dart';

class FavouritesTabView3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child:
          BlocBuilder<FavoriteBloc, FavoriteState>(builder: (context, state) {
        if (state is LoadingState) {
          return CircularProgressIndicator();
        } else if (state is LoadedState) {
          final itemsTours = state.items.tours;
          return ListView.builder(
            itemCount: (itemsTours.length / 2).ceil(),
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
                      child: itemsTours.asMap().containsKey(rowIndex)
                          ? _TourCard(
                              id: itemsTours[rowIndex].id,
                              image: CachedNetworkImageProvider(
                                  itemsTours[rowIndex].image),
                              title: itemsTours[rowIndex].name,
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

class _TourCard extends StatelessWidget {
  final String id;
  final String title;
  final ImageProvider image;

  const _TourCard({
    Key key,
    @required this.id,
    @required this.title,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
//        Navigator.of(context).push(
//          PackagesDemoDetailPage.route(id),
//        );
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
              'Тур',
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 12,
                fontWeight: NamedFontWeight.regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
