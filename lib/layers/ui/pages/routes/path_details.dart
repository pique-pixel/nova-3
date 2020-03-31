import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/widgets/base/divider.dart';
import 'package:rp_mobile/utils/strings.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'dart:core';

class RoutePathDetailsHeader extends StatelessWidget {
  final RouteInfo _info;

  const RoutePathDetailsHeader(this._info, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: _RoutePathDetailsHeaderContent(_info),
        ),
//        SimpleDivider(color: Color(0xFFF2F2F2)),
      ],
    );
  }
}

class _RoutePathDetailsHeaderContent extends StatelessWidget {
  final RouteInfo _info;

  const _RoutePathDetailsHeaderContent(this._info, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (int i = 0; i < _info.sections.length; ++i) {
      final section = _info.sections[i];
      children.add(_RoutePathHeaderTag(tag: section.tag));

      if (i != _info.sections.length - 1) {
        children.add(_RoutePathHeaderChevron());
      }
    }

    return Wrap(children: children);
  }
}


class _RoutePathHeaderChevron extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 24,
      child: Center(
        child: Icon(
          Icons.chevron_right,
          size: 16,
          color: Color(0xFF262626).withOpacity(0.5),
        ),
      ),
    );
  }
}

class _RoutePathHeaderTag extends StatelessWidget {
  final String tag;

  const _RoutePathHeaderTag({Key key, @required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget icon;

    if (tag == 'pedestrian') {
      icon = Image.asset('images/pedestrian.png');
    } else if (tag == 'underground') {
      icon = Image.asset('images/metro.png');
    } else {
      icon = Icon(
        Icons.directions_bus,
        size: 18,
        color: Color(0xFF262626).withOpacity(0.5),
      );
    }

    return SizedBox(width: 24, height: 24, child: Center(child: icon));
  }
}

class RoutePathDetails extends StatelessWidget {
  final RouteInfo _info;

  const RoutePathDetails(this._info, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final path = <Widget>[];
    final details = <Widget>[];

    final centerDotOffset =
        _RoutePathStop.height / 2 - _RoutePathStopDot.size / 2;

    path.add(SizedBox(height: centerDotOffset + 1));

    for (int i = 0; i < _info.points.length; ++i) {
      final stop = _info.points[i];

      path.add(
        _RoutePathStopDot(
          color: Color(stop.color),
          hollow: i == 0 || i == _info.points.length - 1,
        ),
      );

      details.add(
        _RoutePathStop(name: stop.name),
      );

      if (i < _info.points.length - 1) {
        final section = _info.sections[i];
        final height = section.tag == 'pedestrian' ? 62.0 : 108.0;

        if (section is SectionTransport) {
          details.add(
            _RoutePathSectionTransport(
              tag: section.tag,
              height: height,
              stationsCount: section.intermediateStationsSize,
              duration: formatDuration(section.duration),
            ),
          );
        } else {
          details.add(
            _RoutePathSectionPedestrian(
              height: height,
              duration: formatDuration(section.duration),
              walkingDistance: formatDistance(section.walkingDistance),
            ),
          );
        }

        path.add(
          _RoutePathLine(
            height: height + centerDotOffset * 2,
            dashed: section.tag == 'pedestrian',
            color: section.tag == 'pedestrian'
                ? Color(0xFFC4C4C4)
                : Color(section.color),
          ),
        );
      }
    }

    return
//      Padding(
//      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details,
            ),
            Column(
              children: path,
            ),
          ],
        ),
      );
  }
}

class _RoutePathStop extends StatelessWidget {
  static double height = 18;
  final String name;

  const _RoutePathStop({
    Key key,
    @required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(left: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          name,
          style: TextStyle(
            color: Color(0xFF262626),
            fontWeight: NamedFontWeight.semiBold,
          ),
        ),
      ),
    );
  }
}

class _RoutePathStopDot extends StatelessWidget {
  static double size = 8;
  final bool hollow;
  final Color color;

  const _RoutePathStopDot({
    Key key,
    @required this.hollow,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(width: hollow ? 2 : 4, color: color),
      ),
    );
  }
}

class _RoutePathSectionPedestrian extends StatelessWidget {
  final String walkingDistance;
  final String duration;
  final double height;

  const _RoutePathSectionPedestrian({
    Key key,
    @required this.height,
    @required this.walkingDistance,
    @required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Color(0xFF262626).withOpacity(0.5),
      fontWeight: NamedFontWeight.semiBold,
      fontSize: 14,
    );

    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            Image.asset('images/pedestrian.png'),
            SizedBox(width: 3),
            Text(walkingDistance, style: textStyle),
            _TextDot(),
            Text(duration, style: textStyle),
          ],
        ),
      ),
    );
  }
}

class _TextDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      margin: const EdgeInsets.fromLTRB(4, 6, 4, 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF262626).withOpacity(0.5),
      ),
    );
  }
}

class _RoutePathSectionTransport extends StatelessWidget {
  final String tag;
  final int stationsCount;
  final String duration;
  final double height;

  const _RoutePathSectionTransport({
    Key key,
    @required this.tag,
    @required this.height,
    @required this.stationsCount,
    @required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Color(0xFF262626).withOpacity(0.5),
      fontWeight: NamedFontWeight.semiBold,
      fontSize: 14,
    );

    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            SizedBox(width: 3),
            stationsCount > 0
                ? Text(
                    formatStationsCount(stationsCount, tag),
                    style: textStyle,
                  )
                : SizedBox.shrink(),
            stationsCount > 0 ? _TextDot() : SizedBox.shrink(),
            Text(duration, style: textStyle),
          ],
        ),
      ),
    );
  }
}

String formatStationsCount(int count, String tag) {
  List<String> names;

  if (tag == 'undeground') {
    names = ['станций', 'станция', 'станции'];
  } else {
    names = ['остановок', 'остановка', 'остановки'];
  }

  return formatCount(count, names);
}

class _RoutePathLine extends StatelessWidget {
  final bool dashed;
  final Color color;
  final double height;

  const _RoutePathLine({
    Key key,
    @required this.dashed,
    @required this.color,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2,
      height: height,
      child: CustomPaint(
        painter: _RoutePathLinePainter(
          dashed: dashed,
          color: color,
        ),
      ),
    );
  }
}

class _RoutePathLinePainter extends CustomPainter {
  final bool dashed;
  final Color color;

  _RoutePathLinePainter({@required this.dashed, @required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (dashed) {
      _paintDash(canvas, size);
    } else {
      _paintFill(canvas, size);
    }
  }

  _paintFill(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paint);
  }

  _paintDash(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    final strokeWidth = size.width;
    var max = size.height;
    final dashWidth = 5.0;
    final dashSpace = 3.0;
    double startY = 0;

    while (max >= 0) {
      canvas.drawRect(
        Rect.fromLTRB(0, startY, strokeWidth, startY + dashWidth),
        paint,
      );
      final space = (dashSpace + dashWidth);
      startY += space;
      max -= space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
