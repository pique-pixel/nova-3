import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/pages/activity.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/divider.dart';
import 'package:rp_mobile/layers/ui/widgets/base/fade_background.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'dart:math' as math;

class PackageDetailsPage extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => PackageDetailsPage());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return AppScaffold(
      safeArea: false,
      theme: AppThemes.pageBrightnessDarkTheme(),
      body: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.favourites),
          body: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 80.0 + mediaQuery.padding.top,
                  maxHeight: 200.0 + mediaQuery.padding.top,
                  child: Container(
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: FadeBackgroundImage(
                            AssetImage("images/mock_images/moscow_3_days.png"),
//                            CachedNetworkImageProvider(
//                                'https://picsum.photos/800'),
                            backgroundColor: Color(0xFFD8D8D8),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        ),
                        SafeArea(bottom: false, child: _AppBar()),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _Header(),
                    SimpleDivider(color: Color(0xFFF5F5F5), height: 8),
                    _PackageConsistsFrom(),
                    SimpleDivider(color: Color(0xFFF5F5F5), height: 8),
                    _LocationsAndActivities(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 56, 32, 64),
                      child: Text(
                        'Москва многолика. Царица, воплощающая русскую душу с ее '
                        'широтой и щедростью. Как радушная хозяйка, она удивляет '
                        'уютом старых улочек, тишиной парков, древней, с любовью '
                        'оберегаемой архитектурой. В облике светской дамы проведет на '
                        'выставку, в музей, на театральную премьеру. ',
                        style: TextStyle(
                          fontSize: 17,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ),
                    SizedBox(height: mediaQuery.padding.bottom),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            BackButton(color: Colors.white),
            Expanded(child: SizedBox.shrink()),
            //_Avatar(),
            SizedBox(width: 18),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFD8D8D8),
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 4),
            child: Text(
              'Москва за 3 дня',
              style: TextStyle(
                color: AppColors.darkGray,
                fontSize: 24,
                fontWeight: NamedFontWeight.bold,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                'Взрослый',
                style: TextStyle(color: AppColors.darkGray),
              ),
              Text(
                ' • ',
                style: TextStyle(color: Color(0xFFA8A8A8)),
              ),
              Text(
                'Действует 2 дня 16 часов',
                style: TextStyle(color: Color(0xFF0D9EA1)),
              )
            ],
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PackageConsistsFrom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'В составе туристического пакета',
            style: TextStyle(
              color: AppColors.darkGray,
              fontSize: 17,
            ),
          ),
        ),
        SizedBox(height: 16),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              _Item('Из аэропорта и обратно','images/mock_images/pack_1.png',0xFFFFFFFF),
              _Item('\nПроезд на любом общественном транспорте','images/mock_images/pack_2.png',0xFFFFFFFF),
              _Item('\n\nКомфортные двухэтажные экскурсионные автобусы','images/mock_images/pack_3.png',0xFFFFFFFF),
              _Item('\nВоробьёвы горы - Лужники и обратно','images/mock_images/pack_4.png',0xFF005675),
//              _Item(),
//              _Item(),
            ],
          ),
        ),
        SizedBox(height: 32),
      ],
    );
  }
}
class _Tag extends StatelessWidget {
  final String text;

  const _Tag(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Text(text),
    );
  }
}
class _Item extends StatelessWidget {
  final String text;
  final String img;
  final int color;

