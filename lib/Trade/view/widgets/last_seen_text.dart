String lastSeenText({
  required DateTime date,
  required bool isOnline,
}) {
  final minute = DateTime.now().difference(date).inMinutes;
  if (isOnline) {
    return 'çevrimiçi';
  } else {
    if (minute > 15 && minute < 60) {
      return '$minute dakika önce aktifti';
    } else if (minute >= 60 && minute < 60 * 24) {
      return '${(minute / 60).toStringAsFixed(0)} saat önce aktifti';
    } else if (minute >= 60 * 24 && minute < 1440 * 7) {
      return '${(minute / 1440).toStringAsFixed(0)} gün önce aktifti';
    } else if (minute >= 1440 * 7) {
      return '${(minute / 1440 * 7).toStringAsFixed(0)} hafta önce aktifti';
    } else {
      return 'az önce görüldü';
    }
  }
}

String notificationDateTime({
  required DateTime date,
}) {
  final minute = DateTime.now().difference(date).inMinutes;

  if (minute > 15 && minute < 60) {
    return '$minute dk';
  } else if (minute >= 60 && minute < 60 * 24) {
    return '${(minute / 60).toStringAsFixed(0)} sa';
  } else if (minute >= 60 * 24 && minute < 1440 * 7) {
    return '${(minute / 1440).toStringAsFixed(0)} g';
  } else if (minute >= 1440 * 7) {
    return '${(minute / 1440 * 7).toStringAsFixed(0)} ha';
  } else {
    return 'şimdi';
  }
}
