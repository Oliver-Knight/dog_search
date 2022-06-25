String? emailValidator(String email) {
  if(email.isEmpty){
    return 'Email Required';
  }
  RegExp _emailRex = RegExp(r'^[a-zA-Z0-9!#$%&*+/=?^_`\{|}~-]+@gmail.com$');
  bool _match = _emailRex.hasMatch(email);
  if(_match == true){
    return null;
  }else{
    return "Invalid Email";
  }
}

String? strongPasswordChecker(String pwd){
  if (pwd.isEmpty) return 'Password Required';
  if (!pwd.contains(RegExp(r'[A-Z]+'))) return "Password must contain one Upper Case";
  if (!pwd.contains(RegExp(r'[a-z]+'))) return "Password must contain one Lower Case";
  if (!pwd.contains(RegExp(r'\d+'))) return "Password must contain at least one digit";
  if (!pwd.contains(RegExp(r'[!@#$%&]'))) return"Password must contain at least one special character";
  if (pwd.length < 10) return "Password length must be at least 10 char ";
  return null;
}
