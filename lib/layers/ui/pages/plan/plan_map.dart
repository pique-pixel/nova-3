import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:division/division.dart';
import 'package:rp_mobile/layers/ui/pages/plan/plan_map_detailed_version.dart';
import 'package:rp_mobile/layers/ui/pages/plan/plan_temp.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PlanMapPage extends StatefulWidget {
  const PlanMapPage({Key key}) : super(key: key);

  static route(String ref) => MaterialPageRoute(
        builder: (context) => PlanMapPage(),
      );

  @override
  _PlanMapPageState createState() => _PlanMapPageState();
}

class _PlanMapPageState extends State<PlanMapPage> {
  YandexMapController yandexMapController;
  YandexMap _yandexMap;
  PanelController _pc = new PanelController();

  final double _initFabHeight = 160.0;
  double _panelHeightOpen;
  double _panelHeightClosed = 140.0;
  double _fabPos = 1;

  @override
  void initState() {
    super.initState();
    _yandexMap = YandexMap(
      onGeoObjectTap: (geoObject) {
        debugPrint('LATITUDE: ${geoObject.point.latitude}');
        debugPrint('LONGITUDE: ${geoObject.point.longitude}');
      },
      onMapCreated: (controller) async {
        yandexMapController = controller;
      },
    );
  }

  double zoomButtonsTopCalculatingFunction({
    @required double x,
    @required double screenHeight,
    @required double topPadding,
  }) {
    return (screenHeight +
                topPadding -
                (x * (_panelHeightOpen - _panelHeightClosed))) /
            2 -
        _panelHeightClosed;
  }

