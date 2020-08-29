flutter pub run intl_utils:generate

$ cd C:\Users\H\AndroidStudioProjects\dmart
$ flutter build ios --release
$ mkdir -p build/ios/iphoneos/Payload
$ mv build/ios/iphoneos/Runner.app build/ios/iphoneos/Payload
$ cd build/ios/iphoneos
$ zip -r app.ipa Payload