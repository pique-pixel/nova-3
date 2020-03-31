import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rp_mobile/forms/data.dart';
import 'package:rp_mobile/forms/fields.dart';
import 'package:rp_mobile/forms/forms_bloc.dart';
import 'package:rp_mobile/forms/forms_event.dart';
import 'package:rp_mobile/forms/validators.dart';
import 'package:rp_mobile/forms/widgets.dart';
import 'package:rp_mobile/layers/bloc/auth/registration/bloc.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/pages/explorer.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/scroll_behavior.dart';

class RegistrationPage extends StatefulWidget {
  // static route() => MaterialPageRoute(
  //       builder: (context) => BlocProvider(
  //         builder: (context) => LoginBloc(
  //           GetIt.instance<SessionService>(),
  //           GetIt.instance<AuthService>(),
  //         )..add(OnStart()),
  //         child: RegistrationPage(),
  //       ),
  //     );

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<RegistrationBloc>(context).listen((state) {
      if (state is RouteCloseRegistration || state is SuccessState) {
        print("Show Sucess Message");
        displayDialog();
        // Navigator.of(context).pop();
        // Navigator.of(context).pushReplacement(ExplorerPage.route());
//        Navigator.of(context).pushReplacement(MainPage.route());
      }
    });
  }

  void displayDialog() async{
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
            title: new Text("Message"),
            content: Padding(
              padding:EdgeInsets.symmetric(vertical: 10),
              child:new Text("Your registration is completed sucessfully")
            
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: (){
                  Navigator.pop(context);
                },
                  isDefaultAction: true, child: new Text("Close"))
            ],
          ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeAreaBottom: false,
      theme: AppThemes.materialAppTheme(),
      body: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          if (state is LockedState) {
            return _Locked(until: state.until);
          }
          //   else if (state is LoadingState) {
          //    return _mapToLoadingFormState();
          //    // } else if (state is ErrorState) {
          //    // return _mapToErrorState(context, state);
          //  }
          else {
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
        final confirmPassword =
            (data['matchingPassword'] as StringFormValue)?.data ?? '';

        BlocProvider.of<RegistrationBloc>(context)
            .add(OnRegistration(email, password, confirmPassword));
      },
      builder: (context, state) => ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: Stack(
          children: <Widget>[
            _RegistrationContent(),
          ],
        ),
      ),
    );
  }
}

class _RegistrationContent extends StatefulWidget {
  @override
  _RegistrationContentState createState() => _RegistrationContentState();
}

class _RegistrationContentState extends State<_RegistrationContent> {
  bool isCheckBoxEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        bool isLoading = false;
        if (state is LoadingState) {
          isLoading = true;
        }
        return Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 180),
                height: MediaQuery.of(context).size.height,
                child: _RegistrationFormFields(
                  oncheckBoxTapp: (value) {
                    setState(() {
                      print(value);
                      isCheckBoxEnabled = value;
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _Button(
                isEnabled: isCheckBoxEnabled,
                isLoading: isLoading,
                text: 'Зарегистрироваться',
                onPressed: () {
                  if (!isCheckBoxEnabled) {
                    return;
                  }
                  BlocProvider.of<FormsBloc>(context).add(OnSubmit());
                },
              ),
            )
          ],
        );
      },
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

class _RegistrationFormFields extends StatefulWidget {
  final ValueChanged<bool> oncheckBoxTapp;
  _RegistrationFormFields({this.oncheckBoxTapp});
  @override
  __RegistrationFormFieldsState createState() =>
      __RegistrationFormFieldsState();
}

class __RegistrationFormFieldsState extends State<_RegistrationFormFields> {
  bool obscureTextPassword = true;
  bool obscureTextRepeatPassword = true;
  bool isChecked = false;
  String checkBoxCheckedImage = 'images/checkbox.png';
  String checkBoxUnCheckedImage = 'images/empty_checkbox.png';

  __onTogglePassword() {
    this.setState(() {
      obscureTextPassword = !obscureTextPassword;
    });
  }

  __onToggleRepeatPassword() {
    this.setState(() {
      obscureTextRepeatPassword = !obscureTextRepeatPassword;
    });
  }

  _isChecked() {
    this.setState(() {
      isChecked = !isChecked;
      widget.oncheckBoxTapp(isChecked);
    });
  }

  Widget _eyeIcon() {
    return SizedBox(
      // height: 20,
      child: Image.asset(
        'images/eye.png',
        height: 25.0,
        width: 25.0,
        color: Colors.black45,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
          SizedBox(height: 35),
          Text('Пароль'),
          SizedBox(
            height: 54.0,
            child: _TextInput(
              validators: [RequiredValidator(), PasswordValidator()],
              labelText: 'Придумай��е пароль',
              fieldName: 'password',
              obscureText: obscureTextPassword,
              suffixIcon: Container(
                padding: EdgeInsets.only(
                    top: 0.0, left: 10.0, right: 0.0, bottom: 0.0),
                child: InkWell(
                    onTap: () {
                      __onTogglePassword();
                    },
                    child: _eyeIcon()),
              ),
            ),
          ),
          SizedBox(height: 35),
          Text('Пароль'),
          SizedBox(
            height: 54.0,
            child: _TextInput(
              validators: [PasswordValidator()],
              labelText: 'Повторите пароль',
              fieldName: 'matchingPassword',
              obscureText: obscureTextRepeatPassword,
              suffixIcon: Container(
                padding: EdgeInsets.only(
                    top: 5.0, left: 10.0, right: 0.0, bottom: 0.0),
                child: InkWell(
                    onTap: () {
                      __onToggleRepeatPassword();
                    },
                    child: _eyeIcon()),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          BlocBuilder<RegistrationBloc, RegistrationState>(
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
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    _isChecked();
                  },
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    child: Image.asset(isChecked
                        ? checkBoxCheckedImage
                        : checkBoxUnCheckedImage),
                  )),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: RichText(
                    text: TextSpan(
                        text: 'Я принимаю условия ',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'соглашения\n',
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                          TextSpan(
                            text:
                                'и даю согласие на обработку моих\nперсональных данных',
                            style: TextStyle(fontSize: 18),
                          )
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
      this.validators = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppFormTextField(
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
        // suffixIcon: suffixIcon,
        suffix: suffixIcon,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AppColors.darkGray,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AppColors.darkGray,
          ),
        ),
        labelText: labelText,
        hasFloatingPlaceholder: false,
        labelStyle: _labelStyle,
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

  const _Button(
      {Key key,
      @required this.text,
      this.onPressed,
      this.isEnabled = false,
      this.isLoading = false})
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
        //  Color(0xffF7464E)
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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                  color: Colors.white, fontWeight: NamedFontWeight.semiBold),
            ),
          ],
        ),
      ),
    );
  }
}
