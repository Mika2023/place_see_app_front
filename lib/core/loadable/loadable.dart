import 'package:place_see_app/core/loadable/load_status_enum.dart';

class Loadable<T> {
  final LoadStatusEnum loadStatus;
  final T data;

  const Loadable.loading(this.data) : loadStatus = LoadStatusEnum.loading;
  const Loadable.success(this.data) : loadStatus = LoadStatusEnum.success;
  const Loadable.error(this.data) : loadStatus = LoadStatusEnum.error;
}