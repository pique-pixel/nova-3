import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/widgets/app/buttons.dart';
import 'package:rp_mobile/layers/ui/pages/plan/plan_empty.dart';
import 'package:rp_mobile/layers/ui/pages/plan/plan_fill.dart';

class PlansMain extends StatelessWidget {
  PlansMain({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Tabs();
  }
}

class _Tabs extends StatefulWidget {
  _Tabs({
    Key key,
  }) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<_Tabs> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TabBar(
            indicatorPadding: EdgeInsets.all(0),
            controller: _tabController,
            isScrollable: true,
            labelStyle: TextStyle(
              color: AppColors.darkGray,
              fontSize: 16,
              height: 1.25,
              letterSpacing: -0.1,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: TextStyle(
              color: AppColors.darkGray,
              fontSize: 16,
              height: 1.25,
              letterSpacing: -0.1,
              fontWeight: FontWeight.w400,
            ),
            indicatorColor: AppColors.darkGray,
            labelPadding: EdgeInsets.symmetric(horizontal: 12),
            tabs: [
              Tab(child: Text("Предстоящие")),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              PlanFill(),
            ],
          ),
        ),
      ],
    );
  }
}
