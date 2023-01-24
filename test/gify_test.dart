// TODO: Write test code

// import 'package:flutter_test/flutter_test.dart';
// import 'package:gify/gify.dart';
// import 'package:gify/gify_platform_interface.dart';
// import 'package:gify/gify_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockGifyPlatform with MockPlatformInterfaceMixin implements GifyPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final GifyPlatform initialPlatform = GifyPlatform.instance;
//
//   test('$MethodChannelGify is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelGify>());
//   });
//
//   test('getPlatformVersion', () async {
//     Gify gifyPlugin = Gify();
//     MockGifyPlatform fakePlatform = MockGifyPlatform();
//     GifyPlatform.instance = fakePlatform;
//
//     expect(await gifyPlugin.getPlatformVersion(), '42');
//   });
// }
