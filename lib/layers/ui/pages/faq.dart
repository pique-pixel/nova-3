import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
//import 'package:rp_mobile/layers/ui/widgets/app/buttons.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/custom_app_bar.dart';
//import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:rp_mobile/layers/ui/pages/faq_help.dart';
import 'package:rp_mobile/layers/ui/pages/faq_form.dart';
import 'package:rp_mobile/locale/app_localizations.dart';
import 'package:expandable/expandable.dart';
import 'package:url_launcher/url_launcher.dart';

const jsonFaq = [
  {
    "title": "F.A.Q",
    "icon": Icons.help_outline,
    "page": "help"
  },
  {
    "title": "Позвонить",
    "icon": Icons.phone_in_talk,
    "page": "call"
  },
  {
    "title": "Написать обращение",
    "icon": Icons.mail_outline,
    "page": "mail"
  },
  {
    "title": "Условия и правила",
    "icon": Icons.content_paste,
    "page": "rules"
  },
  {
    "title": "Конфиденциальность",
    "icon": Icons.lock_outline,
    "page": "lock"
  },
  {
    "title": "Контакты",
    "icon":Icons.description,
    "page": "contact"
  }
];

class FaqPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => FaqPage());

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<Map<String, dynamic>> faqList = jsonFaq;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return AppScaffold(
      safeArea: false,
      theme: AppThemes.materialAppTheme(),
      body: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(height: 77, title: "Поддержка"),
//          bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.faq),
          body:
          Padding(
          padding: EdgeInsets.only(top:20.0),
          child:
            ListView(
            children: <Widget>[

              for (var item in faqList)
                _IconList(
                  title: item["title"],
                  icon: item["icon"],
                  page: item["page"],
                ),
//                ExpandCard(title: item["title"], content: item["content"]),

            ],
          ),
        ),
        ),
      ),
    );
  }
}

class _IconList extends StatefulWidget {
  final String title;
  final IconData icon;
  final String page;

  const _IconList({
    Key key,
    this.title,
    this.icon,
    this.page,
  }) : super(key: key);

  @override
  _IconListState createState() => _IconListState();
}
class _IconListState extends State<_IconList> {

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
    return Column(
        children: <Widget>[
          Container(
            height: 56,
            child:
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child:
              GestureDetector(
              onTap: () {
                switch (widget.page) {
                  case "help":
                    Navigator.of(context).push(FaqHelpPage.route());
                    break;
                  case "call":
                    _callPhone();
                    break;
                  case "mail":
                    Navigator.of(context).push(FaqFormPage.route());
                    break;
                }
              },
                child: Row(
                  children: <Widget>[
//                    Icon(widget.icon, color: Colors.red),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFF2F2F2),
                      child: Icon(widget.icon,
                        color: Color(0xFF787878),),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            fontWeight: NamedFontWeight.semiBold,
                            color: Color(0xFF262626), fontSize: 16),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: Color(0xFFB2B2B2),
                      size: 16,
                    ),
                  ]
              ),
              ),
            ),
          ),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
      child:
      Container(
            height: 1,
            color: AppColors.backgroundGray,
          ),
    ),
        ]
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
