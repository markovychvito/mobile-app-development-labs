/// Імітує мережеву затримку, щоб UI вже зараз показував індикатори
/// завантаження так, як це буде з REST API.
///
/// При [Duration.zero] таймер не створюється взагалі: тестам це
/// потрібно, бо у widget-тестах час «заморожений».
Future<void> simulateLatency(Duration latency) async {
  if (latency > Duration.zero) await Future<void>.delayed(latency);
}
