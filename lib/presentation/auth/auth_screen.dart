import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/profissional_model.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isCadastro = false;
  bool _obscurePassword = true;

  // Controllers de Login e Cadastro
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _ubsController = TextEditingController();

  String _perfilAcesso = 'ACS';
  bool _aceitouPrivacidade = false;
  ProfissionalModel? _profissionalLogado;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _ubsController.dispose();
    super.dispose();
  }

  void _submeter() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe seu e-mail profissional.')),
      );
      return;
    }

    if (_isCadastro) {
      if (!_aceitouPrivacidade) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aceite a Política de Privacidade para continuar.'),
          ),
        );
        return;
      }
      setState(() {
        _profissionalLogado = ProfissionalModel(
          uid: 'local_${DateTime.now().millisecondsSinceEpoch}',
          nome: _nomeController.text.trim().isEmpty
              ? 'Mariana Souza'
              : _nomeController.text.trim(),
          email: email,
          ubs: _ubsController.text.trim().isEmpty
              ? 'UBS Santa Maria'
              : _ubsController.text.trim(),
          perfilAcesso: _perfilAcesso,
          aceitouPrivacidade: true,
        );
      });
    } else {
      setState(() {
        _profissionalLogado = ProfissionalModel(
          uid: 'local_user',
          nome: 'Mariana Souza',
          email: email,
          ubs: 'UBS Santa Maria',
          perfilAcesso: 'ACS',
          aceitouPrivacidade: true,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profissionalLogado != null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, ${_profissionalLogado!.nome}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_profissionalLogado!.perfilAcesso} • ${_profissionalLogado!.ubs}',
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _profissionalLogado = null);
                  },
                  child: const Text('SAIR DA CONTA'),
                ),
                const SizedBox(height: 12),
                _buildOfflineStatusBar(),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '"A régua digital que mede o futuro do coração do paciente."',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isCadastro) ...[
                const Text(
                  'Criar conta',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Cadastro do profissional de saúde.',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do profissional',
                    hintText: 'Mariana Souza',
                  ),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'mariana.acs@email.com',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _senhaController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  helperText: _isCadastro ? 'Mínimo de 8 caracteres.' : null,
                  suffixIcon: TextButton(
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    child: Text(_obscurePassword ? 'Mostrar' : 'Ocultar'),
                  ),
                ),
              ),
              if (_isCadastro) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _ubsController,
                  decoration: const InputDecoration(
                    labelText: 'Unidade de saúde (UBS)',
                    hintText: 'UBS Santa Maria',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _perfilAcesso,
                  decoration: const InputDecoration(
                    labelText: 'Perfil de acesso',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'ACS', child: Text('ACS')),
                    DropdownMenuItem(
                      value: 'Equipe de saúde',
                      child: Text('Equipe de saúde'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _perfilAcesso = val);
                  },
                ),
                const SizedBox(height: 6),
                const Text(
                  'O ACS vê só as próprias avaliações. A equipe de saúde também vê os relatórios agregados.',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _aceitouPrivacidade,
                  activeColor: AppTheme.primaryGreen,
                  title: const Text(
                    'Li e aceito a Política de Privacidade',
                    style: TextStyle(fontSize: 13),
                  ),
                  onChanged: (val) {
                    setState(() => _aceitouPrivacidade = val ?? false);
                  },
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submeter,
                child: Text(_isCadastro ? 'CRIAR CONTA' : 'ENTRAR'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() => _isCadastro = !_isCadastro);
                },
                child: Text(
                  _isCadastro
                      ? 'Já tem conta? Entrar'
                      : 'Não tem conta? Criar conta',
                ),
              ),
              if (!_isCadastro) ...[
                const SizedBox(height: 8),
                const Text(
                  'O login é necessário só no primeiro acesso. Depois disso, o app funciona mesmo sem internet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
              const SizedBox(height: 16),
              _buildOfflineStatusBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        Icon(Icons.favorite, color: AppTheme.dangerRed, size: 26),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CardioRisco',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'AVALIAÇÃO CARDIOVASCULAR',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.1,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOfflineStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.circle, size: 8, color: AppTheme.warningYellow),
          SizedBox(width: 8),
          Text(
            'Offline — dados salvos no dispositivo',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}