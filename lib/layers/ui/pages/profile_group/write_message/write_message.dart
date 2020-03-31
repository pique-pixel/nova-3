import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rp_mobile/layers/ui/pages/profile_group/write_message/camera_picker.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';

class WriteMessagePage extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (context) => WriteMessagePage());
  WriteMessagePage({Key key}) : super(key: key);

  @override
  _WriteMessagePageState createState() => _WriteMessagePageState();
}

class _WriteMessagePageState extends State<WriteMessagePage> {
  //----- Для верстки
  double heightBetweenElement = 52;

  //----- Данные профиля
  String title = 'Обращение в службу поддержки';
  String idInfo = 'ID туриста отсутствует';
  String idHelpTextInBlack = 'Для получения покажите QR-код \nлюбого заказа в ';
  String idHelpTextInRed = 'пунктах выдачи';
  Function idHelpTextInRedOnTap = () {
    print('Hitted red text');
  };
  Function instruction = () {
    print('Instruction tapped');
  };
  String mainData = 'Основные данные';
  TextEditingController messageController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController birthCityController = TextEditingController();
  TextEditingController docNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  bool isCheckedAgreement = false;
  bool isCheckedUnderstand = false;
  String checkBoxCheckedImage = 'images/checkbox.png';
  String checkBoxUnCheckedImage = 'images/empty_checkbox.png';

  List<File> listImage = [];

  _toggleAgreement() {
    this.setState(() {
      isCheckedAgreement = !isCheckedAgreement;
      // widget.oncheckBoxTapp(isChecked);
    });
  }

  _toggleIUnderstand() {
    this.setState(() {
      isCheckedUnderstand = !isCheckedUnderstand;
      // widget.oncheckBoxTapp(isChecked);
    });
  }