  const _Item(this.text, this.img, this.color, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 120,
      height: 160,
      decoration: BoxDecoration(
//        color: Color(0xFFFB555C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
//            bottom: 8,
//            right: 6,
            child: Image.asset(img),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 40, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: NamedFontWeight.semiBold,
                    color: Color(color),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationsAndActivities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 24, 6, 8),
            child: Text(
              'Музеи',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
//          SizedBox(height: 32),
          SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          scrollDirection: Axis.horizontal,
          child: Row(
              children: <Widget>[
                _Tag('рекомендуем'),
                _Tag('развлечения'),
                _Tag('прогулки'),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_8.jpg"),
                  title: 'Музей-заповедник «Царицыно»',
                  address: 'Москва, ул. Дольская, 1',
                  description: 'Отдохните от городского шума, не выезжая из Москвы! Ваши фотоальбомы пополнятся видами с резных плотин и шиком архитектуры московского барокко. Свое название загородная резиденция Екатерины II получила по велению самой императрицы: местный пейзаж полюбился ей с первого взгляда. Вам доступно посещение Большого дворца и Хлебного дома, Малого дворца, Оранжерейного комплекса (три оранжереи), Третьего Кавалерского корпуса.',
                  lat: 55.616418,
                  lon: 37.683191,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_4.jpg"),
                  title: 'Музей археологии Москвы',
                  address: 'Москва, Манежная пл., 1А',
                  description: 'Обратите время вспять, пройдя вглубь под землю на 7 метров — именно там располагаются залы музея и «сердце» экспозиции — сохранившиеся с 17-го века белокаменные устои Воскресенского моста. Вы прочувствуете дух древних времен и не устанете удивляться искусности средневековых мастеров. Коллекция музея — это почти 14 тыс. артефактов: элементы вооружения, посуда, изразцы, монеты, украшения и предметы облачения — за каждой мелочью скрываются жизни и судьбы.',
                  lat: 55.756280,
                  lon: 37.617097,
                ),
              ),
            ]),
          Row(
              children: <Widget>[
                Expanded(
                  child: _LocationsAndActivitiesCard(
                    image: AssetImage("images/mock_images/geo_5.jpg"),
                    title: 'Музей космонавтики',
                    address: 'Москва, Пр. Мира, 111',
                    description: 'Восемь больших залов и 98 тыс. экспонатов — Музей космонавтики не оставит равнодушным никого из тех, кто хоть раз мечтательно смотрел на звезды. Вы узнаете, какой путь прошло человечество от запуска экспериментальных аппаратов до международного проекта на орбите. Увидите, как жили космонавты на станции «Мир» и побываете внутри орбитального дома. Сможете поуправлять межзвездным челноком. А завершить приключения лучше всего, попробовав на вкус «кольцо Сатурна» и настоящую еду героев космоса.',
                    lat: 55.823328,
                    lon: 37.639855,
                  ),
                ),
                Expanded(
                  child: _LocationsAndActivitiesCard(
                    image: AssetImage("images/mock_images/geo_3.jpg"),
                    title: 'Московский зоопарк',
                    address: 'Москва, Б. Грузинская ул., 1',
                    description: 'Московский зоопарк давно перестал быть просто лабиринтом вольеров: здесь проводятся интерактивные программы, множество активностей для детей и всей семьи, а для любителей интеллектуального досуга работает открытый лекторий. Коллекция насчитывает более 1 тыс. видов животных, птиц и рыб, собранных со всего света. Чтобы понаблюдать за повадками зверей в их естественной среде, лучше заранее подстроиться под график кормлений — тогда вы точно не застанете братьев наших меньших спящими.',
                    lat: 55.761212,
                    lon: 37.578529,
                  ),
                ),
              ]),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_1.jpg"),
                  title: 'Музей-заповедник «Коломенское»',
                  address: 'Москва, Андропова пр-т, 39',
                  description: 'Фонды Коломенского — это 75 тыс. артефактов, самые древние из которых относятся к эпохе неолита. Вы увидите, как развивались художественные промыслы, познакомитесь с русским народным творчеством, а с собой на память увезете фото в боярском облачении, собранную своими руками подвижную деревянную игрушку или собственноручно расписанную керамику. Вам доступно посещение Дворца царя Алексея Михайловича: Мужской половины - хором царя и царевичей, Хором младших и средних царевен.',
                  lat: 55.668132,
                  lon: 37.662215,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_9.jpg"),
                  title: 'Московский музей современного искусства на Петровке',
                  address: 'Москва, Петровка, 25',
                  description: 'Уже 20 лет бывший особняк купца Губина — центр культурной жизни столицы. Именно здесь проходят выставки художников, за чьими работами охотятся коллекционеры и ценители со всего света. Это первый в России музей, посвященный искусству прошлого столетия и новейшей художественной культуре. Вы увидите недавнее прошлое и наши дни глазами великих творцов и малоизвестных талантов. Откройте новые имена и очаруйтесь полетом творческой мысли признанных гениев!',
                  lat: 55.767135,
                  lon: 37.614119,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_0.jpg"),
                  title: 'Государственный Дарвиновский музей',
                  address: 'Москва, ул. Вавилова, 57',
                  description: 'Узнайте, как жизнь планеты прошла путь от цианобактерий до человека! Взгляните на окружающий мир глазами крохотной мыши. Посмотрите, как выглядели и двигались гигантские динозавры. Почувствуйте себя ученым, выделив молекулы ДНК банана. Познакомьтесь с мадагаскарскими лемурами и галапагосской черепахой, оживающими на ваших глазах. Спаситесь от метеоритного дождя, управляя кораблем для путешествий во времени и пространстве. И не забудьте сделать фото на память с хамелеоном Чарликом.',
                  lat: 55.690797,
                  lon: 37.561547,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_10.jpg"),
                  title: 'Галерея Ильи Глазунова',
                  address: 'Москва, ул. Волхонка, 13',
                  description: 'Галерея Ильи Глазунова — бесценный подарок художника столице. Более 700 работ феноменального живописца раскроют перед вами загадочную русскую душу, помогут погрузиться в историю российской и мировой живописи. Каждое полотно мастера — его диалог с прошлым, настоящим и будущим, с последователями, оппонентами и вдохновителями. Не упустите возможность взглянуть на мир глазами творца — отправьтесь на Волхонку и посетите особняк XIX века, с любовью отреставрированный самим художником.',
                  lat: 55.746438,
                  lon: 37.606609,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_11.jpg"),
                  title: 'Мультимедиа Арт Музей',
                  address: 'Москва, Остоженка, 16',
                  description: 'Мультимедиа Арт Музей под своей крышей объединяет многообразие творческих исканий современных художников. Документальная фотография и экспериментальное искусство, примитивистские рисунки и невероятные инсталляции, редкие кадры исторической хроники и дерзкие постмодернистские арт-объекты. Музей трепетно относится к классике, но не боится бросать вызов общественным вкусам и устоям. Здесь вы будете восхищаться, ужасаться, размышлять и спорить — но точно не останетесь равнодушными.',
                  lat: 55.741652,
                  lon: 37.598533,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_2.jpg"),
                  title: 'Парк Горького',
                  address: 'Москва, ул. Крымский Вал, 9',
                  description: 'Парк Горького — символ постиндустриальной Москвы. Это настоящий оазис с множеством форм досуга. Занимайтесь любимым спортом. Смотрите фильмы в летнем кинотеатре. Любуйтесь звездами в обсерватории. Кормите лебедей и уточек на прудах. Узнавайте новое на лекциях и мастер-классах. Открывайте для себя кухни народов мира в кафе и ресторанчиках. Наслаждайтесь благоуханием Нескучного сада. С RUSSPASS доступно посещение музея Парка Горького и смотровой площадки.',
                  lat: 55.731280,
                  lon: 37.603743,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_12.jpg"),
                  title: 'Центральный выставочный зал «Манеж»',
                  address: 'Москва, Манежная пл., 1 ',
                  description: 'Здание в стиле ампир недавно отметило 200-летний юбилей. Трудно поверить, но когда-то в главном выставочном зале столицы располагались совсем не туристические объекты. Конюшни, площадка для военных учений, казармы, правительственный гараж… Манеж изначально строился не для выставок и ярких событий. Но, видимо, подействовала «магия места», и уже с 30-х годов XIX века в здании нынешнего ЦВЗ проводятся экспозиции, концерты, спектакли, народные гулянья. Почувствуйте и вы эту «магию»!',
                  lat: 55.753762,
                  lon: 37.612513,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_13.jpg"),
                  title: 'Музей С.А. Есенина',
                  address: 'Москва, Б. Строченовский пер., 24с2',
                  description: 'Музей Сергея Есенина 25 лет назад был создан группой энтузиастов — поклонников и исследователей творчества поэта. Здесь экспонируются личные вещи творца, его рукописи, редкие фотографии и документы. Узнайте больше о сложном и ярком жизненном пути Есенина, погрузитесь в глубокий мир его лирики, полный страстей, искренности, противоречий, широкой души и большой любви. Присоединитесь к пешей экскурсии по Замоскворечью и взгляните на столичные переулочки глазами «московского озорного гуляки».',
                  lat: 55.726619,
                  lon: 37.630732,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_14.jpg"),
                  title: 'Музей Василия Тропинина',
                  address: 'Москва, ',
                  description: 'Познакомьтесь с людьми из прошлого, их окружением и занятиями, мыслями и переживаниями, запечатленными на холсте. Василий Тропинин интересен не только своим творчеством. Сам его жизненный путь — достойная экранизации история человека, идущего к своей мечте. Через биографию художника можно узнать о суровых нравах российского дворянства и нелегких судьбах крепостных крестьян, о том, как менялось общественное сознание на сломе веков и как истинный гений обретает признание.',
                  lat: 55.733830,
                  lon: 37.622786,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_15.jpg"),
                  title: 'Галерея Александра Шилова',
                  address: 'Москва, Знаменка, 3',
                  description: '22 зала Галереи Александра Шилова расположились в историческом особняке в центре Москвы. Двухэтажный каменный дом в Хамовниках — образец московской эклектики — обрел свой неповторимый облик два столетия назад. Но кажется, будто уже тогда архитектор знал: здесь быть храму искусств. Галерея А. Шилова — не просто богатейшая коллекция его работ. Это настоящий культурный центр, где звучит музыка, проводятся поэтические вечера и рождается Гармония.',
                  lat: 55.749190,
                  lon: 37.607923,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_16.jpg"),
                  title: 'Музей М.А. Булгакова',
                  address: 'Москва, Б. Садовая, 10',
                  description: 'Музей Булгакова в Москве — не обычное собрание личных вещей писателя. Это мистическое место, где стираются грани между настоящим и прошлым, между реальностью и творческим вымыслом. В бывшей коммунальной квартире оживают персонажи и сюжеты автора. Вы не заметите, как из советского быта, с его массивной мебелью, тихо поскрипывающим паркетом и громкими газетными заголовками, перенесетесь в мир загадок и тайн, где правят неведомые и могущественные силы. Темные они или светлые — решать вам!',
                  lat: 55.767075,
                  lon: 37.593858,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_17.jpg"),
                  title: 'Мемориальная квартира А.С. Пушкина',
                  address: 'Москва, Арбат, 53 ',
                  description: 'Загляните в гости к поэту, пройдитесь по просторным, торжественным залам с наборным паркетом. Посмотрите на элементы декора в стиле ампир: нарядные тяжелые шторы, реконструированные по образцам 1830-х годов, бронзовые и хрустальные люстры, золоченые бра, канделябры, жирандоли, вазы. Сегодня это не просто музей-квартира — это один из центров культурной жизни столицы, где проходят спектакли, музыкальные вечера, дипломатические приемы, церемонии бракосочетания и научные конференции.',
                  lat: 55.747502,
                  lon: 37.585733,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_18.jpg"),
                  title: 'Государственный музей А.С. Пушкина',
                  address: 'Москва, Пречистенка, 12/2',
                  description: 'Двести лет назад званые вечера в ампирном особняке собирали весь высший свет Москвы. Почувствуйте себя знатной особой, перед которой гостеприимно распахнутся двери усадьбы Хрущевых. Перед вами оживут Пушкин и его современники, их непринужденные беседы и горячие дискуссии о судьбах Родины. В залах, посвященных биографии поэта, вы увидите свидетельства становления гения. А юные экскурсанты смогут отправиться на остров Буян, побывать на ярмарке и в других местах волшебного мира сказок Пушкина.',
                  lat: 55.743548,
                  lon: 37.597603,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_19.jpg"),
                  title: 'Мемориальный музей А.Н. Скрябина',
                  address: 'Москва, Б.Николопесковский пер, 11',
                  description: 'Документы, фотографии, письма, афиши, программы, рукописи, прижизненные издания нот Скрябина — в Музее собрано более 30 тыс. экспонатов. Послушайте музыку Скрябина в авторском исполнении. Пройдитесь по комнатам, в которых воссозданы исторические интерьеры и чудом сохранилась аутентичная меблировка. Узнайте, как в начале XX века композитор предвосхитил эпоху дискотек и световых шоу. И постарайтесь попасть на концерт — ведь это место создано для того, чтобы наслаждаться музыкой.',
                  lat: 55.750750,
                  lon: 37.590062,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_20.jpg"),
                  title: 'Музей истории ГУЛАГа',
                  address: 'Москва, 1-й Самотечный пер., 9с1',
                  description: 'В мрачных стенах Музея собраны документы, письма и воспоминания репрессированных, их личные вещи и предметы лагерного быта, произведения искусства, созданные художниками, прошедшими ГУЛАГ. Вы сможете услышать рассказы и истории жертв большого террора, заглянуть за колючую проволоку, пройтись по баракам. Вы узнаете, как ценою тысяч жизней советское государство осваивало труднодоступные земли, добывало уголь и золото, строило железные дороги, каналы, электростанции и даже целые города.',
                  lat: 55.777118,
                  lon: 37.613395,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_21.jpg"),
                  title: 'Музей Москвы. Провиантские склады',
                  address: 'Москва, Зубовский бул., 2',
                  description: 'Бывшие склады на Зубовском — не просто хранилище фондов музея. Здесь проходят выставки, занятия для детей, игры и спектакли. Летом во внутреннем дворе проводятся фестивали, концерты и праздники. Посмотрите шедевры документального кино, посетите лекции и семинары. Узнайте, как жили, во что одевались и что ели москвичи, как за 900 лет менялся Кремль и почему популярная столичная игра в «зернь» считалась запрещенной. С RUSSPASS доступно посещение одной из выставок музея, кроме «Тканей Москвы».',
                  lat: 55.736324,
                  lon: 37.593354,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_22.jpg"),
                  title: 'Музей Москвы. Центр Гиляровского',
                  address: 'Москва, Столешников пер., 9с5',
                  description: 'В 2017 году уютный особняк в Столешниковом переулке превратился в живое пространство, где ни дня не проходит без ярких событий и встреч с увлеченными людьми. Создание центра вдохновлено личностью и творчеством писателя Владимира Гиляровского, его любовью к родному городу и землякам. Здесь рождаются уникальные проекты, посвященные Москве и москвичам. Присматривайтесь к мелочам, вглядывайтесь в детали, узнавайте житейские истории и городские легенды. Станьте соавтором современной летописи столицы!',
                  lat: 55.763428,
                  lon: 37.615337,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_23.jpg"),
                  title: 'Музей-усадьба «Люблино»',
                  address: 'Москва, Летняя, 1с1',
                  description: 'Погрузитесь в роскошную жизнь русских аристократов, посетите дворянский бал или салонный вечер. Постарайтесь попасть на концерт в Розовом зале дворца, где даже знакомые мелодии зазвучат по-новому. Раскройте секреты хранителя усадьбы Амура. Познакомьтесь с основателем усадьбы Николаем Алексеевичем Дурасовым, который специально перенесся в наше время, чтобы помочь вам разгадать загадки Люблина. И не забудьте сделать на память фото в костюмах, сшитых по последнему слову моды XIX века!',
                  lat: 55.688500,
                  lon: 37.743062,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_7.jpg"),
                  title: 'Музей-усадьба «Измайлово»',
                  address: 'Москва, городок имени Баумана, 2с14',
                  description: 'Посетив Государев двор, вы окунетесь в роскошный царский быт 17-го столетия. Прогуляйтесь по березовой роще на берегу Серебряного пруда и насладитесь видом на Мостовую башню, где проходили заседания Боярской Думы. Поймайте ностальгическую волну, попробовав поднять чугунный утюг и полистав тетрадки советских школьников в «Старой московской квартире». Почувствуйте себя боярской четой, облачившись в исторические костюмы и сделав фото на память.',
                  lat: 55.792250,
                  lon: 37.763324,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_24.jpg"),
                  title: 'Московский музей современного искусства на Гоголевском',
                  address: 'Москва, Гоголевский бул., 10',
                  description: 'Здание, в котором располагается музей, само по себе примечательно: особняк был центром притяжения для талантов. Дом в разное время посещали поэт-декабрист Кондратий Рылеев, живописец Илья Репин, писатель Иван Тургенев, драматург Александр Островский, в 1920-х годах здесь собиралось тайное общество декабристов. Неудивительно, что работы современных художников так органично вписываются в старинные интерьеры: здесь сами стены хранят дух свободы и новаторства в творческих поисках.',
                  lat: 55.746898,
                  lon: 37.600308,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_6.jpg"),
                  title: 'Музей сословий',
                  address: 'Москва, Волхонка, 13с2',
                  description: 'Узнайте, как жила сословная России в XVIII и XIX столетии. Почувствуйте себя русским дворянином: осмотритесь в интерьерах усадебных анфилад, обставленных старинной мебелью, познакомьтесь с произведениями искусства образцами общеевропейской моды тех времен. О буднях российского духовенства вам расскажут произведения иконописи и деревянной храмовой скульптуры, кресты, складни. А расписные сани, сундуки и ларцы, самовары, прялки и народные костюмы разных губерний поведают о крестьянском быте.',
                  lat: 55.746633,
                  lon: 37.607628,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_25.jpg"),
                  title: 'Мемориальная квартира Андрея Белого',
                  address: 'Москва, Арбат, 55',
                  description: 'Квартира на Старом Арбате хранит в себе воспоминания о первых 26 годах жизни Андрея Белого. Здесь он пережил счастье первой любви и боль первой утраты. Здесь начинался его творческий путь, приведший к вершинам модернистского искусства. Сегодня квартира поэта вмещает в себя не только мемориальную экспозицию. Это еще и место творческих встреч, научных семинаров и конференций, книжных и журнальных презентаций, выставок изобразительного искусства, камерных концертов и спектаклей.',
                  lat: 55.747196,
                  lon: 37.585349,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_26.jpg"),
                  title: 'Выставочные залы государственного музея А.С. Пушкина',
                  address: 'Москва, Денежный пер., 55/32',
                  description: 'В Выставочных залах в Денежном переулке можно увидеть не только работы современных художников, но и фотографии, эскизы театральных декораций, инсталляции модных дизайнеров. В свое время большим событием стала экспозиция портретной фотографии, на которой музей впервые показывал свою фотографическую коллекцию – редкие ранние снимки известных российских фотоателье, работы известных фотохудожников.',
                  lat: 55.747104,
                  lon: 37.585407,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_27.jpg"),
                  title: 'Дом-музей В.Л. Пушкина',
                  address: 'Москва, Старая Басманная, 36',
                  description: 'Вы увидите редкие произведения изобразительного и декоративно-прикладного искусства, предметы мебели и убранства, книги XVIII – первой трети XIX века. Здесь бережно воссозданы интерьеры комнат, хранящих память о визитах именитых гостей. Вы узнаете историю жизни и творчества Василия Пушкина, его взаимоотношений с племянником. Перенеситесь в уютный быт пушкинской эпохи с давно ушедшими из нашей жизни мелочами и прочувствуйте удивительную атмосферу гостеприимного московского дома.',
                  lat: 55.769039,
                  lon: 37.668933,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_28.jpg"),
                  title: 'Есенин-центр',
                  address: 'Москва, Пер. Чернышевского, 4с2',
                  description: 'Здание в переулке Чернышевского - это самое сердце есенинской Москвы. Рядом, на Новой Божедомке (ныне Достоевского) Есенин проживал во времена сотрудничества с Суриковским литературно-музыкальным кружком. В 15-ти минутах ходьбы от Центра - здание современного РГГУ на Миусской площади, где в 1913 году располагался Народный университет имени Шанявского, куда поэт поступил вольнослушателем. В самом же особняке часто проходили творческие вечера и диспуты, которые неоднократно посещал Есенин.',
                  lat: 55.782127,
                  lon: 37.609236,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_29.jpg"),
                  title: 'Выставочный зал Музея С.А. Есенина',
                  address: 'Москва, Клязьминская, 21к2',
                  description: 'У Выставочного зала на Клязьминской — насыщенный календарь событий. Экскурсии по есенинским местам, художественно-музыкальные лекции, концерты, мастер-классы по изготовлению народных игрушек, кукол и рукописных книг, интерактивные программы с традиционными русскими играми… И, конечно же, выставки личных вещей, рукописей и фотографий Есенина, помогающие понять его творчество и мир, в котором он жил.',
                  lat: 55.893294,
                  lon: 37.529115,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_30.jpg"),
                  title: 'Музей русской гармоники А. Мирека',
                  address: 'Москва, 2-я Тверская-Ямская ул., 18',
                  description: 'Перед вами оживет история конструкторской мысли и развития гармонного производства – от частного, кустарного до современного промышленного. Вы узнаете, как гармоника вошла в обиход народных исполнителей и как стала предметом освоения профессиональных музыкантов. Здесь собрана уникальная коллекция музыкальных инструментов, афиш, фотографий, документов, звукозаписей, учебных и архивных материалов. Это — результат полувековых трудов доктора искусствоведения, профессора Мирека.',
                  lat: 55.772046,
                  lon: 37.594881,
                ),
              ),
              Expanded(
                child: _LocationsAndActivitiesCard(
                  image: AssetImage("images/mock_images/geo_31.jpg"),
                  title: 'Мемориальный дом-музей академика С.П. Королева',
                  address: 'Москва, 1-я Останкинская, 28',
                  description: 'Посмотрите, в какой обстановке жил, мечтал и творил отец мировой космонавтики. В фондах музея хранится около 19 тыс. экспонатов — свидетелей эпохи перемен и титанического труда Сергея Павловича и его сподвижников. Старенький телевизор, нехитрая и трогательная кухонная утварь, фотографии, записные книжки, студенческие конспекты и огромная библиотека — все это окружало академика Королева на Земле, пока мыслями он проносился через Вселенную.',
                  lat: 55.823277,
                  lon: 37.631972,
                ),
              ),
            ],
          ),
