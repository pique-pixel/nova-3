import 'package:flutter_test/flutter_test.dart';
import 'package:rp_mobile/utils/strings.dart';

void main() {
  test('formatCount - minutes', () {
    final names = ['минут', 'минута', 'минуты'];

    expect(formatCount(0, names), '0 минут');
    expect(formatCount(1, names), '1 минута');
    expect(formatCount(2, names), '2 минуты');
    expect(formatCount(4, names), '4 минуты');
    expect(formatCount(5, names), '5 минут');
    expect(formatCount(8, names), '8 минут');
    expect(formatCount(90, names), '90 минут');
  });

  test('formatCount - hours', () {
    final names = ['часов', 'час', 'часа'];

    expect(formatCount(0, names), '0 часов');
    expect(formatCount(1, names), '1 час');
    expect(formatCount(2, names), '2 часа');
    expect(formatCount(4, names), '4 часа');
    expect(formatCount(5, names), '5 часов');
    expect(formatCount(8, names), '8 часов');
    expect(formatCount(90, names), '90 часов');
  });

  test('formatCount - stations', () {
    final names = ['станций', 'станция', 'станции'];

    expect(formatCount(0, names), '0 станций');
    expect(formatCount(1, names), '1 станция');
    expect(formatCount(2, names), '2 станции');
    expect(formatCount(4, names), '4 станции');
    expect(formatCount(5, names), '5 станций');
    expect(formatCount(8, names), '8 станций');
    expect(formatCount(90, names), '90 станций');
  });

  test('formatCount - stops', () {
    final names = ['остановок', 'остановка', 'остановки'];

    expect(formatCount(0, names), '0 остановок');
    expect(formatCount(1, names), '1 остановка');
    expect(formatCount(2, names), '2 остановки');
    expect(formatCount(4, names), '4 остановки');
    expect(formatCount(5, names), '5 остановок');
    expect(formatCount(8, names), '8 остановок');
    expect(formatCount(90, names), '90 остановок');
    expect(formatCount(21, names), '21 остановка');
    expect(formatCount(23, names), '23 остановки');
    expect(formatCount(1001, names), '1001 остановка');
  });

  test('formatDistance', () {
    expect(formatDistance(1), '1 м.');
    expect(formatDistance(90), '90 м.');
    expect(formatDistance(2500), '2.5 км.');
    expect(formatDistance(2666), '2.7 км.');
    expect(formatDistance(2000), '2 км.');
  });

  test('formatDuration', () {
    expect(formatDuration(100), '2 минуты');
    expect(formatDuration(6000), '1 час 40 минут');
  });
}
