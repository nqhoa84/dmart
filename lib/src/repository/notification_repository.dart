import 'dart:convert';
import 'dart:io';

import 'package:dmart/src/models/noti.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../DmState.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Noti?>> getNotifications() async {
  User _user = userRepo.currentUser.value;
  if (_user.isNotLogin) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}notifications?${_apiToken}search=notifiable_id:${_user.id}&searchFields=notifiable_id:=&orderBy=created_at&sortedBy=desc&limit=10';
  print('getNotifications $url');

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    print(data);
    return Noti.fromJSON(data);
  });
}

Future<Noti?> removeNotification(Noti notification) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Noti();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  var url = Uri.parse(
      '${GlobalConfiguration().getString('api_base_url')}notifications/${notification.id}?$_apiToken');
  print('removeNotification $url');
  try {
    final client = new http.Client();
    final response = await client.delete(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return Noti.fromJSON(json.decode(response.body)['data']);
  } catch (e, trace) {
    print('$e \n $trace');
    return Noti.fromJSON({});
  }
}

saveNoti(Noti noti) async {
  print('save noti to storage: $noti');
  if (DmState.notifications == null) {
    await loadNoties();
  }

  if (DmState.notifications!.isEmpty) {
    DmState.notifications!.add(noti);
  } else {
    DmState.notifications!.insert(0, noti);
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('dmNotifications', jsonEncode(DmState.notifications));
}

Future<bool> removeNoti(Noti noti) async {
  print('Remove noti: $noti');
  if (DmState.notifications != null) {
    var lne = DmState.notifications!.length;
    DmState.notifications!.remove(noti);
    print('---- pre len: $lne, now len ${DmState.notifications!.length}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('dmNotifications', jsonEncode(DmState.notifications));
    return true;
  }
  return false;
}

loadNoties() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String v = prefs.get('dmNotifications') as String;
  print('-------$v');
  DmState.notifications = [];
  if (v.isNotEmpty) {
    var nMap = jsonDecode(v);
    if (nMap != null && nMap is List) {
      nMap.forEach((element) {
        DmState.notifications!.add(Noti.fromJSON(element));
      });
    }
  }
  return DmState.notifications;
}
