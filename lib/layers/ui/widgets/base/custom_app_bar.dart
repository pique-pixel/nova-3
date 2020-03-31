import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/locale/app_localizations.dart';
import 'package:rp_mobile/layers/ui/pages/profile_group/profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';

//@todo сделать показ/скрытие аватара
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final bool leading;
  final bool avatar;
  final bool phone;
  final bool shadow;


  /// CustomAppBar
  ///
  /// height - height AppBar
  ///
  /// title - String title page
  ///
  /// leading - bool button back default false
  ///
  /// avatar - bool default false
  ///
  /// phone - bool default false
  ///
  /// shadow - bool border bottom default false
  ///
  const CustomAppBar(
      {Key key,
        @required this.height,
        this.title = "",
        this.avatar = false,
        this.phone = false,
        this.leading = false,
        this.shadow = false})
      : super(key: key);

  final String phoneNumber = 'tel:+74951220111';
  _callPhone() async {
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not Call Phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return AppBar(
      elevation: (shadow ? 4 : 0.0),
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0.0,
      title:
      (leading ?
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, color: AppColors.darkGray),
            ),
//            Text(
//              l.back,
//              style: TextStyle(
//                color: AppColors.primaryRed,
//              ),
//            ),
          ])
          : SizedBox.shrink()),
      actions: <Widget>[
    (avatar ?
        SizedBox(
          width: 80,
          height: 80,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(ProfilePage.route());
              },
              child:
          Padding(padding: EdgeInsets.only(top: 10),
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Color(0xFFE6E6E6),
            ),
          ),
        )
        )
        : SizedBox.shrink()
    ),
        (phone ?
        SizedBox(
            width: 80,
            height: 80,
            child: GestureDetector(
              onTap: () {
                _callPhone();
              },
              child:
              Padding(padding: EdgeInsets.only(top: 10),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Color(0xFFE6E6E6),
                  child: Icon(Icons.phone,
                  color: AppColors.primaryRed,),
                ),
              ),
            )
        )
            : SizedBox.shrink()
        ),
      ],
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            height: 36.0,
            alignment: Alignment.topLeft,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(padding: EdgeInsets.only(left: 16.0, bottom: 10.0)),
              Text(
                title,
                style: GolosTextStyles.h1size30(
                    golosTextColors: GolosTextColors.grayDarkVery),
              )
            ]),
          )),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}