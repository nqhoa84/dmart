import 'media.dart';

class IdObj {
  int id;

  IdObj({this.id = 0});

  bool get isValid {
    return id != null && id > 0;
  }

  @override
  bool operator ==(dynamic other) {
    return this.isValid && other.id == this.id;

//    if(this.id >= 0)  {
//      return this.id >= 0 && other.id == this.id;
//    } else {
//      return this. == other;
//    }
  }
}

class IdNameObj extends IdObj {
  String name;

  IdNameObj({id = -1, this.name = ''}) : super(id: id);

  @override
  bool get isValid {
    return id != null && id >= 0
        && name != null && name.length > 0;
  }

  String toStringIdName() {
    return '{id: $id, name: $name}';
  }
}

class NameImageObj extends IdNameObj {
  Media image;

  NameImageObj({int id = -1, String name = '', this.image}) : super(id: id, name: name);

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

