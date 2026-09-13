import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/server_discovery.dart';

// ---------------------------------------------------------------------------
// ServerPicker — la liste des serveurs Tune vus sur le reseau.
//
// Un seul endroit dessine les quatre etats de la recherche, pour que l'ecran
// de connexion et l'ecran de reglages n'en donnent jamais deux versions
// differentes.
// ---------------------------------------------------------------------------

class ServerPicker extends StatefulWidget {
  /// Appele quand l'utilisateur touche un serveur de la liste.
  final ValueChanged<DiscoveredServer> onSelected;

  /// Serveur deja memorise, marque d'une coche dans la liste.
  final String? currentId;

  /// Vrai quand une connexion est en cours : la liste se fige le temps que
  /// l'appel aboutisse, pour qu'un double appui ne lance pas deux connexions.
  final bool busy;

  const ServerPicker({
    super.key,
    required this.onSelected,
    this.currentId,
    this.busy = false,
  });

  @override
  State<ServerPicker> createState() => _ServerPickerState();
}

class _ServerPickerState extends State<ServerPicker> {
  final ServerDiscovery _discovery = ServerDiscovery();

  @override
  void initState() {
    super.initState();
    _discovery.addListener(_onChanged);
    _discovery.start();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _discovery.removeListener(_onChanged);
    _discovery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppL.of(context);
    final servers = _discovery.servers;
    final state = _discovery.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(t.discoverySection,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            if (state == DiscoveryState.searching ||
                (state == DiscoveryState.found && servers.isNotEmpty))
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              IconButton(
                tooltip: t.discoveryRetry,
                icon: const Icon(Icons.refresh),
                onPressed: widget.busy ? null : _discovery.start,
              ),
          ],
        ),
        const SizedBox(height: 4),
        // ── 1. Je cherche ────────────────────────────────────────────
        if (state == DiscoveryState.searching && servers.isEmpty)
          _Hint(icon: Icons.wifi_find, title: t.discoverySearching)
        // ── 2. Autorisation manquante ────────────────────────────────
        else if (state == DiscoveryState.denied)
          _Problem(
            icon: Icons.lock_outline,
            title: t.discoveryDenied,
            body: _permissionHelp(t),
            actionLabel: t.discoveryRetry,
            onAction: widget.busy ? null : _discovery.start,
          )
        // ── 3. Rien trouve ───────────────────────────────────────────
        else if (servers.isEmpty)
          _Problem(
            icon: Icons.search_off,
            title: t.discoveryNone,
            // Sur iOS, un refus d'autorisation ne produit AUCUNE erreur : la
            // recherche est simplement muette. On ne peut pas distinguer les
            // deux causes, alors on donne les deux.
            body: ServerDiscovery.permissionSilentOnThisPlatform
                ? '${t.discoveryNoneHint}\n\n${t.discoveryLocalNetworkHint}'
                : t.discoveryNoneHint,
            actionLabel: t.discoveryRetry,
            onAction: widget.busy ? null : _discovery.start,
          )
        // ── 4. Des serveurs ──────────────────────────────────────────
        else ...[
          Text(t.discoveryFoundCount(servers.length),
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          for (final s in servers)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: const Icon(Icons.dns_outlined),
                title: Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  s.version.isEmpty
                      ? '${s.host}:${s.port}'
                      : '${s.host}:${s.port} · v${s.version}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: s.id == widget.currentId
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.chevron_right),
                onTap: widget.busy ? null : () => widget.onSelected(s),
              ),
            ),
        ],
      ],
    );
  }

  /// Le texte de reparation depend de la plateforme : iOS demande une
  /// autorisation « reseau local », Android refuse la decouverte pour d'autres
  /// raisons (Wi-Fi coupe, mode avion, multicast bloque par le routeur).
  String _permissionHelp(AppL t) {
    if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
      return t.discoveryDeniedHintIos;
    }
    return t.discoveryDeniedHintAndroid;
  }
}

class _Hint extends StatelessWidget {
  final IconData icon;
  final String title;
  const _Hint({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
      );
}

class _Problem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback? onAction;

  const _Problem({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: scheme.error),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title,
                      style: Theme.of(context).textTheme.titleSmall),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(body, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
