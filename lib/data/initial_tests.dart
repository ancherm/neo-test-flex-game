import '../entity/test.dart';

/// Список начальных тестов с указанием раздела и части
final List<Test> initialTests = [
  // История — часть 1
  Test(
    question: 'На чем фокусировалась компания Neoflex в 2019 году?',
    answers: [
      'На заказной разработке высоконагруженных бизнес-приложений в микросервисной архитектуре и внедрении сложных ИТ-систем.',
      'На автоматизацию цифровых каналов и бизнес-процессов для заказчиков',
      'На разработку и внедрение сложных бизнес-приложений с использование передовых и современных методологий.',
    ],
    correctAnswer: 0,
    testType: 'history',
    part: 'part1',
  ),
  Test(
    question: 'В каких городах были открыты новые офисы компании Neoflex в 2021 году?',
    answers: [
      'В Москве и Саратове',
      'В Саратове и Самаре',
      'В Краснодаре и Самаре',
    ],
    correctAnswer: 2,
    testType: 'history',
    part: 'part1',
  ),

  // История — часть 2
  Test(
    question: 'В каком году Neoflex стал первой российской компанией, получившей членство в международной Ассоциации Поставщиков Кредитной Информации (ACCIS)?',
    answers: ['2021', '2020', '2019'],
    correctAnswer: 1,
    testType: 'history',
    part: 'part2',
  ),
  Test(
    question: 'В каком году стартовала программа по обучению компьютерной грамотности и программированию для детей в детских домах?',
    answers: ['2021', '2020', '2019'],
    correctAnswer: 0,
    testType: 'history',
    part: 'part2',
  ),

  // Flutter — часть 1
  Test(
    question: 'Какой компанией был разработан Flutter?',
    answers: ['OpenAI', 'Microsoft', 'Google'],
    correctAnswer: 2,
    testType: 'flutter',
    part: 'part1',
  ),
  Test(
    question: 'В каком году был выпущен Flutter?',
    answers: ['2012', '2014', '2016'],
    correctAnswer: 1,
    testType: 'flutter',
    part: 'part1',
  ),

  // Flutter — часть 2
  Test(
    question: 'Как называлась первая версия Flutter?',
    answers: ['Sky', 'Blue', 'Dart'],
    correctAnswer: 0,
    testType: 'flutter',
    part: 'part2',
  ),
  Test(
    question: 'В какой версии Flutter была реализована поддержка создания настольных приложений для Windows, macOS, Linux и Google Fuchsia?',
    answers: ['Flutter 2.0', 'Flutter 3.0', 'Flutter 32.0'],
    correctAnswer: 0,
    testType: 'flutter',
    part: 'part2',
  ),
];
