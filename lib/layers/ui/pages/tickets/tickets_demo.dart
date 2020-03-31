import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/custom_app_bar.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:rp_mobile/layers/services/session.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rp_mobile/layers/bloc/demo_bloc/bloc.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rp_mobile/layers/ui/pages/package_details.dart';

class Order {
  final List<Items> items;
  final String uid;

  Order({
    this.items,
    this.uid,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<Items> data = list.map((i) => Items.fromJson(i)).toList();

    return new Order(
      items: data,
      uid: json['uid'] as String,
    );
  }
}

class Items {
  Item item;

  Items({
    this.item,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      item: Item.fromJson(json["item"]),
    );
  }
}

class Item {
  String externalId;
  int id;
  String img;
  Descriptions name;

  Item({this.externalId, this.id, this.img, this.name});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      externalId: json["externalId"],
      id: json["id"] as int,
      img: json["imageUrl"] as String,
      name: Descriptions.fromJson(json["descriptions"]),
    );
  }
}

class Descriptions {
  String ru;

  Descriptions({this.ru});

  factory Descriptions.fromJson(Map<String, dynamic> json) {
    return Descriptions(ru: json["ru"] as String);
  }
}

class TicketsDemoProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DemoBloc>(
      create: (context) {
        return DemoBloc(GetIt.instance<SessionService>())..add(OnLoad());
      },
      child: TicketsDemoPage(),
    );
  }
}

class TicketsDemoPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => TicketsDemoProvider());

  @override
  _TicketsDemoPageState createState() => _TicketsDemoPageState();
}

class _TicketsDemoPageState extends State<TicketsDemoPage> {
  Future<List<Order>> getData(http.Client client, String token) async {
//    print(token);
    List<Order> list;
//    var body = jsonEncode({"token": "$token"});
//    "lang": "ru",
    var body = jsonEncode({
      "filter": {"status": "FINISHED"},
    "token":"$token"
    });
    //print("Body: " + body);
    final response = await client.post(
      'https://api.russpass.iteco.dev/billing/lookupOrders',
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["orders"] as List;
      list = rest.map<Order>((json) => Order.fromJson(json)).toList();
    }
    return list;
  }

  Widget listViewWidget(List<Order> orders) {
    return Container(
      child: ListView.builder(
        itemCount: orders.length,
        padding: const EdgeInsets.all(2.0),
        itemBuilder: (context, position) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _TicketCart(
                externalId:
                orders[position].items.first.item.externalId,
                uid: orders[position].uid,
                //TODO костыль для "Санкт-Петербург за 2 дня"
                img: orders[position].uid == '1C5A0340'
                    ? 'content/386270277.jpg'
                    : orders[position].items.first.item.img,
                name: orders[position].items.first.item.name.ru,
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String sessionToken;
    return AppScaffold(
      safeArea: false,
      theme: AppThemes.materialAppTheme(),
      body: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(height: 77, title: "Мои билеты"),
          bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.ticket),
          body: BlocBuilder<DemoBloc, DemoState>(
            builder: (context, state) {
              if (state is LoadedSessionState) {
                if (state.session.isPresent) {
                  final session = state.session.value;
                  sessionToken = session.accessToken;
                }
                return FutureBuilder(
                  future: getData(http.Client(), sessionToken),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print('error $snapshot.error');

                    return snapshot.hasData
                        ? listViewWidget(snapshot.data)
                        : Center(child: CircularProgressIndicator());
                  },
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

class _TicketCart extends StatelessWidget {
  final String externalId;
  final String uid;
  final String img;
  final String name;

  const _TicketCart({Key key, this.externalId, this.uid, this.img, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO костыль для старых урлов картинок
    bool _validURL = Uri.parse(img).isAbsolute;
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return _BottomSheetPackage(name: name, code: uid);
                },
              );
            },
            child: Container(
              height: 188,
              decoration: BoxDecoration(
                color: Color(0xFFD8D8D8),
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: _validURL ? CachedNetworkImageProvider(img) : CachedNetworkImageProvider('https://api.russpass.iteco.dev/attach/image?file=$img'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  Container(
                    height: 80.0,
                    width: 80.0,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryRed,
                        radius: 10,
                        child: new Image.asset('images/qr_icon.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PackagesDetailPage.route(externalId),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: AppColors.darkGray,
                      fontWeight: NamedFontWeight.semiBold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward, color: AppColors.darkGray)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSheetPackage extends StatelessWidget {
  final String name;
  final String code;

  const _BottomSheetPackage({Key key, this.name, this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Center(
          child: Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
                color: Color(0xFFC4C4C4),
                borderRadius: BorderRadius.circular(2)),
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 24),
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(8),
              topRight: const Radius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'RUSSPASS',
                style: TextStyle(
                  fontFamily: 'PT Russia Text',
                  fontSize: 12,
                  fontWeight: NamedFontWeight.semiBold,
                  height: 18 / 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Единый билет для пакета\n«$name»',
                style: TextStyle(
                    fontWeight: NamedFontWeight.semiBold,
                    color: Colors.white,
                    fontSize: 16),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 32),
              _QRCode(code: code),
              SizedBox(height: 6),
              Text(
                'Покажите QR-код сотруднику',
                style: TextStyle(
                  fontFamily: 'PT Russia Text',
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}

class _QRCode extends StatelessWidget {
  final String code;

  const _QRCode({
    Key key,
    @required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(23),
      child: QrImage(
        data: code,
        version: QrVersions.auto,
        size: 165.0,
      ),
    );
  }
}
