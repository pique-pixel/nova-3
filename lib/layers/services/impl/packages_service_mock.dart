import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/bloc/services_package_details/services_package_details_models.dart';
import 'package:rp_mobile/layers/bloc/services_package_list/services_package_list_models.dart';
import 'package:rp_mobile/layers/services/packages_service.dart';
import 'package:rp_mobile/utils/future.dart';

class PackagesServiceMockImpl implements PackagesService {
  @override
  Future<Page<PackageItemModel>> getPackageItems([int page = 1]) async {
    await delay(1000);

    if (page == 1) {
      return Page(
        data: [
          PackageItemModel(
            ref: '1',
            title: 'Москва и Санкт-Петербург на 3 дня',
            thumbnailUrl: 'https://picsum.photos/800',
            type: 'Взрослый',
            untilDate: 'Получить до 26 декабря',
            soonWillEnd: true,
            openQRCode: false,
          ),
          PackageItemModel(
            ref: '2',
            title: 'Москва на 4 дня',
            thumbnailUrl: 'https://picsum.photos/900',
            type: 'Взрослый',
            untilDate: 'Получить до 28 декабря',
            soonWillEnd: false,
            openQRCode: true,
          ),
          PackageItemModel(
            ref: '3',
            title: 'Новосибирск на 5 дня',
            thumbnailUrl: 'https://picsum.photos/700',
            type: 'Взрослый',
            untilDate: 'Получить до 18 января',
            soonWillEnd: false,
            openQRCode: true,
          ),
        ],
        nextPage: 2,
      );
    } else if (page == 2) {
      return Page(
        nextPage: null,
        data: [
          PackageItemModel(
            ref: '4',
            title: 'Москва и Санкт-Петербург на 3 дня',
            thumbnailUrl: 'https://picsum.photos/1000',
            type: 'Взрослый',
            untilDate: 'Получить до 26 декабря',
            soonWillEnd: true,
            openQRCode: false,
          ),
          PackageItemModel(
            ref: '5',
            title: 'Москва на 4 дня',
            thumbnailUrl: 'https://picsum.photos/850',
            type: 'Взрослый',
            untilDate: 'Получить до 28 декабря',
            soonWillEnd: false,
            openQRCode: true,
          ),
          PackageItemModel(
            ref: '6',
            title: 'Новосибирск на 5 дня',
            thumbnailUrl: 'https://picsum.photos/750',
            type: 'Взрослый',
            untilDate: 'Получить до 18 января',
            soonWillEnd: false,
            openQRCode: true,
          ),
        ],
      );
    } else {
      return Page(data: [], nextPage: null);
    }
  }

