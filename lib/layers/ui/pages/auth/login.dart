import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rp_mobile/forms/bloc.dart';
import 'package:rp_mobile/forms/data.dart';
import 'package:rp_mobile/forms/fields.dart';
import 'package:rp_mobile/forms/forms_bloc.dart';
import 'package:rp_mobile/forms/validators.dart';
import 'package:rp_mobile/forms/widgets.dart';
import 'package:rp_mobile/layers/bloc/auth/login/bloc.dart';
import 'package:rp_mobile/layers/services/auth.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/layers/ui/app_icons.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/pages/faq.dart';
import 'package:rp_mobile/layers/ui/pages/explorer.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/scroll_behavior.dart';

class LoginPage extends StatefulWidget {
  // static route() => MaterialPageRoute(
  //       builder: (context) => BlocProvider(
  //         builder: (context) => LoginBloc(
  //           GetIt.instance<SessionService>(),
  //           GetIt.instance<AuthService>(),
  //         )..add(OnStart()),
  //         child: LoginPage(),
  //       ),
  //     );

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<LoginBloc>(context).listen((state) {
      if (state is RouteCloseLogin || state is SuccessState) {
        //TODO падает с ошибкой Failed assertion: line 2829 pos 12: '!_debugLocked': is not true
//        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(ExplorerPage.route());
//        Navigator.of(context).pushReplacement(MainPage.route());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeAreaBottom: false,
      theme: AppThemes.materialAppTheme(),
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LockedState) {
            return _Locked(until: state.until);
          } else {
            return _mapToContent();
          }
        },
      ),
    );
  }

  Widget _mapToContent() {
    return AppForm(
      onSubmit: (data) {
        final email = (data['email'] as StringFormValue)?.data ?? '';
        final password = (data['password'] as StringFormValue)?.data ?? '';
        BlocProvider.of<LoginBloc>(context).add(OnLogin(email, password));
      },
      builder: (context, state) => ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: _LoginContent(),
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      bool isLoading = false;
      if (state is LoadingState) {
        isLoading = true;
      }
      if (state is InitialLoginState) {
        print('state>>>>>>>>>>>>>>>>>>>>>>>InitialLoginState');
        return SizedBox.shrink();
      } else if (state is LoadingFormState) {
        print('state>>>>>>>>>>>>>>>>>>>>>>>LoadingFormState');

        return _mapToLoadingFormState();
        // } else if (state is ErrorState) {
        // return _mapToErrorState(context, state);
      } else if (state is LoginFormState || state is LoadingState) {
        print('state>>>>>>>>>>>>>>>>>>>>>>>LoginFormState');

        return _mapToLoginFormState(context, isLoading: isLoading);
      } else if (state is LoadingState) {
        print('state>>>>>>>>>>>>>>>>>>>>>>>LoadingState');

        return _mapToLoadingState(context);
      } else if (state is LockedState) {
        print('state>>>>>>>>>>>>>>>>>>>>>>>LockedState');

        return SizedBox.shrink();
      } else if (state is SuccessState) {
        print('state>>>>>>>>>>>>>>>>>>>>>>>SuccessState');

        return SizedBox.shrink();
      } else {
        throw UnsupportedError('Unsupported state: $state');
      }
    });
  }

  Widget _mapToLoadingFormState() {
    return SizedBox.shrink();
    // return Center(
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Theme(
    //       data: ThemeData(accentColor: AppColors.primaryRed),
    //       child: CircularProgressIndicator(),
    //     ),
    //   ),
    // );
  }

  Widget _mapToLoginFormState(BuildContext context, {bool isLoading = false}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 9, right: 5),
                                child: SizedBox(
                                  height: 10.0,
                                ),
                              ),
                              _LoginFormFields(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: _Button(
                isEnabled: true,
                isLoading: isLoading,
                isTextButton: false,
                text: 'Войти',
                onPressed: () {
                  BlocProvider.of<FormsBloc>(context).add(OnSubmit());
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _mapToLoadingState(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 9, right: 5),
            child: _FaqButton(),
          ),
        ),
        _LoginFormFields(),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Theme(
            data: ThemeData(accentColor: AppColors.primaryRed),
            child: CircularProgressIndicator(),
          ),
        ),
        SizedBox(height: 24)
      ],
    );
  }
}

class _Locked extends StatelessWidget {
  final String until;

