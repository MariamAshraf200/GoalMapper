import 'package:flutter/material.dart';

class LoadingElevatedButton extends StatefulWidget {
  const LoadingElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.icon,
    this.tooltip,
    this.loadingTooltip,
    this.foregroundColor = Colors.white,
    this.backgroundColor,
    this.showLoading = false,
    this.isActive = true,
    this.verticalPadding = 16,
    this.borderRadius = 8.0, // Default border radius
  });

  final Future<void> Function()? onPressed;
  final String buttonText;
  final Widget? icon;
  final String? tooltip;
  final String? loadingTooltip;
  final Color foregroundColor;
  final Color? backgroundColor;
  final bool showLoading;
  final bool isActive;
  final double verticalPadding;
  final double borderRadius; // New parameter for border radius

  @override
  State<LoadingElevatedButton> createState() => _LoadingElevatedButtonState();
}

class _LoadingElevatedButtonState extends State<LoadingElevatedButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: _CustomElevatedIconButton(
        onPressed: widget.isActive
            ? () async {
          if (widget.showLoading) {
            setState(() {
              _isLoading = true;
            });
          }

          if (widget.onPressed != null) {
            await widget.onPressed!();
          }

          if (widget.showLoading) {
            setState(() {
              _isLoading = false;
            });
          }
        }
            : null,
        icon: widget.icon!,
        buttonText: widget.buttonText,
        tooltip: _isLoading
            ? widget.loadingTooltip ?? widget.tooltip
            : widget.tooltip,
        foregroundColor: widget.foregroundColor,
        backgroundColor: widget.backgroundColor,
        isLoading: _isLoading,
        key: widget.key,
        verticalPadding: widget.verticalPadding,
        borderRadius: widget.borderRadius, // Pass borderRadius
      ),
    );
  }
}

class _CustomElevatedIconButton extends StatelessWidget {
  const _CustomElevatedIconButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.icon,
    this.tooltip,
    this.foregroundColor = Colors.white,
    this.backgroundColor,
    this.isLoading = false,
    required this.verticalPadding,
    required this.borderRadius, // New parameter for border radius
  });

  final void Function()? onPressed;
  final String buttonText;
  final Widget icon;
  final String? tooltip;
  final Color foregroundColor;
  final Color? backgroundColor;
  final bool isLoading;
  final double verticalPadding;
  final double borderRadius; // New parameter for border radius

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? "",
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5.0),
        child: ElevatedButton.icon(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius), // Apply borderRadius
            ),
          ),
          icon: icon,
          label: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: isLoading ? Colors.transparent : null,
                ),
              ),
              if (isLoading)
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: isLoading ? Colors.grey : foregroundColor,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
