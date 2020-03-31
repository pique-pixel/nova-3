import 'package:optional/optional.dart';
import 'package:rp_mobile/containers/image.dart';
import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/bloc/single_ticket_content_details/single_ticket_content_details_models.dart';
import 'package:rp_mobile/layers/bloc/tickets/tickets_models.dart';
import 'package:rp_mobile/layers/services/tickets_services.dart';
import 'package:rp_mobile/locale/localized_string.dart';
import 'package:rp_mobile/utils/future.dart';

class TicketsServiceMockImpl implements TicketsService {
  @override
  Future<Page<TicketItemModel>> getTickets([int page = 1]) async {
    await delay(1000);
    print('PAGE IS: $page');

    if (page == 1) {
      return Page(
        nextPage: 2,
        data: <TicketItemModel>[
          TicketItemModel(
            ref: '1',
            title: LocalizedString.fromString(
                'Единый билет для пакета «Москва за 3 дня»'),
            thumbnail: ImageEither.asset('images/mock_images/msk.png'),
          ),
          TicketItemModel(
            ref: '2',
            title: LocalizedString.fromString('Билет «Аэроэкспресс»'),
            thumbnail: ImageEither.asset('images/mock_images/aero.png'),
          ),
          TicketItemModel(
            ref: '3',
            title:
                LocalizedString.fromString('Метро и наземный транспорт Москвы'),
            thumbnail: ImageEither.asset('images/mock_images/troyka.png'),
          ),
        ],
      );
    } else if (page == 2) {
      return Page(
        nextPage: null,
        data: <TicketItemModel>[
          TicketItemModel(
            ref: '4',
            title: LocalizedString.fromString('Билет «Аэроэкспресс»'),
            thumbnail: ImageEither.asset('images/mock_images/aero.png'),
          ),
          TicketItemModel(
            ref: '5',
            title:
                LocalizedString.fromString('Метро и наземный транспорт Москвы'),
            thumbnail: ImageEither.asset('images/mock_images/troyka.png'),
          ),
          TicketItemModel(
            ref: '6',
            title: LocalizedString.fromString(
                'Единый билет для пакета «Москва за 3 дня»'),
            thumbnail: ImageEither.asset('images/mock_images/msk.png'),
          ),
        ],
      );
    } else {
      return Page(data: [], nextPage: null);
    }
  }

  @override
  Future<TicketInfoModel> getTicketInfo(String ref) async {
    switch (ref) {
      case '1':
        return TicketInfoModel(
          title: LocalizedString.fromString(
              'Единый билет для пакета\n«Москва за 3 дня»'),
          subTitle: LocalizedString.fromString('RUSSPASS'),
          hint: LocalizedString.fromString('Покажите QR-код сотруднику'),
          qrCode: Optional.of('R0P3D7MWEW'),
          thumbnail: Optional.empty(),
        );

      case '2':
        return TicketInfoModel(
          title:
              LocalizedString.fromString('Электронный билет\n«Аэроэкспресс»'),
          subTitle: LocalizedString.fromString('Аэроэкспресс'),
          hint: LocalizedString.fromString('Покажите QR-код сотруднику'),
          qrCode: Optional.of('R0P3D7MWEWR0P3D7MWEW'),
          thumbnail: Optional.empty(),
        );

      case '3':
        return TicketInfoModel(
          title: LocalizedString.fromString(
              '15 поездок на метро и наземном\nтранспорте Москвы'),
          subTitle: LocalizedString.fromString('Тройка'),
          hint: LocalizedString.fromString(
              'Карта входит в состав вашего туристического\n'
              'пакета и используется для проезда на любом\n'
              'общественном транспорте'),
          qrCode: Optional.empty(),
          thumbnail: Optional.of(
            ImageEither.asset('images/mock_images/troika_card.png'),
          ),
        );
    }

    throw TicketsException(
      LocalizedString.fromString('Ticket information hasn\'t found'),
      'Ticket information hasn\'t found',
    );
  }

  @override
  Future<TicketType> getTicketType(String ref) async {
    switch (ref) {
      case '1':
        return TicketType.museum;

      case '2':
        return TicketType.transport;

      case '3':
        return TicketType.museum;
    }

    throw TicketsException(
      LocalizedString.fromString('Unknown ticket type'),
      'Unknown ticket type',
    );
  }

