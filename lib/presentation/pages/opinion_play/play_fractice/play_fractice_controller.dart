import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:template/presentation/pages/opinion_play/play_fractice/model/fraction_model.dart';
import 'package:template/presentation/widgets/controller/sound_controller.dart';

import '../../../../config/routes/route_path/main_routh.dart';
import '../../../../core/shared_pref/constants/enum_helper.dart';

class PlayFracticeController extends GetxController {
  RxString currentQuestion = "5 + 8 = ?".obs;
  Fraction correctAnswer = Fraction(1, 1);
  RxList<Fraction> currentOptions =
      List<Fraction>.generate(4, (index) => Fraction(0, 0)).obs;
  bool isCorrect = true;
  RxMap<int, Color> answerColors = <int, Color>{}.obs;
  RxInt count = 1.obs;
  RxInt countWrong = 0.obs;
  RxInt countCorrect = 0.obs;
  RxInt countSkip = 0.obs;
  Map<String, dynamic> arguments = {
    'level': "Easy",
    'route': "/addition",
    'title': "Addition",
  };
  MATHLEVEL level = MATHLEVEL.EASY;
  String route = "/addition";
  String title = "Addition";
  bool isSkip = false;
  int rangeRandom = 10;
  RxString textLevel = ''.obs;
  Rx<Fraction> operand1 = Fraction(1, 1).obs;
  Rx<Fraction> operand2 = Fraction(1, 1).obs;
  Fraction fraction = Fraction(1, 1);
  String routeOperation = '';
  int levelAdd = 1;
  @override
  void onInit() {
    currentQuestion = "5 + 8 = ?".obs;
    correctAnswer = Fraction(1, 1);
    currentOptions = List<Fraction>.generate(4, (index) => Fraction(0, 0)).obs;
    isCorrect = true;
    answerColors = <int, Color>{}.obs;
    count = 1.obs;
    countWrong = 0.obs;
    countCorrect = 0.obs;
    countSkip = 0.obs;
    arguments = {
      'level': "Easy",
      'route': "/addition",
      'title': "Addition",
    };
    level = MATHLEVEL.EASY;
    route = "/addition";
    title = "Addition";
    isSkip = true;
    rangeRandom = 10;
    textLevel = ''.obs;
    operand1 = Fraction(1, 1).obs;
    operand2 = Fraction(1, 1).obs;
    Fraction(1, 1);
    routeOperation = '';
    levelAdd = 1;
    super.onInit();
    checkLevel(level);
    generateQuestion(rangeRandom, route);
  }

  @override
  void onClose() {
    count.close();
    countWrong.close();
    countCorrect.close();
    countSkip.close();
    currentOptions.close();
    answerColors.close();
    textLevel.close();
    operand1.close();
    operand2.close();
    currentQuestion.close();
    super.onClose();
  }

  void skipQuestion() {
    countSkip.value++;
    count++;
    if (count.value > 10) {
      if (Get.isRegistered<SoundController>()) {
        Get.find<SoundController>().closeSoundGame();
      }

      Get.offAndToNamed(MainRouters.RESULT, arguments: {
        'countWrong': countWrong.value,
        'countCorrect': countCorrect.value,
        'countSkip': countSkip.value,
      });

      count = 1.obs;
    }
    generateQuestion(rangeRandom, route);
  }

  void checkAnswer(Fraction selectedAnswer, int index) {
    if (selectedAnswer == correctAnswer) {
      if (Get.isRegistered<SoundController>()) {
        Get.find<SoundController>().playAnswerTrueSound();
      }

      isCorrect = true;
      answerColors[index] = Colors.green;
      countCorrect.value++;
    } else {
      if (Get.isRegistered<SoundController>()) {
        Get.find<SoundController>().playAnswerFalseSound();
      }

      isCorrect = false;
      answerColors[index] = Colors.red;
      countWrong.value++;
      for (int i = 0; i < currentOptions.length; i++) {
        if (currentOptions[i] == correctAnswer) {
          answerColors[i] = Colors.green;
          break;
        }
      }
    }

    count.value++;
    Future.delayed(const Duration(milliseconds: 800), () {
      answerColors.clear();
      generateQuestion(rangeRandom, route);
    });
    if (count.value > 10) {
      if (Get.isRegistered<SoundController>()) {
        Get.find<SoundController>().closeSoundGame();
      }
      Get.offAndToNamed(MainRouters.RESULT, arguments: {
        'countWrong': countWrong.value,
        'countCorrect': countCorrect.value,
        'countSkip': countSkip.value,
      });

      count = 1.obs;
    }
  }

  void checkLevel(MATHLEVEL level) {
    switch (level) {
      case MATHLEVEL.EASY:
        textLevel = RxString('Easy');
        rangeRandom = 7;
        levelAdd = MathLevelValueMin.EASY_VALUE_ADD;
        break;
      case MATHLEVEL.MEDIUM:
        textLevel = RxString('Medium');
        rangeRandom = 9;
        levelAdd = MathLevelValueMin.MEDIUM_VALUE_ADD;
        break;
      case MATHLEVEL.HARD:
        textLevel = RxString('Hard');
        rangeRandom = 15;
        levelAdd = MathLevelValueMin.MEDIUM_VALUE_ADD;
        break;
    }
  }

  void generateQuestion(int level, String route) {
    operand1.value = fraction.createRandomFraction(level, levelAdd);
    operand2.value = fraction.createRandomFraction(level, levelAdd);
    if (title.compareTo('select_four_1'.tr) == 0) {
      routeOperation = '+';
      correctAnswer = operand1.value + operand2.value;
    } else if (title.compareTo('select_four_2'.tr) == 0) {
      routeOperation = '-';
      if ((operand1.value.numerator / operand1.value.denominator) <
          (operand2.value.numerator / operand2.value.denominator)) {
        final Fraction temp = operand1.value;
        operand1.value = operand2.value;
        operand2.value = temp;
      }

      correctAnswer = operand1.value - operand2.value;
    } else if (title.compareTo('select_four_3'.tr) == 0) {
      routeOperation = 'x';
      correctAnswer = operand1.value * operand2.value;
    } else if (title.compareTo('select_four_4'.tr) == 0) {
      routeOperation = '/';
      if ((operand1.value.numerator / operand1.value.denominator) <
          (operand2.value.numerator / operand2.value.denominator)) {
        final Fraction temp = operand1.value;
        operand1.value = operand2.value;
        operand2.value = temp;
      }
      correctAnswer = operand1.value / operand2.value;
    }
    currentOptions.clear();
    correctAnswer =
        fraction.simplify(correctAnswer.numerator, correctAnswer.denominator);
    currentOptions.add(correctAnswer);
    while (currentOptions.length < 4) {
      final Fraction fraction1 = fraction.createRandomFraction(level, levelAdd);
      if (!currentOptions.contains(fraction1)) {
        currentOptions.add(fraction1);
      }

      currentOptions.shuffle();
    }
  }

  Color getLevelColor(MATHLEVEL mathLevel) {
    switch (mathLevel) {
      case MATHLEVEL.EASY:
        return Colors.green;
      case MATHLEVEL.MEDIUM:
        return Colors.orange;
      case MATHLEVEL.HARD:
        return Colors.red;
    }
  }
}
