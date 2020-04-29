import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  TextStyle textStyle1 = TextStyle(fontSize: 22);
  //
  String question = '';
  List<int> optionList = List();
  int numOfCorrectAns = 0;
  int totalQuesAsk = 0;
  bool isGameOver = false;
  //
  int correctAns;
  String res = '';
  //countdown
  Timer _timer;
  int _start = 10;

  @override
  void initState() {
    generateQuestion();
    startCountDown();
    super.initState();
  }

  generateQuestion() {
    Random random = Random();
    int first = random.nextInt(10);
    int second = random.nextInt(10);
    question = '$first / $second';
    correctAns = first + second;
    int correctAnsLocation = random.nextInt(4);
    int incorrectAns;

    //first clear optionList
    optionList.clear();
    for (int i = 0; i < 4; i++) {
      if (i == correctAnsLocation) optionList.add(correctAns);

      incorrectAns = random.nextInt(20);
      while (correctAns == incorrectAns) {
        incorrectAns = random.nextInt(20);
      }

      optionList.add(incorrectAns);
    }
  }

  startCountDown() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start < 1) {
          timer.cancel();
          //gameover
          gameOver();
        } else {
          _start = _start - 1;
        }
      });
    });
  }

  gameOver() {
    isGameOver = true;
    res = '$numOfCorrectAns / $totalQuesAsk';
    //also disable optionalAnswer selection
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15.0, top: 25, bottom: 25),
        child: Container(
          child: Column(
            children: [
              topRow(),
              questionWidget(),
              optionalAnswers(),
              result(),
              playAgain()
            ],
          ),
        ),
      ),
    ));
  }

  topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //
        Container(
            color: Color.fromARGB(255, 159, 102, 123),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _start.toString(),
                style: textStyle1,
              ),
            )),
        //
        Container(
            color: Color.fromARGB(255, 159, 102, 123),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$numOfCorrectAns/$totalQuesAsk',
                  style: textStyle1,
                ))),
      ],
    );
  }

  questionWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Center(
          child: Container(
        color: Color.fromARGB(255, 159, 102, 123),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            question,
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
        ),
      )),
    );
  }

  optionalAnswers() {
    return SizedBox(
        height: 320,
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(4, (index) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  if (!isGameOver) {
                    print(optionList[index].toString());
                    checkAnswer(index);
                  }
                },
                child: Container(
                    color: Color.fromARGB(255, 214, 215, 215),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 45, bottom: 45, left: 55, right: 55),
                      child: Text(
                        optionList[index].toString(),
                        style: textStyle1,
                      ),
                    )),
              ),
            );
          }),
        ));
  }

  result() {
    return Center(
      child: Text(
        res,
        style: textStyle1,
      ),
    );
  }

  playAgain() {
    return Visibility(
        visible: isGameOver,
        child: RaisedButton(
          onPressed: () {
            print('play again');
            startGame();
          },
          color: Color.fromARGB(255, 214, 215, 215),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'PLAY AGAIN',
              style: textStyle1,
            ),
          ),
        ));
  }

  checkAnswer(int index) {
    // print(correctAns);
    setState(() {
      if (optionList[index] == correctAns) {
        res = 'Correct';
        numOfCorrectAns++;
      } else {
        res = 'Incorrect';
      }

      totalQuesAsk++;
      generateQuestion();
    });
  }

  startGame() {
    setState(() {
      numOfCorrectAns = 0;
      totalQuesAsk = 0;
      isGameOver = false;
      res = '';
      generateQuestion();
      _start = 10;
      startCountDown();
    });
  }
}
