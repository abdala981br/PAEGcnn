import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// TODO: As configurações ainda precisam ser implementadas

class _SettingsPageState extends State<SettingsPage> {
  bool _feedbackTatil = true;
  bool _textToSpeech = false;
  double _tamanhoFonte = 2; // 0 a 4 (5 posições, começando no meio)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        elevation: 0,
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Botão VOLTAR
              _VoltarButton(onTap: () => Navigator.of(context).pop()),
              const SizedBox(height: 16),

              // Card com as opções
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _SettingSwitchTile(
                      title: 'Feedback tátil',
                      subtitle: 'Vibrar durante interações importantes.',
                      value: _feedbackTatil,
                      onChanged: (v) => setState(() => _feedbackTatil = v),
                    ),
                    const Divider(height: 32),
                    _SettingSwitchTile(
                      title: 'Text-to-speech',
                      subtitle: 'Ler textos da aplicação em voz alta.',
                      value: _textToSpeech,
                      onChanged: (v) => setState(() => _textToSpeech = v),
                    ),
                    const Divider(height: 32),
                    _FontSizeTile(
                      value: _tamanhoFonte,
                      onChanged: (v) => setState(() => _tamanhoFonte = v),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botão branco "VOLTAR" com seta, igual ao de CONFIGURAÇÕES na tela principal.
class _VoltarButton extends StatelessWidget {
  final VoidCallback onTap;

  const _VoltarButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.arrow_back, color: Colors.black87, size: 22),
              SizedBox(width: 10),
              Text(
                'VOLTAR',
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

/// Título + subtítulo + switch
class _SettingSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingSwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.55),
          ),
        ),
        const SizedBox(height: 16),
        Transform.scale(
          scale: 1.3,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFA9DDC0),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFF0B8C4),
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
      ],
    );
  }
}

/// Slider de tamanho de fonte
class _FontSizeTile extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _FontSizeTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Texto',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tamanho da fonte.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.55),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text(
              'A',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.black87,
                  inactiveTrackColor: Colors.black26,
                  thumbColor: Colors.black,
                  overlayColor: Colors.black12,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 9,
                  ),
                  trackHeight: 2,
                ),
                child: Slider(
                  value: value,
                  min: 0,
                  max: 4,
                  divisions: 4,
                  onChanged: onChanged,
                ),
              ),
            ),
            const Text(
              'A',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