  @override
  Future<List<SectionModel>> getPackageDetails(String ref) async {
    await delay(1000);
    final packageConstitution = PackageConstitutionSection(
      title: 'В составе пакета',
      items: [
        PackageConstitutionItem(
          title: 'City Sightseeing Moscow',
          description: '',
          thumbnailUrl : 'https://russpass.technolab.com.ru/v1/file/91572707-ab8c-4f60-aee6-117a2737d071',
        ),
        PackageConstitutionItem(
          title: 'Карта «Тройка»',
          description: '',
          thumbnailUrl : 'https://russpass.technolab.com.ru/v1/file/05ee0fd6-018d-45e7-a9db-6208ce1cec19',
        ),
        PackageConstitutionItem(
          title: 'Московская канатная дорога',
          description: '',
          thumbnailUrl : 'https://russpass.technolab.com.ru/v1/file/c0e91c51-7e28-4370-abbb-21a3b908bac2',
        ),
      ],
    );

    final activities = ActivitiesSection(
      title: 'Локации и активности',
      description: 'Мегаполис будущего, сохранивший обаяние красавицы из древних русских сказок. '
          'Для первой прогулки по эклектичной Москве недостаточно карты города с указанием знаковых мест - нужен личный помощник, '
          'персонаж-проводник из тех самых сказок. Он знает лучший путь, дарит возможность наслаждаться дорогой и не скучать, '
          'а в конце путешествия точно подведёт вас к тому, что вы искали. '
          '\n\nЗабудьте об очередях за билетами и не тратьте время на поиск интересных мест. '
          'В туристический пакет RUSSPASS уже включено всё, чтобы вы могли наслаждаться поездкой, '
          'а любая из выбранных дорог привела вас к впечатлениям! Более 10 музеев, парков, картинных галерей и других туристических локаций, '
          '15 поездок на общественном транспорте, путешествие по канатной дороге с Воробьевых гор и обзорная экскурсия на даблдекере '
          'City Sightseeing Bus. Просто найдите время – остальное сделает RUSSPASS.'
          '\n\nОбратите внимание, что каждой услугой из туристического пакета можно воспользоваться не более 1 раза.',
      filters: [
        ActivityFilter(ref: 'f1', title: 'filter 1'),
        ActivityFilter(ref: 'f2', title: 'filter 2'),
        ActivityFilter(ref: 'f3', title: 'filter 3'),
        ActivityFilter(ref: 'f4', title: 'filter 4'),
        ActivityFilter(ref: 'f5', title: 'filter 5'),
        ActivityFilter(ref: 'f6', title: 'filter 6'),
      ],
      activities: [
        ActivityModel(
          title: 'Музей-заповедник «Царицыно»',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/b25a88d8-55ae-4530-820e-d9bba052d94b',
        ),
        ActivityModel(
          title: 'Музей космонавтики',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/2f3dff4e-d1c6-4902-a760-559869e4029a',
        ),
        ActivityModel(
          title: 'Мемориальный музей А.Н. Скрябина',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/2d706299-2939-4acf-bec0-5acf63c290df',
        ),
        ActivityModel(
          title: 'Музей Москвы. Провиантские склады',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/cae83343-3c36-4ae9-84f8-2ddf5e4e68e8',
        ),
        ActivityModel(
          title: 'Музей Москвы. Центр Гиляровского',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/fa5f5700-eebe-4a38-a993-2d88615fb6a5',
        ),
        ActivityModel(
          title: 'Мультимедиа Арт Музей',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/5d6dd9b4-416f-4861-b6a4-97fe6781b045',
        ),
        ActivityModel(
          title: 'Музей истории ГУЛАГа',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/31baa512-2cb7-4551-b2c9-4c9bdcffa6cd',
        ),
        ActivityModel(
          title: 'Московский зоопарк',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/8542f086-7eda-4569-8ebc-125789a67071',
        ),
        ActivityModel(
          title: 'Парк Горького и музей парка',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/52adcd9b-2dfc-43f4-a7e7-1787f0591b29',
        ),
        ActivityModel(
          title: 'Московский музей современного искусства на Петровке',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/fc5a1158-c99c-4223-a758-94066c045c54',
        ),
        ActivityModel(
          title: 'Мемориальный дом-музей академика С.П. Королева',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/fc4aedb5-c0b7-4129-b473-10cecb38adf9',
        ),
        ActivityModel(
          title: 'Московский музей современного искусства на Гоголевском',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/272fc024-16c4-4cac-8698-87e0a8cfe1d5',
        ),
        ActivityModel(
          title: 'Музей археологии Москвы',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/cb546125-a159-44e3-a51c-2237e77513f2',
        ),
        ActivityModel(
          title: 'Музей Москвы. Музей истории Лефортово',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/925b25df-28ca-48c3-9d13-40cf0c2520e7',
        ),
        ActivityModel(
          title: 'Посещение старого английского двора',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/0ec5e2cd-6735-4b87-8bad-564e4c7a3eac',
        ),
        ActivityModel(
          title: 'Государственный Дарвиновский музей',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/cf543923-2c9e-42fd-a1d5-abfdaac10311',
        ),
      ],
    );

    switch (ref) {
      case '1':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/800',
            title: 'Москва и Санкт-Петербург на 3 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
              CityModel(ref: '2', name: 'Санкт петербург', isSelected: false),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '5e55261f826e00001944c576':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/ffbc5784-78fd-4e0a-95ba-925b569a5764',
            title: 'Москва на 3 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Получить до 28 декабря', SubTitleGrade.grade1),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '3':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/700',
            title: 'Новосибирск на 5 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Новосибирск', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '4':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/1000',
            title: 'Москва и Санкт-Петербург на 3 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
              CityModel(ref: '2', name: 'Санкт петербург', isSelected: false),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '5':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/850',
            title: 'Москва на 4 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Получить до 28 декабря', SubTitleGrade.grade1),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '6':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/750',
            title: 'Новосибирск на 5 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Новосибирск', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      default:
        throw AssertionError();
    }
  }

  @override
  Future<ActivitiesSection> getAllPackageActivities(
    String ref, [
    List<String> filter = const [],
  ]) async {
    await delay(1000);
    return ActivitiesSection(
      isLoadedAllItems: true,
      title: 'Локации и активности',
      description: 'Москва многолика. Царица, воплощающая русскую душу с ее '
          'широтой и щедростью. Как радушная хозяйка, она удивляет '
          'уютом старых улочек, тишиной парков, древней, с любовью '
          'оберегаемой архитектурой. В облике светской дамы проведет на '
          'выставку, в музей, на театральную премьеру. ',
      filters: [
        ActivityFilter(
          ref: 'f1',
          title: 'filter 1',
          isActive: filter.contains('f1'),
        ),
        ActivityFilter(
          ref: 'f2',
          title: 'filter 2',
          isActive: filter.contains('f2'),
        ),
        ActivityFilter(
          ref: 'f3',
          title: 'filter 3',
          isActive: filter.contains('f3'),
        ),
        ActivityFilter(
          ref: 'f4',
          title: 'filter 4',
          isActive: filter.contains('f4'),
        ),
        ActivityFilter(
          ref: 'f5',
          title: 'filter 5',
          isActive: filter.contains('f5'),
        ),
        ActivityFilter(
          ref: 'f6',
          title: 'filter 6',
          isActive: filter.contains('f6'),
        ),
      ],
      activities: [
        ActivityModel(
          title: 'Музей-заповедник «Коломенское»',
          thumbnailUrl: 'https://russpass.technolab.com.ru/v1/file/80f37a5e-498e-4eb5-94fc-518b9239ebcf',
        ),
        ActivityModel(
          title: 'Московский зоопарк',
          thumbnailUrl: 'https://picsum.photos/500',
        ),
        ActivityModel(
          title: 'Музей археологии Москвы',
          thumbnailUrl: 'https://picsum.photos/600',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/650',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/400',
        ),
        ActivityModel(
          title: 'Московский зоопарк',
          thumbnailUrl: 'https://picsum.photos/500',
        ),
        ActivityModel(
          title: 'Музей археологии Москвы',
          thumbnailUrl: 'https://picsum.photos/600',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/650',
        ),
      ],
    );
  }

  @override
  Future<ActivitiesSection> filterPackageActivities(
    String ref,
    List<String> filters,
    bool loadAllActivities,
  ) async {
    await delay(1000);
    return ActivitiesSection(
      isLoadedAllItems: true,
      title: 'Локации и активности',
      description: 'Москва многолика. Царица, воплощающая русскую душу с ее '
          'широтой и щедростью. Как радушная хозяйка, она удивляет '
          'уютом старых улочек, тишиной парков, древней, с любовью '
          'оберегаемой архитектурой. В облике светской дамы проведет на '
          'выставку, в музей, на театральную премьеру. ',
      filters: [
        ActivityFilter(
          ref: 'f1',
          title: 'filter 1',
          isActive: filters.contains('f1'),
        ),
        ActivityFilter(
          ref: 'f2',
          title: 'filter 2',
          isActive: filters.contains('f2'),
        ),
        ActivityFilter(
          ref: 'f3',
          title: 'filter 3',
          isActive: filters.contains('f3'),
        ),
        ActivityFilter(
          ref: 'f4',
          title: 'filter 4',
          isActive: filters.contains('f4'),
        ),
        ActivityFilter(
          ref: 'f5',
          title: 'filter 5',
          isActive: filters.contains('f5'),
        ),
        ActivityFilter(
          ref: 'f6',
          title: 'filter 6',
          isActive: filters.contains('f6'),
        ),
      ],
      activities: [
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/400',
        ),
        ActivityModel(
          title: 'Московский зоопарк',
          thumbnailUrl: 'https://picsum.photos/500',
        ),
        ActivityModel(
          title: 'Музей археологии Москвы',
          thumbnailUrl: 'https://picsum.photos/600',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/650',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/400',
        ),
        ActivityModel(
          title: 'Московский зоопарк',
          thumbnailUrl: 'https://picsum.photos/500',
        ),
        ActivityModel(
          title: 'Музей археологии Москвы',
          thumbnailUrl: 'https://picsum.photos/600',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/650',
        ),
      ],
    );
  }

  @override
  Future<List<SectionModel>> getPackageDetailsForCity(
    String ref,
    String cityRef,
  ) async {
    await delay(1000);
    final packageConstitution = PackageConstitutionSection(
      title: 'В составе пакета',
      items: [
        PackageConstitutionItem(
          title: 'Аэроэкспесс 1',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 2',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 3',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 4',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 5',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 6',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 7',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 8',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
      ],
    );

    final activities = ActivitiesSection(
      title: 'Локации и активности',
      description: 'Москва многолика. Царица, воплощающая русскую душу с ее '
          'широтой и щедростью. Как радушная хозяйка, она удивляет '
          'уютом старых улочек, тишиной парков, древней, с любовью '
          'оберегаемой архитектурой. В облике светской дамы проведет на '
          'выставку, в музей, на театральную премьеру. ',
      filters: [
        ActivityFilter(ref: 'f1', title: 'filter 1'),
        ActivityFilter(ref: 'f2', title: 'filter 2'),
        ActivityFilter(ref: 'f3', title: 'filter 3'),
        ActivityFilter(ref: 'f4', title: 'filter 4'),
        ActivityFilter(ref: 'f5', title: 'filter 5'),
        ActivityFilter(ref: 'f6', title: 'filter 6'),
      ],
      activities: [
        ActivityModel(
          title: 'Музей-заповедник «Коломенское»',
          thumbnailUrl: 'https://picsum.photos/400',
        ),
        ActivityModel(
          title: 'Московский зоопарк',
          thumbnailUrl: 'https://picsum.photos/500',
        ),
        ActivityModel(
          title: 'Музей археологии Москвы',
          thumbnailUrl: 'https://picsum.photos/600',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/650',
        ),
      ],
    );

    switch (ref) {
      case '1':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/800',
            title: 'Москва и Санкт-Петербург на 3 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(
                ref: '1',
                name: 'Москва',
                isSelected: cityRef == '1',
              ),
              CityModel(
                ref: '2',
                name: 'Санкт петербург',
                isSelected: cityRef == '2',
              ),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '2':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/900',
            title: 'Москва на 4 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Получить до 28 декабря', SubTitleGrade.grade1),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '3':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/700',
            title: 'Новосибирск на 5 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Новосибирск', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '4':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/1000',
            title: 'Москва и Санкт-Петербург на 3 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
              CityModel(ref: '2', name: 'Санкт петербург', isSelected: false),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '5':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/850',
            title: 'Москва на 4 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Получить до 28 декабря', SubTitleGrade.grade1),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '6':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/750',
            title: 'Новосибирск на 5 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Новосибирск', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      default:
        throw AssertionError();
    }
  }
}
