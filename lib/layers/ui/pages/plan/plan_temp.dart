import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/custom_app_bar.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/date_range_picker_own.dart' as Drp;
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';

final List<ListTempData> tempData = [
  ListTempData(
    title: "Спокойный",
    tempText: "2-3 ч/день",
    level: "low",
  ),
  ListTempData(
    title: "Средний",
    tempText: "4-5 ч/день",
    level: "medium",
  ),
  ListTempData(
    title: "Насыщенный",
    tempText: "5-9 ч/день",
    level: "hard",
  ),
];

class ListTempData {
  final String title;
  final String tempText;
  final String level;

  ListTempData({
    this.title,
    this.tempText,
    this.level,
  });
}

class PlanTempPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => PlanTempPage());

  @override
  _PlanTempPageState createState() => _PlanTempPageState();
}

class _PlanTempPageState extends State<PlanTempPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeArea: false,
      theme: AppThemes.materialAppTheme(),
      body: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            height: 90,
            title: "Темп поездки",
            leading: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  "Выберите, какой темп поездки для вас удобен",
                  style: TextStyle(
                    fontWeight: NamedFontWeight.regular,
                    fontSize: 14,
                    color: AppColors.mediumGray,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListView.builder(
                          itemCount: tempData.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return _TempCard(
                              tempCartData: tempData[index],
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Даты поездки",
                                style: TextStyle(
                                  fontWeight: NamedFontWeight.bold,
                                  fontSize: 24,
                                  color: AppColors.darkGray,
                                ),
                              ),
                              Text(
                                "Спланируйте вашу поездку вручную",
                                style: TextStyle(
                                  fontWeight: NamedFontWeight.regular,
                                  fontSize: 14,
                                  color: AppColors.mediumGray,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await Drp.showRussPassRangeDatePicker(
                                    context: context,
                                    initialFirstDate: DateTime.now(),
                                    initialLastDate: DateTime.now(),
                                    firstDate: DateTime(2018),
                                    lastDate: DateTime(2022),
                                    locale: Locale('ru'),
                                    initialDatePickerMode: Drp.DatePickerMode.day,
                                    dayTextStyle: GolosTextStyles.h3size16(
                                            golosTextColors: GolosTextColors.grayDarkVery)
                                        .copyWith(height: 1.5),
                                    yearTextStyle: GolosTextStyles.h2size20(
                                            golosTextColors: GolosTextColors.grayDarkVery)
                                        .copyWith(height: 1.7),
                                    backgroundColor: Colors.white,
                                    saveText: "Сохранить",
                                    cancelText: 'Отменить',
                                    monthTextStyle: GolosTextStyles.mainTextSize16(
                                        golosTextColors: GolosTextColors.grayDarkVery),
                                    onPressedSave: (List<DateTime> result) async {
                                      print("Number of selected dates: ${result.length}");
                                      if (result.length > 0) print("First date: ${result[0]}");
                                      if (result.length > 1) print("Second date: ${result[1]}");
                                      //Just to show loading indicator before calendar closes
                                      await Future.delayed(Duration(seconds: 3));
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  height: 60,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundGray,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 24.0,
                                              height: 24.0,
                                              child: Icon(
                                                Icons.calendar_today,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 6),
                                              child: Text(
                                                "Выбрать даты",
                                                style: TextStyle(
                                                  fontWeight: NamedFontWeight.bold,
                                                  fontSize: 16,
                                                  color: AppColors.darkGray,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

class _TempCard extends StatelessWidget {
  final ListTempData tempCartData;

  const _TempCard({Key key, this.tempCartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double listHeight = 80;
    return GestureDetector(
      onTap: () {
        print(tempCartData.level);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 10),
        height: listHeight,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.backgroundGray,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: Icon(
                          Icons.access_alarm,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text(
                          tempCartData.title,
                          style: TextStyle(
                            fontWeight: NamedFontWeight.bold,
                            fontSize: 16,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 24.0,
                        height: 24.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text(
                          tempCartData.tempText,
                          style: TextStyle(
                            fontWeight: NamedFontWeight.bold,
                            fontSize: 14,
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
