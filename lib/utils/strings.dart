String formatCount(int count, List<String> names) {
  final scount = count.toString();
  final l = scount.length;
  final lastDecimal = int.parse(scount.substring(l - 1, l));
  final firstDecimal = int.parse(scount.substring(0,1));

  String name;

  if (lastDecimal == 0) {
    name = names[0];
  } else if (lastDecimal == 1) {
    name = names[1];
  } else if (lastDecimal < 5) {
    name = names[2];
  } else {
    name = names[0];
  }

  if (l == 2 && firstDecimal == 1) {
    name = names[0];
  }

  return '$count $name';
}

String formatDuration(double time) {
  final int minutes = (time / 60.0).round();

  if (minutes < 60) {
    return formatCount(minutes, ['минут', 'минута', 'минуты']);
  } else {
    final int hours = (minutes / 60.0).floor();
    final m = formatCount(minutes - (hours * 60), ['минут', 'минута', 'минуты']);
    final h = formatCount(hours, ['часов', 'час', 'часа']);

    return '$h $m';
  }
}

String formatDistance(double distance) {
  if (distance < 1000) {
    return '${distance.round()} м.';
  } else {
    final km = (distance / 1000).toStringAsFixed(1);

    if (km.endsWith('.0')) {
      return '${km.substring(0, km.length - 2)} км.';
    } else {
      return '$km км.';
    }
  }
}
