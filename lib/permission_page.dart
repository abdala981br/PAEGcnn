import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; //Permissões do sistema
import 'main_page.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  bool _solicitando = false; //Flag de solicitação

  Future<void> _aceitar() async {
    setState(() => _solicitando = true);

    final status = await Permission.camera.request(); //Flag de permissão

    if (!mounted) return;
    setState(() => _solicitando = false);

    if (status.isGranted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()), //Puxa nova tela
      );
    } else if (status.isPermanentlyDenied) {
      // O usuário negou permanentemente: só dá pra reverter nas configurações do sistema.
      _mostrarAvisoConfiguracoes();
    } else {
      // Negado, mas ainda pode perguntar de novo.
      _mostrarAvisoNegado();
    }
  }

  void _mostrarAvisoNegado() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'É preciso permitir o uso da câmera para continuar.',
        ),
      ),
    );
  }

  void _mostrarAvisoConfiguracoes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissão necessária'),
        content: const Text(
          'A câmera foi bloqueada. Ative a permissão nas configurações '
          'do sistema para continuar usando o aplicativo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), //Fecha a janela
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); //Fecha a janela
              openAppSettings(); //Abre configurações
            },
            child: const Text('ABRIR CONFIGURAÇÕES'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/background_initial_page.png',
              fit: BoxFit.cover,
            ),
          ),
          // Preto transparente para aumentar contraste
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.55)),
          ),
          // Card central com o pedido de permissão
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _PermissaoCard(
                  loading: _solicitando,
                  onAceitar: _aceitar,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cartão branco central
class _PermissaoCard extends StatelessWidget {
  final bool loading; //Botão de carregamento
  final VoidCallback onAceitar; //Função executada qundo o botão é pressionado

  const _PermissaoCard({required this.loading, required this.onAceitar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.photo_camera_outlined,
            size: 90,
            color: Colors.black87,
          ),
          const SizedBox(height: 20),
          const Text(
            'USO DA CÂMERA',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'O aplicativo precisa da sua permissão para fazer o uso '
            'da câmera',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.75),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 28),
          _AceitarButton(loading: loading, onTap: onAceitar),
        ],
      ),
    );
  }
}

/// Botão verde "ACEITAR"
class _AceitarButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const _AceitarButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF7FCCA0),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: loading ? null : onTap, // Null enquanto carrega, caso contrário executa _aceitar
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check, color: Colors.black87, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'ACEITAR',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

