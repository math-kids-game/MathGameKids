import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:template/core/base_widget/izi_image.dart';
import 'package:template/presentation/pages/opinion_play/play_fractice/model/fraction_model.dart';
import 'package:template/presentation/pages/opinion_play/play_fractice/play_fractice_controller.dart';
import 'package:template/presentation/pages/result_package/result_page.dart';

void main() {
  group('PlayFracticeController Tests', () {
    late PlayFracticeController controller;

    setUp(() {
      controller = PlayFracticeController();
      controller.onInit();
      controller.currentQuestion = "5 + 8 = ?".obs;
      controller.correctAnswer = Fraction(1, 1);
      controller.currentOptions = List<Fraction>.generate(4, (index) => Fraction(0, 0)).obs;
      controller.isCorrect = true;
      controller.answerColors = <int, Color>{}.obs;
      controller.count = 1.obs;
      controller.countWrong = 0.obs;
      controller.countCorrect = 0.obs;
      controller.countSkip = 0.obs;
      controller.arguments = {
        'level': "Easy",
        'route': "/addition",
        'title': "Addition",
      };
      controller.rangeRandom = 10;
      controller.textLevel = ''.obs;
      controller.operand1 = Fraction(1, 1).obs;
      controller.operand2 = Fraction(1, 1).obs;
      controller.fraction = Fraction(1, 1);
      // Fraction result = Fraction(0, 0);
      controller.routeOperation = '';
      controller.levelAdd = 1;
      Get.testMode = true;
    });

    tearDown(() {
      // Clear the mocks and reset the controller
      Get.reset();
    });

    // Hàm SkipQuestion
    test('Skip Question Test - click skip button', () {
      // Arrange
      controller.count.value = 5;

      // Act
      controller.skipQuestion();

      // Assert
      expect(controller.countSkip.value, 1);
      expect(controller.count.value, 6);
    });

    test('Skip Question Test - click skip when end of question', () {
      // Arrange
      controller.count.value = 10;

      // Act
      controller.skipQuestion();

      // Assert
      expect(controller.count.value, 1);
      expect(Get.previousRoute, "");
    });

    // Hàm checkAnswer
    test('Check Answer Test - Correct Answer', () {
      controller.countCorrect = 0.obs;
      controller.countWrong = 0.obs;
      // Arrange
      controller.operand1.value = Fraction(1, 1);
      controller.operand2.value = Fraction(2, 1);
      controller.correctAnswer = Fraction(3, 1);

      // Act
      controller.checkLevel(controller.level);
      controller.generateQuestion(controller.rangeRandom, controller.route);
      final position = controller.currentOptions.indexOf(controller.correctAnswer);
      controller.checkAnswer(controller.correctAnswer, position);

      // Assert
      expect(controller.countCorrect.value, 1);
      expect(controller.countWrong.value, 0);
      expect(controller.answerColors[position], Colors.green);
    });

    test('Check Answer Test - Incorrect Answer', () {
      controller.countCorrect = 0.obs;
      controller.countWrong = 0.obs;
      // Arrange
      controller.operand1.value = Fraction(1, 1);
      controller.operand2.value = Fraction(2, 1);
      controller.correctAnswer = Fraction(3, 1);

      // Act
      controller.checkLevel(controller.level);
      controller.generateQuestion(controller.rangeRandom, controller.route);
      final wrongPosition = controller.currentOptions.indexWhere((element) => element != controller.correctAnswer);
      controller.checkAnswer(controller.currentOptions[wrongPosition], wrongPosition);

      // Assert
      expect(controller.countCorrect.value, 0);
      expect(controller.countWrong.value, 1);
      expect(controller.answerColors[wrongPosition], Colors.red);
    });

    test('Generate Question Test', () {
      // Act
      controller.checkLevel(controller.level);
      controller.generateQuestion(controller.rangeRandom, controller.route);

      // Assert
      expect(controller.operand1.value, isA<Fraction>());
      expect(controller.operand2.value, isA<Fraction>());
      expect(controller.currentOptions.length, 4);
      expect(controller.currentOptions.contains(controller.correctAnswer), true);
    });
  });
}