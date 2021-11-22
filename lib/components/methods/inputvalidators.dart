String? passwordValidator(String? password) {
  if ((password == null) && (password!.isEmpty)) {
    return "The password must not be empty";
  }
  if (password.length < 8) {
    return "Need more characters";
  }
  password = password.toLowerCase();
  if (password == "password") {
    return "Are you kidding?";
  }
  return null;
}

String? loginValidator(String? login) {
  if ((login == null) && (login!.isEmpty)) {
    return "The login must not be empty";
  }
  if (login.length < 3) {
    return "Need more characters";
  }
  if (int.tryParse(login) != null) {
    return "Need letters";
  }
  login = login.toLowerCase();
  if (["password", "login"].contains(login)) {
    return "Are you kidding?";
  }
  return null;
}

String? userfieldValidator(String? value) {
  if ((value == null) || (value.isEmpty)) {
    return "The value must not be empty";
  }
  if (int.tryParse(value) != null) {
    return "Need letters";
  }
  value = value.toLowerCase();
  if (["password", "login"].contains(value)) {
    return "Are you kidding?";
  }
  return null;
}
