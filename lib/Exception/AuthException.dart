class AuthException implements Exception {
  late String key;

  AuthException(this.key);

  final Map<String, String> errors = {
    'EMAIL_NOT_FOUND': "Email não encontrado",
    'INVALID_PASSWORD': 'Senha ou email invalidos',
    'USER_DISABLED': 'Úsuario desabilitado pelo administrador',
    'EMAIL_EXISTS': 'Email já cadastrado',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Bloqueado por muitas tentativas.Aguarde e tente mais tarde'
  };


  @override
  String toString() {
    return errors[key] ?? "Erro desconhecido";
  }
}
