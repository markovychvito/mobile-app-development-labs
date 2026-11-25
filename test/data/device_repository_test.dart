import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/data/shared_prefs_device_repository.dart';
import 'package:my_project/domain/exceptions/app_exception.dart';
import 'package:my_project/domain/models/device.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const owner = 'andrii@homelab.ua';
  late SharedPreferences prefs;
  late SharedPrefsDeviceRepository repository;

  Future<Device> addLamp() {
    return repository.add(
      owner,
      name: 'mini-pc',
      location: 'Стійка',
      type: DeviceType.raspberryPi,
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repository = SharedPrefsDeviceRepository(prefs, latency: Duration.zero);
  });

  test('create + read', () async {
    final node = await addLamp();
    expect(node.isOn, isFalse);
    expect(await repository.fetchAll(owner), hasLength(1));
  });

  test('ids are unique for quick consecutive adds', () async {
    final ids = {for (var i = 0; i < 20; i++) (await addLamp()).id};
    expect(ids, hasLength(20));
  });

  test('update changes only the edited device', () async {
    final node = await addLamp();
    final other = await addLamp();
    await repository.update(
      owner,
      node.copyWith(name: 'pi-node-01', isOn: true),
    );

    final devices = await repository.fetchAll(owner);
    final edited = devices.firstWhere((device) => device.id == node.id);
    final untouched = devices.firstWhere((device) => device.id == other.id);
    expect(edited.name, 'pi-node-01');
    expect(edited.isOn, isTrue);
    expect(untouched.name, 'mini-pc');
  });

  test('delete removes the device', () async {
    final node = await addLamp();
    await repository.delete(owner, node.id);
    expect(await repository.fetchAll(owner), isEmpty);
  });

  test('users do not see each other devices', () async {
    await addLamp();
    expect(await repository.fetchAll('olena@mail.com'), isEmpty);
  });

  test('data survives an app restart (new repository instance)', () async {
    await addLamp();
    final restarted = SharedPrefsDeviceRepository(
      prefs,
      latency: Duration.zero,
    );
    expect(await restarted.fetchAll(owner), hasLength(1));
  });

  test('invalid or unknown devices are rejected', () async {
    expect(
      () => repository.add(
        owner,
        name: '',
        location: 'Стійка',
        type: DeviceType.raspberryPi,
      ),
      throwsA(isA<AppException>()),
    );
    const ghost = Device(
      id: 'ghost',
      name: 'Привид',
      location: 'Комора',
      type: DeviceType.sensor,
      isOn: false,
    );
    expect(() => repository.update(owner, ghost), throwsA(isA<AppException>()));
  });
}
