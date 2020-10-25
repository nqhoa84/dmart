import 'package:dmart/DmState.dart';
import 'package:dmart/utils.dart';

import 'media.dart';

class IdObj {
  int id = 0;

  IdObj({this.id = 0});

  bool get isValid {
    return id != null && id > 0;
  }

  @override
  bool operator ==(dynamic other) {
    return this.isValid && other.id == this.id;
  }

  @override
  int get hashCode => id.hashCode;
}

class IdNameObj extends IdObj {
  String nameEn, nameKh;

  String get name {
    if(DmState.isKhmer) {
      if(!DmUtils.isNullOrEmptyStr(this.nameKh)) {
        return nameKh;
      } else if(!DmUtils.isNullOrEmptyStr(this.nameEn)) {
        return nameEn;
      } else return '';
    } else {
      if(!DmUtils.isNullOrEmptyStr(this.nameEn)) {
        return nameEn;
      } else if(!DmUtils.isNullOrEmptyStr(this.nameKh)) {
        return nameKh;
      } else return '';
    }
  }

  set name (String value) {
    this.nameEn = DmUtils.isNotNullEmptyStr(value) ? value.trim() : '';
    this.nameKh = nameEn;
  }

  IdNameObj({id = -1, this.nameEn = '', this.nameKh = ''}) : super(id: id);

  @override
  bool get isValid {
    return id != null && id >= 0
        && name != null && name.length > 0;
  }

  String toStringIdName() {
    return '{id: $id, name: $name}';
  }

  @override
  String toString() {
    return 'IdNameObj {id: $id, name: $name}';
  }

}

class NameImageObj extends IdNameObj {
  Media image;

  NameImageObj({int id = -1, String nameEn = '', String nameKh = '', this.image}) : super(id: id, nameEn: nameEn, nameKh: nameKh);

  @override
  bool get isValid {
    return super.isValid
        && image != null && image.thumb != null && image.thumb.length > 10
    ;
  }

  @override
  String toString() {
    return '{id: $id, name: $name, image: $image}';
  }
}

