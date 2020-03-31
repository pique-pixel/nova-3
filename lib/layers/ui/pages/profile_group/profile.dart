import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:optional/optional_internal.dart';
import 'package:rp_mobile/layers/bloc/profile/menu/bloc.dart';
import 'package:rp_mobile/layers/services/auth.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/pages/profile_group/about.dart';
import 'package:rp_mobile/layers/ui/pages/profile_group/change_value_screen.dart';
import 'package:rp_mobile/layers/ui/pages/profile_group/edit_profile.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:rp_mobile/layers/ui/widgets/base/divider.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';
import 'package:rp_mobile/utils/ui_state_control_utlis.dart';

import 'write_message/write_message.dart';

class ProfilePage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => MenuBloc(
            sessionService: GetIt.instance<SessionService>(),
            authService: GetIt.instance<AuthService>(),
          )..add(OnUpdateMenuEvent()),
          child: ProfilePage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final String settingsTitle = 'Настройки';
    String selctedCurrency = 'Евро (€)';
    String selctedLanguage = 'Русский';
    final List<String> currencyList = [
      'Российские рубли (RUB)',
      'Евро (€)',
      'Доллары США (\$)',
    ];
    final List<String> languageList = [
      'Русский',
      'Английский',
      'Испанский',
    ];

    List<_SettingsSubMenuItemData> settingsListData = [
      _SettingsSubMenuItemData(
        title: 'Валюта',
        iconPath: 'images/wallet.png',
        onTap: () {
          Navigator.push(
            context,
            ChangeValueScreen.route(
                title: 'Валюта',
                selected: currencyList.indexOf(selctedCurrency),
                listValues: currencyList,
                onChanged: (selectedValue) {
                  BlocProvider.of<MenuBloc>(context)
                    ..add(OnUpdateCurrencyEvent(selectedValue));
                }),
          );
        },
        trailingText: selctedCurrency,
      ),
      _SettingsSubMenuItemData(
        title: 'Язык',
        iconPath: 'images/language.png',
        onTap: () {
          Navigator.push(
            context,
            ChangeValueScreen.route(
                title: 'Язык',
                selected: 0,
                listValues: languageList,
                onChanged: (selectedValue) {
                  BlocProvider.of<MenuBloc>(context)
                    ..add(OnUpdateLanguageEvent(selectedValue));
                }),
          );
        },
        trailingText: 'Русский',
      ),
      _SettingsSubMenuItemData(
        title: 'Уведомления',
        iconPath: 'images/notification.png',
        onTap: () {},
      ),
    ];
    final String servicesTitle = 'Cервисы';
    final List<_SettingsSubMenuItemData> servicesListData = [
      _SettingsSubMenuItemData(
        title: 'Авиабилеты',
        iconPath: 'images/plane.png',
        onTap: () {},
      ),
      _SettingsSubMenuItemData(
        title: 'Ж/д билеты',
        iconPath: 'images/train.png',
        onTap: () {},
      ),
      _SettingsSubMenuItemData(
        title: 'Гостиницы',
        iconPath: 'images/hotel.png',
        onTap: () {},
      ),
      _SettingsSubMenuItemData(
        title: 'Пакеты',
        iconPath: 'images/pack.png',
        onTap: () {},
      ),
      _SettingsSubMenuItemData(
        title: 'Автотуры',
        iconPath: 'images/car.png',
        onTap: () {},
      ),
      _SettingsSubMenuItemData(
        title: 'E-visa',
        iconPath: 'images/visa.png',
        onTap: () {},
      ),
    ];
    final String helpTitle = 'Помощь';
    final List<_SettingsSubMenuItemData> helpListData = [
      _SettingsSubMenuItemData(
        title: 'Частые вопросы',
        iconPath: 'images/faq2.png',
        onTap: () {},
      ),
      _SettingsSubMenuItemData(
        title: 'Напишите нам',
        iconPath: 'images/write.png',
        onTap: () {
          Navigator.of(context).push(WriteMessagePage.route());
        },
      ),
      _SettingsSubMenuItemData(
        title: 'Позвонить в поддержку',
        iconPath: 'images/call.png',
        onTap: () {},
      ),
      _SettingsSubMenuItemData(
        title: 'О приложении',
        iconPath: 'images/about.png',
        onTap: () {
          Navigator.of(context).push(AboutPage.route());
        },
      ),
    ];

    return AppScaffold(
      bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.profile),
      theme: AppThemes.materialAppTheme(),
      body: Material(
        child: ListView(
          shrinkWrap: false,
          children: <Widget>[
            BlocBuilder<MenuBloc, MenuState>(
              builder: (BuildContext context, MenuState state) {
                List<Widget> list = [];
                Function onTapEdit = () {
                  print("Must go to profile page");
                  Navigator.of(context).push(EditProfile.route());
                };
                if (state is InitialMenuState) {
                  list.add(_ProfileAvatarStates.with2Letters(
                      twoLetters: state.twoLetters.value));
                  list.add(
                      _NameAndEditButtonStates.noName(onTapEdit: onTapEdit));
                  list.add(TouristIdState.noId());
                }

                if (state is UpdatedMenuState) {
                  if (state.image.isPresent == false &&
                      state.twoLetters.isPresent == true) {
                    list.add(_ProfileAvatarStates.with2Letters(
                        twoLetters: state.twoLetters.value));
                  } else if (state.image.isPresent == true) {
                    list.add(_ProfileAvatarStates.withPicture(
                        url: state.image.value));
                  }

                  if (state.name.isPresent) {
                    list.add(
                      _NameAndEditButtonStates.name(
                        name: state.name.value,
                        onTapEdit: onTapEdit,
                      ),
                    );
                  } else {
                    list.add(
                        _NameAndEditButtonStates.noName(onTapEdit: onTapEdit));
                  }

                  if (state.id.isPresent) {
                    list.add(TouristIdState.id(id: state.id.value));
                  } else {
                    list.add(TouristIdState.noId());
                  }
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: list,
                );
              },
            ),
//            LongPressToChangeStateToNext(
//              listWidgetStates: [
//                _ProfileAvatarStates.with2Letters(twoLetters: 'VP'),
//                _ProfileAvatarStates.withPicture(url: profile.avatarUrl),
//              ],
//            ),
//            LongPressToChangeStateToNext(
//              listWidgetStates: <Widget>[
//                _NameAndEditButtonStates.noName(
//                  onTapEdit: () {
//                    print("Must go to profile page");
//                    _onTapEdit(Navigator.of(context));
//                  },
//                ),
//                _NameAndEditButtonStates.name(
//                  name: 'Vasiliy',
//                  onTapEdit: () {
//                    print("Must go to profile page");
//                    Navigator.of(context).push(EditProfile.route());
//                  },
//                ),
//              ],
//            ),
//            LongPressToChangeStateToNext(
//              listWidgetStates: <Widget>[
//                TouristIdState.noId(),
//                TouristIdState.id(id: '4560987890'),
//              ],
//            ),
            SizedBox(height: 16),
            Divider(
              height: 0,
              color: AppColors.lightGray,
            ),
            SizedBox(height: 8),
            BlocBuilder<MenuBloc, MenuState>(
                builder: (BuildContext context, MenuState state) {
              if (state is UpdateCurrencyState) {
                selctedCurrency = state.selectedCurrency;
                settingsListData.first.trailingText = selctedCurrency;
              } else if (state is UpdateLanguageState) {
                selctedLanguage = state.selectedLanguage;
                settingsListData[1].trailingText = selctedLanguage;
              }
              return _SettingsSubMenu(
                title: settingsTitle,
                listSubMenuItemData: settingsListData,
              );
            }),

            _SettingsSubMenu(
              title: servicesTitle,
              listSubMenuItemData: servicesListData,
            ),
            _SettingsSubMenu(
              title: helpTitle,
              listSubMenuItemData: helpListData,
            ),
            _ExitButton(
              onTap: () {
                BlocProvider.of<MenuBloc>(context)..add(OnExitMenuEvent());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ExitButton extends StatelessWidget {
  final Function onTap;

  const _ExitButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 22, left: 16, right: 16),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.all(0),
        title: Text(
          'Выйти',
          style: GolosTextStyles.h3size16(
            golosTextColors: GolosTextColors.red,
          ),
        ),
      ),
    );
  }
}

class _SettingsSubMenuItemData {
  final String title;
  final String iconPath;
  String trailingText;
  final Function onTap;

  _SettingsSubMenuItemData({
    @required this.title,
    @required this.iconPath,
    this.trailingText,
    this.onTap,
  });
}

class _SettingsSubMenu extends StatelessWidget {
  final String title;
  final List<_SettingsSubMenuItemData> listSubMenuItemData;

  const _SettingsSubMenu({
    Key key,
    this.title,
    this.listSubMenuItemData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 0, right: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 14,
                fontWeight: NamedFontWeight.semiBold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: listSubMenuItemData.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 0),
                    onTap: () async {
                      print('Tapped ${listSubMenuItemData[index].title}');
                      listSubMenuItemData[index].onTap();
                    },
                    leading: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Image.asset(
                        listSubMenuItemData[index].iconPath,
                        height: 26,
                        width: 26,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                    title: Text(
                      listSubMenuItemData[index].title,
                      style: GolosTextStyles.h3size16(
                        golosTextColors: GolosTextColors.grayDarkVery,
                      ),
                    ),
                    trailing: listSubMenuItemData[index].trailingText == null
                        ? null
                        : Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Text(
                              listSubMenuItemData[index].trailingText,
                              style: GolosTextStyles.mainTextSize16(
                                golosTextColors: GolosTextColors.grayDark,
                              ),
                            ),
                          ),
                  ),
                  Divider(
                    height: 0,
                    indent: 60,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class TouristIdState extends StatelessWidget {
  final String id;

  const TouristIdState.id({Key key, this.id}) : super(key: key);

  const TouristIdState.noId({Key key})
      : id = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String textToShow = 'Ваш ID ';
    if (id == null) {
      textToShow = textToShow + 'туриста отсутствует';
    } else {
      textToShow = textToShow + '$id';
    }
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 4),
      child: Text(
        textToShow,
        style: GolosTextStyles.additionalSize14(
          golosTextColors: GolosTextColors.grayDarkVery,
        ),
      ),
    );
  }
}

