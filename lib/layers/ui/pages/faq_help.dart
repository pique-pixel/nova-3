import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
//import 'package:rp_mobile/layers/ui/widgets/app/buttons.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/custom_app_bar.dart';
//import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
//import 'package:rp_mobile/layers/ui/pages/faq_form.dart';
//import 'package:rp_mobile/locale/app_localizations.dart';
import 'package:expandable/expandable.dart';

const jsonFaq = [
  {
    "title": "Как работает RUSSPASS",
    "content": "Сервис позволяет получить электронную визу, приобрести авиабилеты и забронировать отель, "
        "спланировать собственный досуг в Москве и других городах России: \r\n"
        "- Спланируйте и оформите поездку на сайте.\r\n"
        "- Скачайте мобильное приложение, пользуйтесь им как городским навигатором и персональным помощником.\r\n"
        "- Получите комплект RUSSPASS с индивидуальными пластиковыми картами (картой ВАШ ДОСУГ для посещения "
        "достопримечательностей и картой ВАШ ТРАНСПОРТ для поездок на общественном транспорте), брошюрой и складной картой города."
  },
  {
    "title": "Сроки действия Туристического пакета",
    "content": "Активировать Туристический пакет можно в течение 30 дней с "
        "момента покупки. \r\n"
        "Туристический пакет считается активированным с момента первого использования билета "
        "(считывания QR кода) и действует в течение срока, указанного в каждом Туристическом пакете."
  },
  {
    "title": "Как получить комплект RUSSPASS",
    "content": "Комплект необходимо забрать в одном из пунктов выдачи. "
        "На стойке выдачи достаточно предъявить код (ID покупки), который можно "
        "найти в Личном кабинете на сайте. \r\n"
        "Список точек выдачи к декабрю 2019 года: \r"
        "Туристско-информационный центр ЦППК "
        "Адрес: Метро Комсомольская, выход к Ярославскому вокзалу, Комсомольская площадь, д.5, стр.1,"
        " режим работы: ежедневно с 09.00 до 20.00. \r\n"
        "Точки выдачи МТС \r\n"
        "1) Адрес: Химки, аэропорт Шереметьево, пом. 3,3 этаж здания Аэроэкспресс, режим работы: Пн-Вс 09:00-21:30 \r\n"
        "2) Адрес: Домодедово аэропорт, 1 (1 этаж), режим работы: Пн-Вс 08:00-22:00  \r\n"
        "3) Адрес: Москва, Внуково аэропорт, терминал А, 1 этаж, режим работы: Пн-Вс 10:00-22:00 \r\n"
        "4) Адрес: Москва г, Комсомольская пл, дом № 3, лит. 1.3, здание пассажирского вокзала «Москва», "
        "режим работы: Пн-Вс 08:00-22:00 \r\n"
        "5) Адрес: Москва г, Земляной Вал ул, дом № 21/2,стр. 1, режим работы: "
        "Пн-Вс 10:00-21:00  \r\n"
        "6) Адрес: Москва г, Тверская Застава пл, дом № 2 стр 1, режим работы: "
        "Пн-Вс 08:30-22:00  \r\n"
        "7) Адрес: Москва, пл. Павелецкая, д.1А, Павелецкий вокзал, режим работы: "
        "Круглосуточно  \r\n"
        "8) Адрес: Москва г, Киевского вокзала пл, дом № 2, режим работы: Вс-Чт 10:00-22:00, Пт-Сб 10:00-23:00"
  },
  {
    "title": "Что делать, если потерял/забыл карту из комплекта RUSSPASS",
    "content": "Комплект при утере не подлежит восстановлению. "
        "Все билеты будут доступны в виде QR-кодов в Личном кабинете на сайте (с возможностью печати) "
        "и в мобильном приложении в разделе «Билеты» (с возможностью считывания QR-кодов со смартфона)."
  },
  {
    "title": "Как использовать карту ВАШ ДОСУГ",
    "content": "Карта ВАШ ДОСУГ — это входной билет в музеи, парки, "
        "на выставки и другие активности (Московская канатная дорога, "
        "автобусные экскурсии в Москве и Санкт-Петербурге и др.). "
        "Просто предъявите карту при входе. "
        "Карта дает право на однократное посещение и использование любой локации или активности из вашего списка."
  },
  {
    "title": "Где хранятся билеты",
    "content":
    "Все оплаченные билеты (приобретенные в рамках Конструктора и Туристического пакета) "
        "сохраняются в виде QR-кодов в Личном кабинете вашего аккаунта на сайте "
        "RUSSPASS и в мобильном приложении в разделе «Билеты». \r\n"
        "Вы можете распечатать билет или воспользоваться смартфоном при "
        "предъявлении QR-кода на входе в локацию."
  }
];

class FaqHelpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => FaqHelpPage());

  @override
  _FaqHelpPageState createState() => _FaqHelpPageState();
}

class _FaqHelpPageState extends State<FaqHelpPage> with SingleTickerProviderStateMixin {
  TabController tabContoller;

  @override
  void initState() {
    super.initState();
    tabContoller = TabController(length: 4, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
//    final l = AppLocalizations.of(context);

    return AppScaffold(
      safeArea: false,
      theme: AppThemes.materialAppTheme(),
      body: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(height: 90, title: 'Частые вопросы', leading: true,),
//          bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.faq),
          body:
          Column(
            children: <Widget>[
              Expanded(
                child: _TabbedState(
                  tabController: tabContoller,
                ),
              ),
            ],
          ),
          /*ListView(
            children: <Widget>[
              for (var item in faqList)
                ExpandCard(title: item["title"], content: item["content"]),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: BigRedRoundedButton(
                  text: l.supportAdd,
                  onPressed: () {
                    Navigator.of(context).push(FaqFormPage.route());
                  },
                ),
              ),
            ],
          ),*/
        ),
      ),
    );
  }
}

class _TabbedState extends StatelessWidget {
  final TabController tabController;

  const _TabbedState({Key key, this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyleSelected = TextStyle(
      color: AppColors.darkGray,
//      color: GolosTextColors.grayDarkVery,
      fontSize: 16,
//      fontFamily: GolosTextStyles.fontFamily,
      height: 1.25,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w500,
    );
    TextStyle textStyleUnselected = TextStyle(
//      color: GolosTextColors.grayDark,
      color: AppColors.gray,
      fontSize: 16,
//      fontFamily: GolosTextStyles.fontFamily,
      height: 1.25,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w400,
    );
    return Column(
      children: <Widget>[
        TabBar(
          indicatorPadding: EdgeInsets.symmetric(horizontal: 12),
          controller: tabController,
          isScrollable: true,
          labelStyle: textStyleSelected,
          unselectedLabelStyle: textStyleUnselected,
          indicatorColor: AppColors.darkGray,
//          indicatorColor: GolosTextColors.grayDarkVery,
          labelPadding: EdgeInsets.symmetric(horizontal: 12),
          tabs: [
            Tab(child: Text("Все")),
            Tab(child: Text("О RUSSPASS")),
            Tab(child: Text("Туристический пакет")),
            Tab(child: Text("Оплата")),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _FaqTabViewAll(),
              _FaqTabView(title:"О RUSSPASS"),
              _FaqTabView(title:"Туристический пакет"),
              _FaqTabView(title:"Оплата"),
            ],
          ),
        ),
      ],
    );
  }
}

class _FaqTabViewAll extends StatelessWidget {
  List<Map<String, dynamic>> faqList = jsonFaq;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              for (var item in faqList)
                ExpandCard(title: item["title"], content: item["content"]),
              /*Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: BigRedRoundedButton(
                  text: l.supportAdd,
                  onPressed: () {
                    Navigator.of(context).push(FaqFormPage.route());
                  },
                ),
              ),*/
            ],
          ),
        ),
      ],
    );
  }
}
class _FaqTabView extends StatelessWidget {
  const _FaqTabView(
      {Key key, this.title})
      : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          title,
//          style: GolosTextStyles.h2size20(golosTextColors: GolosTextColors.grayDarkVery),
        ),
      ),
    );
  }
}

class ExpandCard extends StatelessWidget {
  final String title;
  final String content;

  const ExpandCard({
    Key key,
    this.title,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnExpand: false,
        scrollOnCollapse: true,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            elevation: 0,
            shape: Border(bottom: BorderSide(color: AppColors.lightGray,
                width: 1)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandableNotifier(
//                      initialExpanded: true,
                    child: ExpandablePanel(
                      iconColor: AppColors.darkGray,
                      tapHeaderToExpand: true,
                      tapBodyToCollapse: true,
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: NamedFontWeight.medium,
                            fontSize: 18,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ),
                      expanded: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              content,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                      builder: (_, collapsed, expanded) {
                        return Padding(
                          padding:
                          EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: Expandable(
                            collapsed: collapsed,
                            expanded: expanded,
                            crossFadePoint: 0,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
