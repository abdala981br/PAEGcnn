import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'settings_page.dart';

late List<CameraDescription> cameras; // Cameras disponíveis no dispositivo

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CameraController? _cameraController; // Objeto que controla a câmera
  bool _isCameraInitialized = false;

  // Estado do "caminho": true = livre, false = obstáculo detectado.
  // Valor de exemplo ainda, é preciso fazer a conexão com o modelo
  bool _caminhoLivre = true;

  @override
  void initState() {
    super.initState();
    _initCamera(); // Metodo inicia automaticamente com a tela e chama a câmera
  }

  Future<void> _initCamera() async {
    if (cameras.isEmpty) return; //Verifica se existem câmeras

    _cameraController = CameraController(
      cameras.first, // Usa a primeira câmera da lista, geralmente câmera traseira
      ResolutionPreset.medium, // Qualidade do preview
      enableAudio: false, // Não captura audio
    );

    try {
      await _cameraController!.initialize(); // Abre a câmera
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint('Erro ao inicializar câmera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose(); // Libera a câmera para não ocupar memória
    super.dispose();
  }

  void _abrirConfiguracoes() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  void _ativarAudio() {
    // TODO: disparar feedback sonoro / TTS
    debugPrint('Feedback de áudio ativado');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFE3CE), // TODO: verde claro de fundo que deve mudar com o _caminhoLivre
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Linha superior: botão de Configurações + botão de áudio
              Row(
                children: [
                  Expanded(
                    child: _ConfiguracoesButton(onTap: _abrirConfiguracoes),
                  ),
                  const SizedBox(width: 12),
                  _AudioButton(onTap: _ativarAudio),
                ],
              ),
              const SizedBox(height: 16),

              // Painel de notificações e feedback
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'Painel de notificações e de feedback',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Preview da câmera (imagem central)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    color: Colors.black12,
                    child: _isCameraInitialized //Verifica se a câmera já inicializou
                        ? FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _cameraController!.value.previewSize!.height,
                              height: _cameraController!.value.previewSize!.width,
                              child: CameraPreview(_cameraController!),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Status do caminho (CAMINHO LIVRE / OBSTÁCULO)
              Text(
                _caminhoLivre ? 'CAMINHO LIVRE' : 'OBSTÁCULO À FRENTE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: _caminhoLivre ? Colors.black87 : Colors.red[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botão verde "CONFIGURAÇÕES" com ícone de engrenagem.
class _ConfiguracoesButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ConfiguracoesButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF5EB891),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.settings, color: Colors.white, size: 26),
              SizedBox(width: 10),
              Text(
                'CONFIGURAÇÕES',
                style: TextStyle(
                  color: Colors.white,
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

/// Botão quadrado branco com ícone de áudio.
class _AudioButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AudioButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          child: const Icon(
            Icons.volume_up,
            color: Color(0xFF5EB891),
            size: 30,
          ),
        ),
      ),
    );
  }
}
