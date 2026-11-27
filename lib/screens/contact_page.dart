import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/illustrations.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_button.dart';
import 'package:myportofolio_mobile/widgets/page_parts.dart';
import 'package:myportofolio_mobile/widgets/summary_dialog.dart';

/// Halaman "Contact Me": daftar kontak (Email, LinkedIn, GitHub)
/// dan formulir "Send Me a Message" (nama, email, pesan maks. 500 karakter).
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  static const int _nameMaxLength = 100;
  static const int _messageMaxLength = 500;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// Validasi dulu; dialog ringkasan hanya muncul jika semua isian valid.
  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    showSummaryDialog(
      context,
      title: 'Message Sent!',
      items: [
        SummaryItem(
          label: 'Nama Lengkap',
          value: _nameController.text.trim(),
          icon: Icons.person_outline,
        ),
        SummaryItem(
          label: 'Email',
          value: _emailController.text.trim(),
          icon: Icons.mail_outline,
        ),
        SummaryItem(
          label: 'Pesan',
          value: _messageController.text.trim(),
          icon: Icons.chat_bubble_outline,
        ),
      ],
      onClosed: _resetForm,
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: oceanAppBar(
        title: 'My Portfolio',
        centerTitle: true,
        actions: const [OceanAvatarAction()],
      ),
      drawer: const LeftDrawer(selected: DrawerDestination.contact),
      body: OceanBackground(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, top + 10, 16, 28),
                child: Column(
                  children: [
                    const HeroBanner(
                      mascotAsset: 'assets/images/nailong_swim.gif',
                      mascotWidth: 140,
                      title: 'Contact Me',
                      subtitle:
                          'Mari terhubung dan berkolaborasi! '
                          'Saya senang berdiskusi dengan Anda. 💙',
                      decoration: SeahorseMascot(height: 58),
                    ),
                    const SizedBox(height: 14),
                    const _ContactLinks(),
                    const SizedBox(height: 14),
                    _buildMessageCard(),
                    const SizedBox(height: 16),
                    const CrabMascot(width: 96),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageCard() {
    return GlassPanel(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.chat, color: Color(0xFF3B82F6), size: 28),
                SizedBox(width: 10),
                Text(
                  'Send Me a Message',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: OceanColors.navy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('contactNameField'),
              controller: _nameController,
              maxLength: _nameMaxLength,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: oceanInputDecoration(
                hint: 'Nama lengkap *',
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) => FormValidators.requiredText(
                value,
                fieldName: 'Nama lengkap',
                maxLength: _nameMaxLength,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const Key('contactEmailField'),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: oceanInputDecoration(
                hint: 'Email *',
                prefixIcon: const Icon(Icons.mail_outline),
              ),
              validator: FormValidators.requiredEmail,
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const Key('contactMessageField'),
              controller: _messageController,
              maxLength: _messageMaxLength,
              minLines: 4,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              decoration: oceanInputDecoration(
                hint: 'Tulis pesan Anda...',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Icon(Icons.chat_bubble_outline),
                ),
                showCounter: true,
              ),
              validator: (value) => FormValidators.requiredText(
                value,
                fieldName: 'Pesan',
                maxLength: _messageMaxLength,
              ),
            ),
            const SizedBox(height: 12),
            OceanButton(
              label: 'Kirim Pesan',
              icon: Icons.send,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Data satu baris kontak.
class _ContactItem {
  const _ContactItem({
    required this.name,
    required this.value,
    required this.icon,
    required this.color,
    this.badge,
  });

  final String name;
  final String value;
  final IconData icon;
  final Color color;
  final String? badge;
}

class _ContactLinks extends StatelessWidget {
  const _ContactLinks();

  static const List<_ContactItem> _items = [
    _ContactItem(
      name: 'Email',
      value: 'alisa.selvia@ui.ac.id',
      icon: Icons.mail,
      color: Color(0xFF2F80ED),
    ),
    _ContactItem(
      name: 'LinkedIn',
      value: 'linkedin.com/in/alisaselviasaharani',
      icon: Icons.work,
      color: Color(0xFF0A66C2),
      badge: 'in',
    ),
    _ContactItem(
      name: 'GitHub',
      value: 'github.com/alisaselviasaharani',
      icon: Icons.pets,
      color: Color(0xFF24292F),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [for (final item in _items) _ContactRow(item: item)],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.item});

  final _ContactItem item;

  @override
  Widget build(BuildContext context) {
    final badge = item.badge;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCFEAF5)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: item.value));
            showInfoSnackBar(context, '${item.name} disalin: ${item.value}');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: badge != null
                      ? Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      : Icon(item.icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: OceanColors.navy,
                        ),
                      ),
                      Text(
                        item.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: OceanColors.deep,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.open_in_new,
                  color: OceanColors.deep,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