  Widget _checkTile(Function onTap, bool isChecked, String text1, String text2,
      String text3) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
              onTap: onTap,
              child: Container(
                height: 20.0,
                width: 20.0,
                child: Image.asset(
                    isChecked ? checkBoxCheckedImage : checkBoxUnCheckedImage),
              )),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: RichText(
                text: TextSpan(
                    text: text1,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    children: <TextSpan>[
                      TextSpan(
                        text: text2,
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                      TextSpan(
                        text: ' $text3',
                        style: TextStyle(fontSize: 18),
                      )
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.materialAppTheme(),
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  shrinkWrap: false,
                  children: <Widget>[
                    _Title(title: title),
                    SizedBox(height: 32),
                    _DocumentType(
                      listDocumentName: [
                        'Общие вопросы',
                        'Общие вопросы',
                        'Общие вопросы',
                      ],
                      onSelected: (int index) {
                        print('Selected document $index');
                      },
                    ),
                    SizedBox(height: heightBetweenElement),
                    _TextFieldGeneral(
                      label: 'Описание',
                      hintText: 'Сообщение',
                      textEditingController: messageController,
                    ),
                    SizedBox(height: 56),
                    Container(
                      margin: EdgeInsets.only(left: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 16.0, bottom: 10.0),
                            child: InkWell(
                              onTap: () {
                                return showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) =>
                                      ShowCuperTinoActionSheet(
                                    onImagePickerTap: (imageFile) {
                                      this.setState(() {
                                        listImage.add(imageFile);
                                      });
                                    },
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/plus.png',
                                height: 24.0,
                                width: 24.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Добавить файл',
                                    style: TextStyle(
                                      color: Color(0xff262626),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text(
                                    'не больше 5 файлов до 30МБ',
                                    style: TextStyle(
                                        color: Color(0xff898989),
                                        fontSize: 12.0),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    listImage.length < 1
                        ? SizedBox(
                            height: 0,
                          )
                        : Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: listImage
                                    .asMap()
                                    .map(
                                      (index, image) => MapEntry(
                                          index,
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 16, right: 4),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  height: 60,
                                                  width: 60,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Image.file(
                                                        image,
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: InkWell(
                                                            onTap: () {
                                                              this.setState(() {
                                                                listImage
                                                                    .removeAt(
                                                                        index);
                                                              });
                                                            },
                                                            child: Container(
                                                              child:
                                                                  Image.asset(
                                                                'images/cancel.png',
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                    )
                                    .values
                                    .toList(),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 24,
                    ),
                    _TextFieldGeneral(
                      label: 'Имя',
                      hintText: 'Как к вам обращаться?',
                      textEditingController: nameController,
                    ),
                    SizedBox(height: 56),
                    _TextFieldGeneral(
                      label: 'E-mail',
                      hintText: 'example@mail.ru',
                      textEditingController: lastNameController,
                    ),
                    SizedBox(height: 58),
                    _checkTile(
                        _toggleAgreement,
                        isCheckedAgreement,
                        "Указанные мной контактные данные верны. Я понимаю, что в случае ошибки со мной не смогут связаться",
                        "",
                        ""),
                    SizedBox(height: 24),
                    _checkTile(
                        _toggleIUnderstand,
                        isCheckedUnderstand,
                        "Я принимаю ",
                        "соглашение",
                        "на обработку персональных данных"),
                    SizedBox(
                      height: 48,
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _WideButton(
                  text: 'Отправить',
                  onPressed: () {
                    print('Tapped Сохранить');

                    showDialog(
                      context: context,
                      builder: (context) {
                        return _SaveDialog();
                      },
                    );
                  },
                  textGolosColors: GolosTextColors.white,
                  buttonGolosColor: GolosTextColors.red,
                  buttonHighlightGolosColor: GolosTextColors.redMiddle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        'Корректировка данных',
        style: GolosTextStyles.h3size16(
          golosTextColors: GolosTextColors.grayDarkVery,
        ),
      ),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          'При изменении личных данных ваш пароль будет сброшен',
          style: GolosTextStyles.additionalSize14(
            golosTextColors: GolosTextColors.grayDarkVery,
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            print('Tapped Отмена');
            Navigator.of(context).pop();
          },
          child: Text(
            'Отмена',
            style: GolosTextStyles.h3size16(
              golosTextColors: GolosTextColors.grayDarkVery,
            ),
          ),
        ),
        FlatButton(
          child: Container(
            child: Text(
              'Подтвердить',
              style: GolosTextStyles.h3size16(
                golosTextColors: GolosTextColors.grayDarkVery,
              ),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.symmetric(horizontal: 2),
            alignment: Alignment.center,
          ),
          onPressed: () {
            print('Tapped Подтвердить');
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.all(4),
        ),
      ],
    );
  }
}

class _WideButton extends StatelessWidget {
  final String text;
  final Color textGolosColors;
  final Function onPressed;
  final Color buttonGolosColor;
  final Color buttonHighlightGolosColor;

  const _WideButton({
    Key key,
    @required this.buttonGolosColor,
    @required this.text,
    @required this.onPressed,
    @required this.textGolosColors,
    @required this.buttonHighlightGolosColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      color: buttonGolosColor,
      splashColor: Colors.white10,
      highlightColor: buttonHighlightGolosColor,
      child: Container(
        height: 54,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textGolosColors,
            fontSize: 16,
            fontFamily: GolosTextStyles.fontFamily,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.1,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class _DocumentType extends StatefulWidget {
  final List<String> listDocumentName;
  final Function onSelected;

  const _DocumentType({
    Key key,
    @required this.listDocumentName,
    this.onSelected(int index),
  })  : assert(listDocumentName.length > 0, 'Must be more than 1'),
        super(key: key);

  @override
  __DocumentTypeState createState() => __DocumentTypeState();
}

class __DocumentTypeState extends State<_DocumentType> {
  int selectedDocIndex;

  @override
  void initState() {
    super.initState();
    selectedDocIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Тема сообщения',
            style: GolosTextStyles.additionalSize14(
              golosTextColors: GolosTextColors.grayDarkVery,
            ),
          ),
          ListTile(
            onTap: () async {
              print("Here should show the bottom sheet");
              await showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return _DocumentSelectionBottomSheet(
                      list: widget.listDocumentName,
                      selectedIndex: 0,
                      onSelected: (val) {
                        setState(() {
                          selectedDocIndex = val;
                        });
                        widget.onSelected(val);
                      });
                },
              );
            },
            contentPadding: EdgeInsets.all(0),
            title: Text(
              widget.listDocumentName[selectedDocIndex],
              style: GolosTextStyles.mainTextSize16(
                golosTextColors: GolosTextColors.grayDarkVery,
              ),
              overflow: TextOverflow.fade,
            ),
            trailing: Image.asset(
              'images/less.png',
              color: GolosTextColors.grayBright,
              scale: 0.8,
            ),
          ),
          Container(
            height: 1,
            color: GolosTextColors.grayBright,
          ),
        ],
      ),
    );
  }
}

class _DocumentSelectionBottomSheet extends StatefulWidget {
  final List<String> list;
  final int selectedIndex;
  final Function onSelected;

  const _DocumentSelectionBottomSheet({
    Key key,
    @required this.list,
    this.selectedIndex = 0,
    this.onSelected(int index),
  }) : super(key: key);

  @override
  __DocumentSelectionBottomSheetState createState() =>
      __DocumentSelectionBottomSheetState();
}

class __DocumentSelectionBottomSheetState
    extends State<_DocumentSelectionBottomSheet> {
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Тема сообщения',
              style: GolosTextStyles.h2size20(
                golosTextColors: GolosTextColors.grayDarkVery,
              ),
            ),
          ),
          SizedBox(height: 12),
          Divider(
            color: Colors.grey,
          ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: widget.list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: EdgeInsets.all(0),
                onTap: () {
                  setState(() {
                    widget.onSelected(index);
                    selectedIndex = index;
                  });
                },
                title: Text(
                  widget.list[index],
                  style: GolosTextStyles.h3size16(
                    golosTextColors: GolosTextColors.grayDarkVery,
                  ),
                ),
                trailing: selectedIndex == index
                    ? Icon(Icons.check, color: GolosTextColors.red)
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GenderSelection extends StatefulWidget {
  final Function isMaleSelected;

  const _GenderSelection({
    Key key,
    @required this.isMaleSelected(bool isMale),
  }) : super(key: key);

  @override
  __GenderSelectionState createState() => __GenderSelectionState();
}

class __GenderSelectionState extends State<_GenderSelection> {
  bool isMale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Пол',
            style: GolosTextStyles.additionalSize14(
              golosTextColors: GolosTextColors.grayDarkVery,
            ),
          ),
          _GenderSelectionItem(
            title: 'мужской',
            isActive: isMale == null ? false : isMale,
            onTap: () {
              setState(() {
                isMale = true;
                widget.isMaleSelected(true);
              });
            },
          ),
          _GenderSelectionItem(
            title: 'женский',
            isActive: isMale == null ? false : !isMale,
            onTap: () {
              setState(() {
                isMale = false;
                widget.isMaleSelected(false);
              });
            },
          ),
        ],
      ),
    );
  }
}

class _GenderSelectionItem extends StatelessWidget {
  final bool isActive;
  final String title;
  final Function onTap;

  const _GenderSelectionItem({
    Key key,
    this.isActive = false,
    @required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.all(0),
      leading: isActive
          ? Image.asset(
              'images/radio_button_on.png',
              height: 24,
              width: 24,
            )
          : Image.asset(
              'images/radio_button_off.png',
              height: 24,
              width: 24,
            ),
      title: Text(
        title,
        style: GolosTextStyles.mainTextSize16(
          golosTextColors: GolosTextColors.grayDarkVery,
        ),
      ),
    );
  }
}

class _TextFieldGeneral extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController textEditingController;
  final TextInputType textInputType;

  const _TextFieldGeneral({
    Key key,
    this.label,
    this.hintText,
    this.textEditingController,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Text(
              label,
              style: GolosTextStyles.additionalSize14(
                golosTextColors: GolosTextColors.grayDarkVery,
              ),
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextField(
                scrollPadding: EdgeInsets.all(0),
                controller: textEditingController,
                enabled: true,
                keyboardType: textInputType,
                style: GolosTextStyles.mainTextSize16(
                  golosTextColors: GolosTextColors.grayDarkVery,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
                  hintStyle: GolosTextStyles.mainTextSize16(
                    golosTextColors: GolosTextColors.grayBright,
                  ),
                  enabled: true,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: GolosTextColors.grayBright.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordGeneral extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController textEditingController;
  final TextInputType textInputType;

  const _PasswordGeneral({
    Key key,
    this.label,
    this.hintText,
    this.textEditingController,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  __PasswordGeneralState createState() => __PasswordGeneralState();
}

class __PasswordGeneralState extends State<_PasswordGeneral> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Text(
              widget.label,
              style: GolosTextStyles.additionalSize14(
                golosTextColors: GolosTextColors.grayDarkVery,
              ),
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextField(
                scrollPadding: EdgeInsets.all(0),
                controller: widget.textEditingController,
                enabled: true,
                keyboardType: widget.textInputType,
                obscureText: obscurePassword,
                style: GolosTextStyles.mainTextSize16(
                  golosTextColors: GolosTextColors.grayDarkVery,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: GolosTextStyles.mainTextSize16(
                    golosTextColors: GolosTextColors.grayBright,
                  ),
                  enabled: true,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: GolosTextColors.grayBright.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  final String text;

  const _SubTitle({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: GolosTextStyles.h2size20(
          golosTextColors: GolosTextColors.grayDarkVery,
        ),
      ),
    );
  }
}

class _TouristIdHelp extends StatelessWidget {
  final String textInBlack;
  final String textInRed;
  final Function onTapRedText;

  const _TouristIdHelp({
    Key key,
    @required this.textInBlack,
    @required this.textInRed,
    this.onTapRedText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: textInBlack,
              style: GolosTextStyles.mainTextSize16(
                golosTextColors: GolosTextColors.grayDarkVery,
              ),
            ),
            TextSpan(
              text: textInRed,
              style: GolosTextStyles.mainTextSize16(
                golosTextColors: GolosTextColors.red,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTapRedText,
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: GolosTextStyles.h1size30(
          golosTextColors: GolosTextColors.grayDarkVery,
        ),
      ),
    );
  }
}

class ShowCuperTinoActionSheet extends StatefulWidget {
  final ValueChanged<File> onImagePickerTap;

  ShowCuperTinoActionSheet({this.onImagePickerTap});

  @override
  _ShowCuperTinoActionSheetState createState() =>
      _ShowCuperTinoActionSheetState();
}

class _ShowCuperTinoActionSheetState extends State<ShowCuperTinoActionSheet> {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          "Отменить",
          style: TextStyle(color: Color(0xff262626)),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(
            "Сделать снимок",
            style: TextStyle(
              color: Color(0xff000000),
            ),
          ),
          // isDefaultAction: true,
          onPressed: () async {
            print("Open Camera");
            var fileImage = await getImage(ImageSource.camera);
            this.setState(() {
              widget.onImagePickerTap(fileImage);
            });
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(
            "Выбрать из галереи",
            style: TextStyle(color: Color(0xff000000)),
          ),
          isDestructiveAction: true,
          onPressed: () async {
            print("Open Gallery");
            var fileImage = await getImage(ImageSource.gallery);

            this.setState(() {
              widget.onImagePickerTap(fileImage);
            });
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
