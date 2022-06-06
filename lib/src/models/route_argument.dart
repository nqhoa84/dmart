class RouteArgument {
  int? id;
  String? heroTag;
  dynamic param;

  RouteArgument({this.id, this.heroTag, this.param});

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}