  const _Locked({Key key, @required this.until}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 64),
        Text(
          'Вход заблокирован до $until!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: NamedFontWeight.semiBold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Вы привысили количество попыток входа',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _LoginFormFields extends StatefulWidget {
  const _LoginFormFields({Key key}) : super(key: key);

  @override
  __LoginFormFieldsState createState() => __LoginFormFieldsState();
}

class __LoginFormFieldsState extends State<_LoginFormFields> {
  bool obscureText = true;
  _onToggle() {
    this.setState(() {
      obscureText = !obscureText;
    });
  }

  Widget _eyeIcon(bool isVisible) {
    return SizedBox(
        height: 20,
        child: Icon(
          isVisible ? AppIcons.eye : AppIcons.eye_off,
          color: Colors.black54,
        ),);
  }

  // Widget _cancelIcon() {
  //   return SizedBox(
  //     // height: 20,
  //     child: Image.asset(
  //       'images/cancel.png',
  //       height: 20.0,
  //       width: 20.0,
  //       color: Colors.black45,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('E-mail'),
          SizedBox(
            height: 54.0,
            child: _TextInput(
              validators: [
                // RequiredValidator(),
                EmailValidator(),
              ],
              labelText: 'Введите e-mail',
              fieldName: 'email',
            ),
          ),
          SizedBox(height: 50),
          Text('Пароль'),
          BlocBuilder<FormsBloc, FormsState>(
            builder: (context, state) {
              bool isLoading = false;
              if (state is LoadingState) {
                isLoading = true;
              }
              return SizedBox(
                height: 54.0,
                child: _TextInput(
                  validators: [
                    // RequiredValidator(),
                    // PasswordValidator(),
                  ],
                  labelText: 'Введите пароль',
                  fieldName: 'password',
                  obscureText: obscureText,
                  suffixIcon: Container(
                    padding: EdgeInsets.only(
                        top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
                    child: InkWell(
                        onTap: () {
                          _onToggle();
                        },
                        child: _eyeIcon(obscureText)),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 26),
          Align(
            alignment: Alignment.centerRight,
            child: _Button(
              isTextButton: true,
              text: 'Забыли пароль?',
              onPressed: () {},
            ),
          ),
          BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is ErrorState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    state.error.localize(context),
                    style: TextStyle(
                      color: AppColors.defaultValidationError,
                      fontSize: 18,
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _FaqButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        AppIcons.question,
        color: Theme.of(context).accentColor,
        size: 24,
      ),
      onPressed: () {
        Navigator.push(context, FaqPage.route());
      },
    );
  }
}

class _TextInput extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final String fieldName;
  final Widget suffixIcon;
  final List<Validator> validators;

  const _TextInput(
      {Key key,
      this.labelText,
      this.obscureText = false,
      this.fieldName,
      this.suffixIcon,
      this.validators})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppFormTextField(
      // expands: true,
      fieldName: fieldName,
      obscureText: obscureText,
      initValue: () => StringFormValue(),
      cursorColor: AppColors.primaryRed,
      validators: validators,
      style: TextStyle(
        fontFamily: 'PT Russia Text',
        fontSize: 17,
        letterSpacing: -0.3,
        height: 28 / 17,
      ),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        // suffix: suffixIcon,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AppColors.darkGray,
          ),
        ),
      ),
    );
  }
}

TextStyle _labelStyle = TextStyle(
  color: AppColors.darkGray.withOpacity(0.4),
  fontFamily: 'PT Russia Text',
  fontSize: 17,
  letterSpacing: -0.3,
  height: 24 / 17,
);

class _Button extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isLoading;
  final bool isTextButton;

  const _Button(
      {Key key,
      @required this.text,
      this.onPressed,
      this.isEnabled = false,
      this.isLoading = false,
      this.isTextButton})
      : super(key: key);

  @override
  __ButtonState createState() => __ButtonState();
}

class __ButtonState extends State<_Button> {
  bool _isPressed = false;

  buttonStyle(pressed) => TxtStyle()
    ..background.color(widget.isEnabled
        ?
        AppColors.primaryRed
        // Color(0xffF7464E)
        : pressed ? AppColors.middleRed : Color(0xffE4E4E4))
    ..alignmentContent.center()
    ..textColor(Colors.white)
    ..borderRadius(all: 6)
    ..height(50)
    ..fontSize(17)
    ..margin(horizontal: 15, vertical: 8)
    ..fontWeight(NamedFontWeight.semiBold)
    ..ripple(true, splashColor: Colors.white24, highlightColor: Colors.white10)
    // ..boxShadow(
    //     blur: pressed ? 17 : 0,
    //     offset: [0, pressed ? 4 : 0],
    //     color: rgba(247, 70, 78, 0.5))
    ..animate(150, Curves.easeOut);

  GestureClass buttonGestures() => GestureClass()
    ..isTap((isPressed) => setState(() => _isPressed = isPressed))
    ..onTap(widget.onPressed);

  @override
  Widget build(BuildContext context) {
    // return Txt(
    //   widget.text,
    //   style: buttonStyle(_isPressed),
    //   gesture: buttonGestures(),
    // );

    return widget.isTextButton
        ? Text(widget.text)
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              splashColor: Colors.white24,
              highlightColor: Colors.white10,
              onPressed: widget.isLoading ? () {} : widget.onPressed,
              color: widget.isEnabled
                  ? AppColors.primaryRed
                  : _isPressed ? AppColors.middleRed : Color(0xffE4E4E4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  !widget.isLoading
                      ? SizedBox.shrink()
                      : CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white)),
                  !widget.isLoading
                      ? SizedBox.shrink()
                      : SizedBox(
                          width: 20,
                        ),
                  Text(
                    widget.isLoading ? 'Please wait' : widget.text,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: NamedFontWeight.semiBold),
                  ),
                ],
              ),
            ),
          );
  }
}
