import 'package:dmart/DmState.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/repository/settings_repository.dart';
import 'package:flutter/material.dart';
import 'SearchBar.dart';

class SearchSoundBar extends StatefulWidget {
  @override
  _SearchSoundBarState createState() => _SearchSoundBarState();
}

class _SearchSoundBarState extends State<SearchSoundBar> {

  @override
  Widget build(BuildContext context) {
    IconThemeData it = IconThemeData(color: DmConst.accentColor);
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      leading: Container(
        padding: EdgeInsets.all(12),
        child: InkWell(
            onTap: onTapSoundIcon,
            child: Image.asset( DmState.isRadioOn ? 'assets/img/Sound_on.png' : 'assets/img/Sound_off.png', fit: BoxFit.scaleDown)),
      ),
      actions: [SizedBox()],
      title: Padding(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: SearchBar(),
      ),
      // centerTitle: true,
      pinned: false,
      //this property make to widget pin to screen
      floating: true,
      iconTheme: it,
    );
  }

  Future<void> onTapSoundIcon() async {
    setState(() {
      DmState.setRadioStatus(on: !DmState.isRadioOn);
    });
    await setRadioSetting( isSoundOn: DmState.isRadioOn);
  }
}


//
// class SearchSoundBar extends StatelessWidget {
//   const SearchSoundBar({
//     Key key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     IconThemeData it = IconThemeData(color: DmConst.accentColor);
//     return SliverAppBar(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       automaticallyImplyLeading: false,
//       leading: InkWell(
//           onTap: onTapSoundIcon,
//           child: Image.asset(DmState.isSoundOn ? 'assets/img/Sound_on.png' : 'assets/img/Sound_off.png', fit: BoxFit.scaleDown)),
//       actions: [SizedBox()],
//       title: Padding(
//         // padding: const EdgeInsets.symmetric(horizontal: 10),
//         padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//         child: SearchBar(),
//       ),
//       // centerTitle: true,
//       pinned: false,
//       //this property make to widget pin to screen
//       floating: true,
//       iconTheme: it,
//     );
//   }
// }
//

