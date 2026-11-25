/// Стандартні відступи, радіуси та обмеження ширини.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;

  static const double radius = 16;

  /// Максимальна ширина форм авторизації (щоб на планшеті не розтягувались).
  static const double maxFormWidth = 420;

  /// Максимальна ширина основного контенту.
  static const double maxContentWidth = 960;

  /// Ширина, з якої вважаємо екран планшетним.
  static const double tabletBreakpoint = 600;
}
