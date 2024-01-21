class Validator {
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est vide.';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est vide.';
    }
    if (value.length < 8) {
      return "Votre mot de passe doit contenir minimum 8 charactères.";
    }

    if (value.length > 64) {
      return "Votre mot de passe doit contenir maximum 64 charactères.";
    }
    return null;
  }

  static String? isNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est vide.';
    }
    return null;
  }
}
