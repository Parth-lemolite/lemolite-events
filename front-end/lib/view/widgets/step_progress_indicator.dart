import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final bool isActive = index == currentStep;
        final bool isCompleted = index < currentStep;
        final Color circleColor =
        isCompleted
            ? const Color(0xFF2EC4F3)
            : isActive
            ? const Color(0xFFBFD633)
            : const Color(0xFFEAEEF5);
        final Color textColor =
        isCompleted || isActive
            ? const Color(0xFF0F1C35)
            : const Color(0xFF8E99B7);

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Step circle and connecting line
              Row(
                children: [
                  // Left connecting line (except for first step)
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color:
                        index <= currentStep
                            ? const Color(0xFF2EC4F3)
                            : const Color(0xFFEAEEF5),
                      ),
                    ),
                  // Step circle
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child:
                      isCompleted
                          ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                          : Text(
                        '${index + 1}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:
                          isActive
                              ? Colors.white
                              : const Color(0xFF8E99B7),
                        ),
                      ),
                    ),
                  ),
                  // Right connecting line (except for last step)
                  if (index < totalSteps - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color:
                        index < currentStep
                            ? const Color(0xFF2EC4F3)
                            : const Color(0xFFEAEEF5),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Step label
              Text(
                labels[index],
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }),
    );
  }
}