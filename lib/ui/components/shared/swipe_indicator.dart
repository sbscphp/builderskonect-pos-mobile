// import 'package:bottle_king_mobile/core/core.dart';

// class SwipeIndicator extends StatelessWidget {
//   final bool isActive;
//   final Color activeColor;

//   const SwipeIndicator({
//     super.key,
//     required this.isActive,
//     this.activeColor = AppColors.black,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       height: Sizer.height(4),
//       width: Sizer.width(isActive ? 25 : 10),
//       decoration: BoxDecoration(
//         color: isActive ? activeColor : AppColors.black.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(Sizer.radius(6)),
//         shape: BoxShape.rectangle,
//       ),
//     );
//   }
// }
