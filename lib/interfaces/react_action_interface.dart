abstract class ReactActionInterface {
  Future<void> onReact();
  Future<void> onUnReact();
  // Stream<int> getReactsCount();
  Future<int?> getReactsCount();

}