  @override
  Future<SingleTicketContentDetails> getSingleTicketContentDetails(
      String ref) async {
    await delay(1000);
    switch (ref) {
      case '1':
        return SingleTicketContentDetails(
          headerThumbnail: ImageEither.asset('images/mock_images/msk.png'),
          title: LocalizedString.fromString('Ticket 1'),
          tags: [
            LocalizedString.fromString('развлечения'),
            LocalizedString.fromString('рекомендуем'),
          ],
          sections: [
            SingleTicketContentAddressSection(
              address: Optional.of(
                LocalizedString.fromString('г. Химки, аэропорт Шереметьево'),
              ),
              webSite: Optional.of('https://google.com'),
            ),
            SingleTicketContentIconInfoSpoilerBarSection(
              icon: SingleTicketContentSectionIcon.calendar,
              text: LocalizedString.fromString('Режим работы: 04.30 - 00.30'),
              spoilerText: LocalizedString.fromString(
                'Пн, Чт-Сб: 10.00 - 17.30\n'
                'Вт: 10.00 - 16.30\n'
                'Вс: 11.00 - 17.30\n'
                'Ср - выходной',
              ),
            ),
            SingleTicketContentIconInfoBarSection(
              icon: SingleTicketContentSectionIcon.disabled,
              text: LocalizedString.fromString('Адаптирован для МГН'),
            ),
            SingleTicketContentInfoBarTariffSection(
              text: LocalizedString.fromString('Тариф Взрослый'),
              time: LocalizedString.fromString('≈ 5 ч 30 м'),
              price: LocalizedString.fromString('1000 р'),
            ),
            SingleTicketContentMapSection(
              latitude: 55.751244,
              longitude: 37.618423,
            ),
            SingleTicketContentDescSection(
              text: LocalizedString.fromString(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do'
                'eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                'Ut enim ad minim veniam, quis nostrud exercitation ullamco'
                'laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure'
                'dolor in reprehenderit in voluptate velit esse cillum dolore eu'
                'fugiat nulla pariatur. Excepteur sint occaecat cupidatat non'
                'proident, sunt in culpa qui officia deserunt mollit anim id'
                'est laborum.',
              ),
            ),
          ],
        );

      case '2':
        return SingleTicketContentDetails(
          headerThumbnail: ImageEither.asset('images/mock_images/aero.png'),
          title: LocalizedString.fromString('Ticket 2'),
          tags: [
            LocalizedString.fromString('рекомендуем'),
            LocalizedString.fromString('развлечения'),
            LocalizedString.fromString('для детей'),
          ],
          sections: [
            SingleTicketContentAddressSection(
              address: Optional.of(
                LocalizedString.fromString('г. Химки, аэропорт Шереметьево'),
              ),
              webSite: Optional.empty(),
            ),
            SingleTicketContentIconInfoSpoilerBarSection(
              icon: SingleTicketContentSectionIcon.calendar,
              text: LocalizedString.fromString('Режим работы: 14.30 - 20.00'),
              spoilerText: LocalizedString.fromString(
                'Пн, Чт-Сб: 10.00 - 17.30\n'
                'Вт: 10.00 - 16.30\n'
                'Вс: 11.00 - 17.30\n'
                'Ср - выходной',
              ),
            ),
            SingleTicketContentInfoBarSection(
              text: LocalizedString.fromString('Тариф Детский'),
            ),
            SingleTicketContentMapSection(
              latitude: 55.018803,
              longitude: 82.933952,
            ),
            SingleTicketContentDescSection(
              text: LocalizedString.fromString(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do'
                'eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                'Ut enim ad minim veniam, quis nostrud exercitation ullamco'
                'laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure'
                'dolor in reprehenderit in voluptate velit esse cillum dolore eu'
                'fugiat nulla pariatur. Excepteur sint occaecat cupidatat non'
                'proident, sunt in culpa qui officia deserunt mollit anim id'
                'est laborum.',
              ),
            ),
          ],
        );

      case '3':
        return SingleTicketContentDetails(
          headerThumbnail: ImageEither.asset('images/mock_images/troyka.png'),
          title: LocalizedString.fromString('Ticket 3'),
          tags: [
            LocalizedString.fromString('рекомендуем'),
            LocalizedString.fromString('развлечения'),
          ],
          sections: [
            SingleTicketContentAddressSection(
              address: Optional.empty(),
              webSite: Optional.of('https://vk.com'),
            ),
            SingleTicketContentIconInfoSpoilerBarSection(
              icon: SingleTicketContentSectionIcon.calendar,
              text: LocalizedString.fromString('Режим работы: 12.00 - 15.00'),
              spoilerText: LocalizedString.fromString(
                'Пн, Чт-Сб: 10.00 - 17.30\n'
                'Вт: 10.00 - 16.30\n'
                'Вс: 11.00 - 17.30\n'
                'Ср - выходной',
              ),
            ),
            SingleTicketContentIconInfoSpoilerBarSection(
              icon: SingleTicketContentSectionIcon.disabled,
              text: LocalizedString.fromString('Адаптирован для МГН'),
              spoilerText: LocalizedString.fromString(
                'Сидячие инвалиды\n'
                'Слепые',
              ),
            ),
            SingleTicketContentInfoBarSection(
              text: LocalizedString.fromString('Тариф Взрослый и Детский'),
            ),
            SingleTicketContentMapSection(
              latitude: 35.652832,
              longitude: 139.839478,
            ),
            SingleTicketContentDescSection(
              text: LocalizedString.fromString(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do'
                'eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                'Ut enim ad minim veniam, quis nostrud exercitation ullamco'
                'laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure'
                'dolor in reprehenderit in voluptate velit esse cillum dolore eu'
                'fugiat nulla pariatur. Excepteur sint occaecat cupidatat non'
                'proident, sunt in culpa qui officia deserunt mollit anim id'
                'est laborum.',
              ),
            ),
          ],
        );
    }

    throw TicketsException(
      LocalizedString.fromString('Ticket content details hasn\'t found'),
      'Ticket content details hasn\'t found',
    );
  }
}
