part of '../premium_screen.dart';

class _DataError extends StatelessWidget {
  final VoidCallback onTap;

  const _DataError({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                'Error occured.',
                style: h1Style.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: Text(
                'Please check your internet connection and try again later.',
                style: h2SbStyle.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ButtonApp(
              text: 'Try again',
              color: accentColor,
              onTap: onTap,
            )
          ],
        ),
      ),
    );
  }
}
