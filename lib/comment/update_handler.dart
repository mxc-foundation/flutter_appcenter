abstract class UpdateHandler {
  Future<void> handle({void Function(int, int) onReceiveProgress});
}
