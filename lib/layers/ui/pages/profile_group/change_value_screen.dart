import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';

class ChangeValueScreen extends StatefulWidget {
  final String title;
  final List<String> listValues;
  final int selected;
  final ValueChanged<String> onChanged;

  const ChangeValueScreen({
    Key key,
    @required this.title,
    @required this.listValues,
    @required this.selected,
    this.onChanged,
  }) : super(key: key);

  static route({
    @required String title,
    @required List<String> listValues,
    @required int selected,
    ValueChanged<String> onChanged
  }) {
    return MaterialPageRoute(
      builder: (context) => ChangeValueScreen(
        title: title,
        listValues: listValues,
        selected: selected,
        onChanged: onChanged,
      ),
    );
  }

  @override
  _ChangeValueScreenState createState() => _ChangeValueScreenState();
}

class _ChangeValueScreenState extends State<ChangeValueScreen> {
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selected;
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
          child: ListView(
            shrinkWrap: false,
            children: <Widget>[
              _Title(title: widget.title),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.listValues.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    dense: false,
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      widget.listValues[index],
                      style: GolosTextStyles.h3size16(
                        golosTextColors: GolosTextColors.grayDarkVery,
                      ),
                    ),
                    trailing: selectedIndex == index
                        ? Icon(
                            Icons.check,
                            color: GolosTextColors.red,
                          )
                        : null,
                    onTap: () {
                      if (selectedIndex == index) return null;
                      setState(() {
                        selectedIndex = index;
                        if(widget.onChanged != null){
                           widget.onChanged(widget.listValues[index]);
                        }
                      });
                    },
                  );
                },
              ),
            ],
          ),
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
