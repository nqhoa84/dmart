
/// Parse a object to double. if error return the [errorValue] data.
double toDouble(var obj, {double errorValue = -1}) {
  if(obj == null)
    return errorValue;
  if(obj is num) return obj.toDouble();
  double v = double.tryParse(obj.toString());
  return v??errorValue;
}

/// Parse a object to int. if error return the [errorValue] data.
int toInt(var obj, {int errorValue = -1}) {
  if(obj == null)
    return errorValue;
  if(obj is num) return obj.toInt();

  int v = int.tryParse(obj.toString());
  return v??errorValue;
}

/// Parse a object to String. if error return the [errorValue] data.
String toStringVal(var obj, {String errorValue = ''}) {
  if(obj == null)
    return errorValue;
  return obj.toString();
}
