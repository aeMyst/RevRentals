import 'package:flutter/cupertino.dart';

class MySlidingButton extends StatefulWidget{
  //final Function()? onTap;

  const MySlidingButton({Key? key}) : super(key: key);

  //const MySlidingButton({super.key, required this.onTap });


  @override
  State<MySlidingButton> createState() => _MySlidingButtonState();
  
}

class _MySlidingButtonState extends State<MySlidingButton> {
  int? _sliding = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      // handle tap event
      },
      child: Container(
        //padding: const EdgeInsets.all(5),
        //margin: const EdgeInsets.symmetric(horizontal: 25),

        child: Center(
          child: CupertinoSlidingSegmentedControl(
            children: const {
              0: Text(
                'Log In',
                style: TextStyle(fontSize: 16)),
              1: Text(
                'Sign Up',
                style: TextStyle(fontSize: 16)),
            },
            groupValue: _sliding, 
            onValueChanged: (int? newValue) {
              setState(() {
                _sliding = newValue;
              });
            },
          ),
        ),
      ),
    );
  }
}