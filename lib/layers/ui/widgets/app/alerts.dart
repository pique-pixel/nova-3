import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';

class AppChooserDialog extends StatelessWidget {
  final List<AppDialogOption> options;

  const AppChooserDialog({Key key, this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final option in options) {
      children.add(option);
      children.add(Divider(height: 0, color: Colors.black26));
    }

    options.removeLast();

    return Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).maybePop();
        },
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
          constraints: BoxConstraints.tightFor(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGray,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _ModalButton(
                text: 'Отменить',
                background: AppColors.white,
                color: AppColors.darkGray,
                radius: BorderRadius.circular(16.0),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppDialogOption extends StatelessWidget {
  final String title;
  final void Function() onTap;

  const AppDialogOption({Key key, this.onTap, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ModalButton(
      text: title,
      background: AppColors.backgroundGray,
      color: AppColors.darkGray,
      onTap: onTap,
    );
  }
}

class _ModalButton extends StatelessWidget {
  final String text;
  final Color background;
  final Color color;
  final BorderRadius radius;
  final Function onTap;

  const _ModalButton({
    Key key,
    this.text,
    this.background,
    this.color,
    this.radius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: new BoxDecoration(
          color: background,
          borderRadius: radius,
        ),
        child: Center(
          child: Text(
            text,
            style: GolosTextStyles.h3size16(
              golosTextColors: GolosTextColors.grayDarkVery,
            ),
          ),
        ),
      ),
    );
  }
}

class YesNoDialog extends StatelessWidget {
  final String title;
  final String text;
  final String cancelOption;
  final String okOption;
  final void Function() onSuccess;

  const YesNoDialog({
    Key key,
    this.title,
    this.text,
    this.cancelOption,
    this.okOption,
    this.onSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.backgroundGray,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: NamedFontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: NamedFontWeight.regular,
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              color: Colors.black26,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: _ModalButton(
                    text: cancelOption,
                    background: AppColors.backgroundGray,
                    color: AppColors.darkGray,
                    radius: BorderRadius.only(bottomLeft: Radius.circular(16)),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  width: 0.3,
                  height: 60,
                  color: Colors.black26,
                ),
                Expanded(
                  child: _ModalButton(
                    text: okOption,
                    background: AppColors.backgroundGray,
                    color: AppColors.primaryRed,
                    radius: BorderRadius.only(bottomRight: Radius.circular(16)),
                    onTap: () {
                      onSuccess();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  final String text;

  const LoadingDialog({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.backgroundGray,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircularProgressIndicator(),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: NamedFontWeight.regular,
                    color: AppColors.mediumGray,
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
