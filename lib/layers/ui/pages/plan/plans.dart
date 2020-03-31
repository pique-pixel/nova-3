import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rp_mobile/layers/bloc/plans/bloc.dart';
import 'package:rp_mobile/layers/services/plans_service.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/pages/plan/plan_map_detailed_version.dart';
import 'package:rp_mobile/layers/ui/pages/plan/plans_main.dart';
import 'package:rp_mobile/layers/ui/pages/plan/single_text_input_bottom_sheet.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/app/buttons.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_bottom_sheet_decoration.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_sheet.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';

class PlansPageProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlansBloc>(
      create: (context) {
        return PlansBloc(GetIt.instance<PlansService>())..add(OnLoad());
      },
      child: PlansPage(),
    );
  }
}

class PlansPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => PlansPageProvider(),
      );

  @override
  _PlansPageState createState() => _PlansPageState();
}

PlansBloc _bloc(BuildContext context) {
  return BlocProvider.of<PlansBloc>(context);
}

class _PlansPageState extends State<PlansPage> {
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _bloc(context).listen(_handleRouting);
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }

    super.dispose();
  }

  void _handleRouting(PlansState state) async {
    if (context == null) {
      return;
    }

    if (state is RouteToDetailsState) {
      var a = await Navigator.of(context)
          .push(PlanMapPageDetailedVersion.route(state.ref));
      if (a != null && a) {
        _bloc(context).add(OnLoad());
      }
      _bloc(context).add(OnTriggerRoute());
    }

    if (state is RouteToCreatePlanState) {
      Navigator.of(context).push(
        ModalBottomSheetRoute(
          maxHeightFactory: 1,
          builder: (_) => BlocProvider.value(
            value: _bloc(context),
            child: _CreatePlanBottomSheetContent(),
          ),
          decoratorBuilder: (_, child) =>
              AppBottomSheetDecoration(child: child),
        ),
      );

      _bloc(context).add(OnTriggerRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeArea: false,
      theme: AppThemes.materialAppTheme(),
      body: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.plan),
          body: Column(
            children: <Widget>[
              SizedBox(height: 40),
              _Header(),
              Expanded(
                child: PlansMain(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Поездки',
            style: GolosTextStyles.h1size30(
              golosTextColors: GolosTextColors.grayDarkVery,
            ),
          ),
          _ButtonCreate(),
        ],
      ),
    );
  }
}

class _ButtonCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: FlatButton(
        padding: EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Color(0xFFF0F0F0),
        child: Text(
          'Создать',
          style: GolosTextStyles.buttonStyleSize14(
            golosTextColors: GolosTextColors.grayDarkVery,
          ),
        ),
        onPressed: () {
          BlocProvider.of<PlansBloc>(context).add(OnCreatePlanClick());
        },
      ),
    );
  }
}

class _CreatePlanBottomSheetContent
    extends SingleTextInputBottomSheetContent<PlansBloc, PlansState> {
  @override
  bool isLoadingState(PlansState state) => state is CreatingPlanState;

  @override
  bool isFinishState(PlansState state) => state is CreatedPlanState;

  @override
  String title(BuildContext context) {
    return 'Создать новый список';
  }

  @override
  void onSubmit(BuildContext context, String name) {
    _bloc(context).add(OnCreatePlanSubmit(name));
  }

  @override
  PlansBloc bloc(BuildContext context) => _bloc(context);
}