  double posButtonsTopCalculatingFunction({@required double x}) {
    return _initFabHeight + x * (_panelHeightOpen - _panelHeightClosed);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;
    double topPadding = mediaQuery.padding.top;
    _panelHeightOpen = screenHeight * .55;
    return AppScaffold(
      theme: AppThemes.materialAppTheme(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            defaultPanelState: PanelState.OPEN,
            controller: _pc,
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _yandexMap,
            panelSnapping: true,
            panelBuilder: (sc) => itemsPlan(
              sc: sc,
              onPlusButtonPressed: () {
                Navigator.of(context)
                    .pushReplacement(PlanMapPageDetailedVersion.route('1'));
              },
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6.0),
              topRight: Radius.circular(6.0),
            ),
            onPanelSlide: (double pos) => setState(() {
//              print(pos);
              _fabPos = pos;
            }),
          ),
          Positioned(
            top: 20,
            left: 16,
            child: _BackButton(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 20,
            right: 16,
            child: _SearchButton(
              onTap: () {
                print("Make Search");
              },
            ),
          ),
          Positioned(
            top: zoomButtonsTopCalculatingFunction(
              x: _fabPos,
              screenHeight: screenHeight,
              topPadding: topPadding,
            ),
            right: 16,
            child: _ZoomButtons(
              onTapZoomIn: () async {
                print("ZoomIN");
                await yandexMapController.zoomIn();
              },
              onTapZoomOut: () async {
                print("ZoomOUT");
                await yandexMapController.zoomOut();
              },
            ),
          ),
          Positioned(
            bottom: posButtonsTopCalculatingFunction(x: _fabPos),
            right: 16,
            child: _LocationButton(
              onTap: () {
                print("Go to my location");
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget itemsPlan({
    ScrollController sc,
    Function onPlusButtonPressed,
  }) {
    return Column(
      children: [
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _GrayMark(),
              _Header(),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 8,
                color: AppColors.backgroundGray,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Добавить к поездке",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: NamedFontWeight.bold,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ),
                    _PlusButton(
                      onPressed: onPlusButtonPressed,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 0,
                  color: Colors.black26,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white,
            child: ListView.builder(
              controller: sc,
              itemCount: mockData.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _BottomSliderSheetCard(
                  bottomSliderSheetData: mockData[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

//mock Data
final List<BottomSliderSheetData> mockData = [
  BottomSliderSheetData(
    title: "Затейливая роспись глав Храма Василия Блаженного",
    subtitle: "Здесь проводят ~ 30 мин",
    urlPic:
        "https://api.russpass.iteco.dev/attach/image?file=content/4672835612.jpg",
  ),
  BottomSliderSheetData(
    title: "Канатная дорога на Воробьевых горах",
    subtitle: "Здесь проводят ~ 40 мин",
    urlPic:
        "https://api.russpass.iteco.dev/attach/image?file=content/4672835640.jpg",
  ),
  BottomSliderSheetData(
    title: "Музей-заповедник Царицино",
    subtitle: "Здесь проводят ~ 2 часа 30 мин",
    urlPic:
        "https://api.russpass.iteco.dev/attach/image?file=content/799417174.jpg",
  ),
  BottomSliderSheetData(
    title: "Смотровая площадка телебашни Останкино",
    subtitle: "Здесь проводят ~ 1 час",
    urlPic:
        "https://api.russpass.iteco.dev/attach/image?file=content/800340695.jpg",
  ),
  BottomSliderSheetData(
    title: "Затейливая роспись глав Храма Василия Блаженного",
    subtitle: "Здесь проводят ~ 30 мин",
    urlPic:
        "https://api.russpass.iteco.dev/attach/image?file=content/4672835612.jpg",
  ),
  BottomSliderSheetData(
    title: "Затейливая роспись глав Храма Василия Блаженного",
    subtitle: "Здесь проводят ~ 30 мин",
    urlPic:
        "https://api.russpass.iteco.dev/attach/image?file=content/4672835612.jpg",
  ),
];

class _BottomSliderSheetCard extends StatelessWidget {
  final BottomSliderSheetData bottomSliderSheetData;

  const _BottomSliderSheetCard({Key key, this.bottomSliderSheetData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageSide = 80;
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: imageSide,
                width: imageSide,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        bottomSliderSheetData.urlPic),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      bottomSliderSheetData.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: NamedFontWeight.regular,
                        color: AppColors.darkGray,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      bottomSliderSheetData.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: NamedFontWeight.regular,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.black38,
                ),
                onPressed: () {
                  showItemDialog(context);
                },
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Divider(
            height: 0,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }

  Future showItemDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                  color: AppColors.backgroundGray,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ModalButton(
                      text: "Выбрать дату",
                      background: AppColors.backgroundGray,
                      color: AppColors.darkGray,
                      radius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      onTap: () {
                        print("add date");
                      },
                    ),
                    Divider(
                      height: 0,
                      color: Colors.black26,
                    ),
                    _ModalButton(
                      text: "Удалить",
                      background: AppColors.backgroundGray,
                      color: AppColors.darkGray,
                      radius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      onTap: () {
                        print("delete");
                        Navigator.of(context).pop();
                        showDeleteDialog(
                          context: context,
                          title: "Удалить активность",
                          text:
                              "Если удалить эту активность, она будет исключена "
                              "из вашего плана поездки.",
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _ModalButton(
                text: "Отменить",
                background: AppColors.white,
                color: AppColors.darkGray,
                radius: BorderRadius.circular(16.0),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future showDeleteDialog({
    @required BuildContext context,
    @required String title,
    @required String text,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 180,
            decoration: new BoxDecoration(
              color: AppColors.backgroundGray,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: NamedFontWeight.bold,
                          color: AppColors.darkGray,
                        ),
                      ),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: NamedFontWeight.regular,
                          color: AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  color: Colors.black26,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: _ModalButton(
                        text: "Отменить",
                        background: AppColors.backgroundGray,
                        color: AppColors.darkGray,
                        radius:
                            BorderRadius.only(bottomLeft: Radius.circular(16)),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      width: 0.3,
                      height: 60,
                      color: Colors.black26,
                    ),
                    Expanded(
                      child: _ModalButton(
                        text: "Удалить",
                        background: AppColors.backgroundGray,
                        color: AppColors.primaryRed,
                        radius:
                            BorderRadius.only(bottomRight: Radius.circular(16)),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class BottomSliderSheetData {
  final String title;
  final String subtitle;
  final String urlPic;

  BottomSliderSheetData({this.title, this.subtitle, this.urlPic});
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Москва",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: NamedFontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
          Text(
            "20 точек: ~ 15 часов",
            style: TextStyle(
              fontSize: 16,
              fontWeight: NamedFontWeight.regular,
              color: AppColors.mediumGray,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              _ListButton(
                onPressed: () {},
              ),
              SizedBox(width: 16),
              Expanded(
                child: _PlanButton(
                  onPressed: () {
                    Navigator.of(context).push(PlanTempPage.route());
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ModalButton extends StatelessWidget {
  final String text;
  final Color background;
  final Color color;
  final BorderRadius radius;
  final Function onTap;

  const _ModalButton({
    Key key,
    this.text,
    this.background,
    this.color,
    this.radius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: new BoxDecoration(
          color: background,
          borderRadius: radius,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: NamedFontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlusButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _PlusButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: 24.0,
          width: 24.0,
          child: IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.add_circle,
              color: AppColors.primaryRed,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

class _ListButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _ListButton({Key key, this.onPressed}) : super(key: key);

  @override
  _ListButtonState createState() => _ListButtonState();
}

class _ListButtonState extends State<_ListButton> {
  bool _isPressed = false;

  buttonStyle(pressed) => ParentStyle()
    ..background.color(AppColors.primaryRed)
    ..alignmentContent.center()
    ..borderRadius(all: 4)
    ..height(42)
    ..padding(left: 10, right: 10)
    ..ripple(true)
    ..animate(150, Curves.easeOut);

  GestureClass buttonGestures() => GestureClass()
    ..isTap((isPressed) => setState(() => _isPressed = isPressed))
    ..onTap(widget.onPressed);

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: buttonStyle(_isPressed),
      gesture: buttonGestures(),
      child: Icon(
        Icons.format_list_bulleted,
        color: Colors.white.withOpacity(0.6),
      ),
    );
  }
}

class _PlanButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _PlanButton({Key key, this.onPressed}) : super(key: key);

  @override
  _PlanButtonState createState() => _PlanButtonState();
}

class _PlanButtonState extends State<_PlanButton> {
  bool _isPressed = false;

  buttonStyle(pressed) => ParentStyle()
    ..background.color(AppColors.backgroundGray)
    ..alignmentContent.center()
    ..borderRadius(all: 4)
    ..height(42)
    ..padding(left: 10, right: 10)
    ..ripple(true)
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
        'Спланировать поездку',
        style: TextStyle(fontSize: 14, color: AppColors.darkGray),
      ),
    );
  }
}

class _GrayMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      height: 4,
      width: 32,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final Function onTap;

  const _BackButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ButtonBaseForMap(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 2),
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  final Function onTap;

  const _SearchButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ButtonBaseForMap(
      onTap: onTap,
      child: Icon(
        Icons.search,
        color: Colors.black,
        size: 26,
      ),
    );
  }
}

class _ZoomButtons extends StatelessWidget {
  final Function onTapZoomIn;
  final Function onTapZoomOut;

  const _ZoomButtons({Key key, this.onTapZoomIn, this.onTapZoomOut})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _ButtonBaseForMap(
          onTap: onTapZoomIn,
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 30,
          ),
        ),
        SizedBox(height: 4),
        _ButtonBaseForMap(
          onTap: onTapZoomOut,
          child: Icon(
            Icons.remove,
            color: Colors.black,
            size: 30,
          ),
        ),
      ],
    );
  }
}

class _LocationButton extends StatelessWidget {
  final Function onTap;

  const _LocationButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ButtonBaseForMap(
      onTap: onTap,
      child: Icon(
        Icons.near_me,
        color: Colors.black,
        size: 20,
      ),
    );
  }
}

class _ButtonBaseForMap extends StatelessWidget {
  final Widget child;
  final Function onTap;

  const _ButtonBaseForMap({Key key, @required this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.white,
      onPressed: onTap,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      mini: true,
      child: child,
    );
  }
}
