class ProfissionalModel {
  final String uid;
  final String nome;
  final String email;
  final String ubs;
  final String perfilAcesso; // 'ACS' ou 'Equipe de saúde'
  final bool aceitouPrivacidade;

  const ProfissionalModel({
    required this.uid,
    required this.nome,
    required this.email,
    required this.ubs,
    required this.perfilAcesso,
    required this.aceitouPrivacidade,
  });

  // Converte o objeto para Map (útil para salvar no Firestore ou SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nome': nome,
      'email': email,
      'ubs': ubs,
      'perfilAcesso': perfilAcesso,
      'aceitouPrivacidade': aceitouPrivacidade,
    };
  }

  // Reconstrói o objeto a partir de um Map (útil ao ler do Firestore ou offline)
  factory ProfissionalModel.fromMap(Map<String, dynamic> map) {
    return ProfissionalModel(
      uid: map['uid'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      ubs: map['ubs'] ?? '',
      perfilAcesso: map['perfilAcesso'] ?? 'ACS',
      aceitouPrivacidade: map['aceitouPrivacidade'] ?? false,
    );
  }
}