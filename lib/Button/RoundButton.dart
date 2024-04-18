import 'package:flutter/material.dart';
class RoundButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool loading;
  final String title;
  const RoundButton({super.key,required this.title,required this.onTap,this.loading=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: loading?CircularProgressIndicator(strokeWidth: 3,color: Colors.white,):Text(title,style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}
