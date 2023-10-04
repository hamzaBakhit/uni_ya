
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:uni_ya/constants/routes.dart';
import 'package:uni_ya/features/settings/logic/settings_bloc.dart';
import 'package:uni_ya/ui/widgets/backgruond.dart';

class AppIntro extends StatelessWidget {
  const AppIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
        return FutureBuilder(

          future: context.read<SettingsBloc>().getIsIntroFinished(),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return BackgroundWidget(child: SizedBox());
            }
            else if(snapshot.hasData&&snapshot.data!){
              WidgetsBinding.instance.addPostFrameCallback(
                  (_)=> Navigator.pushReplacementNamed(context, Routes.main)
              );
            }else{
              return const IntroScreen();
            }
            return BackgroundWidget(child: SizedBox());
          }
        );
      }),
    );
  }
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  LiquidController _controller = LiquidController();
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LiquidSwipe(
            liquidController: _controller,
            onPageChangeCallback: (index) {
              if (_index < 2) {
                setState(() => _index = index);
              }
            },
            enableSideReveal: true,
            ignoreUserGestureWhileAnimating: true,
            slideIconWidget:
            (_index < 2) ? Icon(Icons.arrow_forward_ios) : null,
            enableLoop: false,
            pages: [
              Container(
                color: Colors.green,
                padding: EdgeInsets.all(16),
                height: double.maxFinite,
                child: Column(
                  children: [
                    Expanded(
                        child: SvgPicture.asset(
                            'assets/illustrations/save_time.svg')),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.1),
                      child: Text(
                        'Save Your Time',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.orangeAccent,
                padding: EdgeInsets.all(16),
                height: double.maxFinite,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Column(
                    children: [
                      Expanded(
                          child: SvgPicture.asset(
                              'assets/illustrations/save_money.svg')),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom:
                            MediaQuery.of(context).size.height * 0.1),
                        child: Text(
                          'Save Your Money',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.redAccent,
                height: double.maxFinite,
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Column(
                    children: [
                      Expanded(
                          child: SvgPicture.asset(
                              'assets/illustrations/welcome.svg')),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom:
                            MediaQuery.of(context).size.height * 0.1),
                        child: Text(
                          'Welcome With Us',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: OutlinedButton(
              onPressed: () {
                context.read<SettingsBloc>().add(FinishIntro());
                Navigator.pushReplacementNamed(context, Routes.main);
              },
              child: Text(
                (_index < 2) ? "Skip" : "Finish",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        if (_index < 2)
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _index++;
                  });
                  _controller.animateToPage(page: _index);
                },
                child: Text(
                  "Next",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
      ],
    );
  }
}
