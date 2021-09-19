flutter pub run intl_utils:generate

cd C:\Users\H\AndroidStudioProjects\dmart
flutter build ios --release
mkdir -p build/ios/iphoneos/Payload
mv build/ios/iphoneos/Runner.app build/ios/iphoneos/Payload
cd build/ios/iphoneos
zip -r app.ipa Payload

git add .
git commit -m 'message'
git push


D:\Program Files\Android\Android Studio\jre\bin

C:\Users\H\AppData\Local\Android\sdk

GXrUUHmduNGmtfnLLx7v+pTCBGU=

cái dmart24.... thì vào thư mục /var/www/html/dev/dmart24,
còn cái dev2.... vào thư mục /var/www/html/phase3/dmart24

uuid iphone10: f6cc8a1342afb6948c1beadd2f735634da738c32
iphone lien:
Go to ~/Library/MobileDevice/Provisioning\ Profiles/ and delete all the provisioning profiles from there.
Go to Xcode > Preferences > Accounts and select the Apple ID.
Click Download Manual Profiles or Download All Profiles. And it will download all the provisioning profiles again.
