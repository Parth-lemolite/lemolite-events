import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceTypeSelector extends StatefulWidget {
  const ServiceTypeSelector({super.key});

  @override
  _ServiceTypeSelectorState createState() => _ServiceTypeSelectorState();
}

class _ServiceTypeSelectorState extends State<ServiceTypeSelector> {
  String? selectedService;

  final List<Map<String, dynamic>> serviceTypes = [
    {
      'title': 'Implementation',
      'icon': Icons.settings_outlined,
      'color': const Color(0xFF2EC4F3),
    },
    {
      'title': 'Consulting',
      'icon': Icons.lightbulb_outline,
      'color': const Color(0xFFBFD633),
    },
    {
      'title': 'Training',
      'icon': Icons.school_outlined,
      'color': const Color(0xFF2EC4B6),
    },
    {
      'title': 'Support',
      'icon': Icons.headset_mic_outlined,
      'color': const Color(0xFF2EC4F3),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Service Type', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
          serviceTypes.map((service) {
            final bool isSelected = selectedService == service['title'];
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => selectedService = service['title']);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                  isSelected
                      ? service['color'].withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                    isSelected
                        ? service['color']
                        : const Color(0xFFEAEEF5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      service['icon'],
                      color:
                      isSelected
                          ? service['color']
                          : const Color(0xFF404B69),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      service['title'],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                        isSelected
                            ? service['color']
                            : const Color(0xFF404B69),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}