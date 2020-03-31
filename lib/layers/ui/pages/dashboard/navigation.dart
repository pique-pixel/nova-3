import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  YandexMapController _controller;
  Point _target;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Expanded(
          child: YandexMap(
            onMapCreated: (controller) async {
              controller.onGeoObjectTap = (geoObject) {
                debugPrint('LATITUDE: ${geoObject.point.latitude}');
                debugPrint('LONGITUDE: ${geoObject.point.longitude}');
                _target = geoObject.point;
              };

              await PermissionHandler().requestPermissions(
                  <PermissionGroup>[PermissionGroup.location]);
//              await controller.setBounds(
//                southWestPoint: const Point(
//                  latitude: 55.018803 - 0.01,
//                  longitude: 82.933952 - 0.01,
//
//                ),
//                northEastPoint: const Point(
//                  latitude: 55.018803 + 0.01,
//                  longitude: 82.933952 + 0.01,
//                ),
//              );
              await controller.move(
                point: Point(
                  latitude: 55.752078,
                  longitude: 37.592664,
                ),
              );
              _controller = controller;
            },
          ),
        ),
        RaisedButton(
          child: Text('build the route'),
          onPressed: () async {
            if (_controller != null && _target != null) {
              await _controller.requestMasstransitRoute(
                src: Point(
                  latitude: 55.699671,
                  longitude: 37.567286,
                ),
                dest: _target,
//                dest: Point(
//                  latitude: 55.790621,
//                  longitude: 37.558571,
//                ),
              );
            } else {
              debugPrint(':((((');
            }
          },
        ),
      ],
    );
  }
}