class _NameAndEditButtonStates extends StatelessWidget {
  final String name;
  final Function onTapEdit;

  const _NameAndEditButtonStates.name({
    Key key,
    @required this.name,
    @required this.onTapEdit,
  }) : super(key: key);

  const _NameAndEditButtonStates.noName({Key key, @required this.onTapEdit})
      : name = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String nameToPut;
    if (name == null) {
      nameToPut = 'Профайл';
    } else {
      nameToPut = name;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              nameToPut,
              style: GolosTextStyles.h1size30(
                  golosTextColors: GolosTextColors.grayDarkVery),
            ),
          ),
          _EditButton(
            onTap: onTapEdit,
          ),
        ],
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  final Function onTap;

  const _EditButton({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.all(4),
      minWidth: 0,
      child: Image.asset(
        'images/edit.png',
        width: 24,
        height: 24,
        alignment: Alignment.center,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _ProfileAvatarStates extends StatelessWidget {
  final String url;
  final String twoLetters;

  const _ProfileAvatarStates.withPicture({Key key, @required this.url})
      : twoLetters = null,
        super(key: key);

  const _ProfileAvatarStates.with2Letters({Key key, @required this.twoLetters})
      : url = null,
        assert(
          twoLetters.length > 0 && twoLetters.length < 3,
          'Letter should be exactly of length 2!',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (url == null && twoLetters != null) {
      result = CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.pineGreen.withOpacity(0.1),
        child: Center(
          child: Text(
            twoLetters,
            style: TextStyle(
              color: AppColors.pineGreen,
              fontWeight: NamedFontWeight.bold,
            ),
          ),
        ),
      );
    } else if (twoLetters == null) {
      result = CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, str) {
          return CircleAvatar(
            radius: 30,
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          );
        },
        imageBuilder: (BuildContext context, ImageProvider imageProvider) {
          return CircleAvatar(
            radius: 30,
            backgroundImage: imageProvider,
          );
        },
      );
    }
    if (result == null)
      throw Exception('_AvatarProfileWithStates must select one of the states');
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 16, left: 16, right: 16),
          child: result,
        ),
      ],
    );
  }
}

