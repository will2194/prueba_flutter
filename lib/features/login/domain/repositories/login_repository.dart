abstract class LoginRepository {
  Future<String> login({required String email, required String password});
}
