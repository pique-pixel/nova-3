import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rp_mobile/layers/bloc/auth/login/login_bloc.dart';
import 'package:rp_mobile/layers/bloc/auth/login/login_event.dart'
    as login_event;
import 'package:rp_mobile/layers/bloc/auth/registration/registration_event.dart'
    as registration_event;
import 'package:rp_mobile/layers/bloc/auth/registration/bloc.dart';
import 'package:rp_mobile/layers/services/auth.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/layers/ui/pages/auth/registration.dart';
import 'package:rp_mobile/layers/ui/pages/auth/login.dart';

class Auth extends StatefulWidget {
  static route() => MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<LoginBloc>(
                create: (BuildContext context) => LoginBloc(
                  GetIt.instance<SessionService>(),
                  GetIt.instance<AuthService>(),
                )..add(login_event.OnStart()),
              ),
              BlocProvider<RegistrationBloc>(
                create: (BuildContext context) => RegistrationBloc(
                  GetIt.instance<SessionService>(),
                  GetIt.instance<AuthService>(),
                )..add(registration_event.OnStart()),
              ),
            ],
            child: Auth(),
          ));

  // static route() => MaterialPageRoute(
  //       builder: (context) => BlocProvider(
  //         builder: (context) => LoginBloc(
  //           GetIt.instance<SessionService>(),
  //           GetIt.instance<AuthService>(),
  //         )..add(OnStart()),
  //         child:Auth(),
  //       ),
  //     );

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          bottom: TabBar(
            
            indicatorColor: Color(0xff262626),
            unselectedLabelColor: Color(0xffB2B2B2),
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(
                  'Вход',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Регистрация',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        LoginPage(),
        RegistrationPage(),
      ]),
    );
  }
}