class _AvatarProfileBase extends StatelessWidget {
  final Widget child;

  const _AvatarProfileBase({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 16, left: 16, right: 16),
          child: child,
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SimpleDivider(color: Color(0xFFE8E8E8));
  }
}

class _Button extends StatelessWidget {
  const _Button({
    @required this.text,
    this.onPressed,
    this.hasNotification = false,
  });

  final Function onPressed;
  final String text;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: <Widget>[
            Text(
              text,
              style: TextStyle(height: 30 / 17, fontSize: 17),
            ),
            if (hasNotification)
              Container(
                margin: EdgeInsets.only(
                  left: 2,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.primaryRed),
                height: 8,
                width: 8,
              ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Color(0xFF262626).withOpacity(0.5),
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 91),
        CachedNetworkImage(
          imageUrl: profile.avatarUrl,
          placeholder: (context, url) => SizedBox(
            width: 120,
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          imageBuilder: (context, imageProvider) => Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          profile.email,
          style: TextStyle(
            height: 30 / 17,
            fontSize: 17,
            color: Color.fromARGB(128, 38, 38, 38),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 55),
      ],
    );
  }
}

class _ProfileAvatarTwoLetters extends StatelessWidget {
  final String twoLetters;

  const _ProfileAvatarTwoLetters({Key key, @required this.twoLetters})
      : assert(
          twoLetters.length > 0 && twoLetters.length < 3,
          'Letter should be exactly of length 2!',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AvatarProfileBase(
      child: CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.pineGreen.withOpacity(0.1),
        child: Center(
          child: Text(
            twoLetters,
            style: TextStyle(
              color: AppColors.pineGreen,
              fontWeight: NamedFontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatarWithPicture extends StatelessWidget {
  final String url;

  const _ProfileAvatarWithPicture({Key key, @required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AvatarProfileBase(
      child: CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, str) => CircleAvatar(
            radius: 30, child: Center(child: CircularProgressIndicator())),
        imageBuilder: (BuildContext context, ImageProvider imageProvider) {
          return CircleAvatar(
            radius: 30,
            backgroundImage: imageProvider,
          );
        },
      ),
    );
  }
}

//-------- Data used ------------
class ProfileModel {
  const ProfileModel({this.avatarUrl, this.email});

  final String avatarUrl;
  final String email;
}

const profile = ProfileModel(
  avatarUrl:
      'https://images.unsplash.com/photo-1520813792240-56fc4a3765a7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&h=500&q=80',
  email: 'findmeathome@gmail.com',
);