//          SizedBox(height: 16),
//          _Button(text: 'Смотреть все'),
        ],
      ),
    );
  }
}

class _LocationsAndActivitiesCard extends StatelessWidget {
  final String title;
  final String address;
  final ImageProvider image;
  final String description;
  final double lat;
  final double lon;

  const _LocationsAndActivitiesCard({
    Key key,
    @required this.title,
    @required this.address,
    @required this.image,
    @required this.description,
    @required this.lat,
    @required this.lon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(ActivityPage.route(
            title,
            address,
            image,
            description,
            lat,
            lon
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        height: 202,
        decoration: BoxDecoration(
          color: Color(0xFFD8D8D8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: FadeBackgroundImage(
                  image,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 107,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [rgba(6, 12, 4, 0), rgba(8, 17, 14, 0.9)],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: NamedFontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Button extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const _Button({Key key, @required this.text, this.onPressed})
      : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  bool _isPressed = false;

  buttonStyle(pressed) => TxtStyle()
    ..background.color(Color(0xFFF7F7F7))
    ..alignmentContent.center()
    ..textColor(AppColors.darkGray)
    ..borderRadius(all: 6)
    ..height(50)
    ..fontSize(17)
    ..margin(left: 6, right: 6)
    ..ripple(true)
    ..boxShadow(
      blur: pressed ? 17 : 0,
      offset: [0, pressed ? 4 : 0],
      color: pressed ? rgba(0, 0, 0, 0.3) : rgba(0, 0, 0, 0.0),
    )
    ..animate(150, Curves.easeOut);

  GestureClass buttonGestures() => GestureClass()
    ..isTap((isPressed) => setState(() => _isPressed = isPressed))
    ..onTap(widget.onPressed);

  @override
  Widget build(BuildContext context) {
    return Txt(
      widget.text,
      style: buttonStyle(_isPressed),
      gesture: buttonGestures(),
    );
  }
}
