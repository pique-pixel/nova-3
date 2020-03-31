import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/app/buttons.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/custom_app_bar.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:rp_mobile/locale/app_localizations.dart';

class FaqFormPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => FaqFormPage());

  @override
  _FaqFormState createState() => _FaqFormState();
}

class _FaqFormState extends State<FaqFormPage> {
  final _formKey = GlobalKey<FormState>();
  static bool _autoValidate = false;

  List<String> _questions = [
    'Что такое Туристический пакет',
    'Сроки действия Туристического пакета',
    'Как получить комплект RUSSPASS',
    'Что делать, если потерял/забыл карту из комплекта RUSSPASS',
    'Как использовать карту ВАШ ДОСУГ',
    'Где хранятся билеты'
  ];
  String _selectedQuestion;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return AppScaffold(
        safeArea: false,
        theme: AppThemes.materialAppTheme(),
        body: SafeArea(
            child: Scaffold(
          appBar: CustomAppBar(
              height: 90,
              title: "Вопрос",
              leading: true),
          bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.faq),
          body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return new SingleChildScrollView(
                reverse: false,
                child: new ConstrainedBox(
                    constraints:
                        new BoxConstraints(minHeight: constraints.maxHeight),
                    child: new IntrinsicHeight(
                        child: new Center(
                            child: Container(
//                            width: 300,
                                margin: EdgeInsets.all(20.0),
//      width: double.infinity,
//      width: MediaQuery.of(context).size.width,
                                child: new Form(
                                    key: _formKey,
                                    autovalidate: _autoValidate,
                                    child: new Column(children: <Widget>[
                                      dropdownForm(
                                        "Тема обращения",
                                        "Заполните поле",
                                        true,
                                      ),
                                      textForm(
                                        "Текст сообщения",
                                        "Заполните поле",
                                        true,
                                      ),
                                      textForm(
                                        "E-mail",
                                        "Заполните поле",
                                        false,
                                      ),
                                      textForm(
                                        "Имя",
                                        "Заполните поле",
                                        true,
                                      ),
                                      textForm(
                                        "Фамилия",
                                        "Заполните поле",
                                        false,
                                      ),
                                      textForm(
                                        "Отчество",
                                        "Заполните поле",
                                        false,
                                      ),
                                      BigRedRoundedButton(
                                        text: "Отправить сообщение",
                                        onPressed: () {
                                          final form = _formKey.currentState;
                                          if (form.validate()) {
//                                            form.save();
                                            Navigator.pop(context);
                                          } else {
//    If all data are not valid then start auto validation.
                                            setState(() {
                                              _autoValidate = true;
                                            });
                                          }
                                        },
                                      )
                                    ])))))));
          }),
        )));
  }

  Widget dropdownForm(hint, error, validate) {
    return FormField<String>(
      validator: (validate
          ? (value) {
              if (value == null) {
                return error;
              }
              return null;
            }
          : null),
      onSaved: (value) {},
      builder: (
        FormFieldState<String> state,
      ) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                height: 66,
                child: new InputDecorator(
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                        width: 0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                        width: 0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                        width: 0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                        width: 0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(
                          width: 0,
                        )),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(
                          width: 0,
                        )),
                    errorStyle: TextStyle(
                      height: 0.5,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  child: DropdownButton<String>(
                    underline: SizedBox(),
                    isExpanded: true,
                    hint: new Text(hint),
                    value: _selectedQuestion,
                    onChanged: (String newValue) {
                      setState(() {
                        state.didChange(newValue);
                        _selectedQuestion = newValue;
                      });
                    },
                    items: _questions.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 6.0),
              child: Text(
                state.hasError ? state.errorText : '',
                style:
                    TextStyle(color: Colors.redAccent.shade700, fontSize: 12.0),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget textForm(hint, error, validate) {
    return SizedBox(
      height: 86,
      child: TextFormField(
        decoration: InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              width: 0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              width: 0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              width: 0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              width: 0,
            ),
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(
                width: 0,
              )),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(
                width: 0,
              )),
          errorStyle: TextStyle(
            height: 0.5,
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hint,
        ),
        keyboardType: TextInputType.text,
        validator: (validate
            ? (value) {
                if (value.isEmpty) {
                  return error;
                }
                return null;
              }
            : null),
        onSaved: (value) {},
      ),
    );
  }
}
