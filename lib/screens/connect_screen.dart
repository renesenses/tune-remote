import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../services/server_discovery.dart';
import '../state/app_state.dart';
import '../widgets/responsive.dart';
import '../widgets/server_picker.dart';

// ---------------------------------------------------------------------------
// ConnectScreen — le premier ecran quand aucun serveur n'est memorise.
//
// Il cherche AVANT de demander : la saisie d'adresse existe toujours, mais en
// repli, replie, pas comme premiere chose que l'utilisateur voit.
// ---------------------------------------------------------------------------

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final _hostCtrl = TextEditingController();
  final _portCtrl =
      TextEditingController(text: AppState.defaultPort.toString());
  bool _manual = false;
  bool _busy = false;

  @override
  void dispose() {
    _hostCtrl.dispose();
    _portCtrl.dispose();
    super.dispose();
  }

  Future<void> _connectTo(DiscoveredServer s) async {
    setState(() => _busy = true);
    try {
      await context.read<AppState>().connectToDiscovered(s);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _connectManual() async {
    if (_hostCtrl.text.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    if (_portCtrl.text.trim().isEmpty) {
      _portCtrl.text = AppState.defaultPort.toString();
    }
    setState(() => _busy = true);
    try {
      await context.read<AppState>().setServer(_hostCtrl.text, _portCtrl.text);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppL.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.discoveryTitle)),
      body: MaxWidth(
        maxWidth: 620,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ServerPicker(
              onSelected: _connectTo,
              busy: _busy,
            ),
            if (_busy) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            const Divider(height: 40),
            // ── Repli manuel : jamais supprime ──────────────────────
            //
            // Un serveur derriere un VPN ou sur un autre sous-reseau ne sera
            // JAMAIS decouvert : le mDNS ne franchit pas le routeur.
            if (!_manual)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => _manual = true),
                  icon: const Icon(Icons.keyboard),
                  label: Text(t.discoveryManualToggle),
                ),
              )
            else ...[
              Text(t.discoveryManualToggle,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(t.discoveryManualIntro,
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _hostCtrl,
                      decoration: InputDecoration(
                        labelText: t.host,
                        hintText: '192.168.1.18',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.dns),
                      ),
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      onSubmitted: (_) => _connectManual(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 96,
                    child: TextField(
                      controller: _portCtrl,
                      decoration: InputDecoration(
                        labelText: t.port,
                        hintText: '8888',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _connectManual(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: _busy ? null : _connectManual,
                  icon: const Icon(Icons.link),
                  label: Text(t.connect),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
