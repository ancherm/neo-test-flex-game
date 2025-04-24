import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const _gradientColors = [
    Color(0xFF921C63),
    Color(0xFFE8A828),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'История Neoflex',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF150F1E),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Профиль',
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntro(),
              const SizedBox(height: 24),
              _buildYearSection('2019', [
                'Neoflex фокусируется на заказной разработке высоконагруженных бизнес-приложений в микросервисной архитектуре и внедрении сложных ИТ-систем.',
                'Компания расширяет международную географию присутствия. Состоялось открытие южноафриканского офиса в Йоханнесбурге, что обеспечило оперативное взаимодействие с заказчиками в регионе, а также Анголе и Нигерии.',
                'Заключены партнерские соглашения с международными вендорами, такими как Lightbend, Camunda и WSO2.',
                'География проектов: Россия, Великобритания, Латвия, Франция, Германия, Грузия, Мальта, Греция, Турция, Иордания, Индия, Пакистан, Саудовская Аравия, Кабо-Верде, Вьетнам, Индонезия, Ангола, ЮАР.',
                'Новые заказчики: Habib Bank Limited, Mediascope, Икано Банк, Объединенное Кредитное Бюро, Банк Уралсиб, Уральский банк реконструкции и развития.',
              ]),
              const SizedBox(height: 16),
              _buildYearSection('2020', [
                'Neoflex показал значительный рост за счет микросервисной разработки и направления, связанного с большими данными: аналитические системы, системы потоковой обработки данных с применением технологий машинного обучения.',
                'В 2020 году Neoflex реализовал ряд ключевых проектов по цифровой трансформации бизнеса крупнейших российских банков в части создания аналитических решений с использованием технологий Big Data, Fast Data и Machine Learning.',
                'Создан Центр развития компетенций для подготовки ИТ-кадров и усиления экспертизы в облачных технологиях, MLOps, Data Science, DevOps и Fast Data.',
                'Открыт филиал и центр разработки Neoflex в городе Пензе.',
                'Запущен в работу учебный центр на базе Воронежского государственного технического университета.',
                'Расширена география проектов: впервые реализованы проекты в Китае и Узбекистане.',
                'Neoflex стал первой российской компанией, получившей членство в международной Ассоциации Поставщиков Кредитной Информации (ACCIS).',
                'География проектов: Россия, Великобритания, Латвия, Франция, Германия, Грузия, Мальта, Греция, Турция, Иордания, Индия, Пакистан, Саудовская Аравия, Кабо-Верде, Вьетнам, Индонезия, Ангола, ЮАР, Китай, Узбекистан.',
                'Новые заказчики: Росбанк, Народный банк Узбекистана, The Asian Infrastructure Investment Bank (AIIB)',
              ]),
              const SizedBox(height: 16),
              _buildYearSection('2021', [
                'Команда Neoflex в 2021 году выросла с 785 до 1160 человек. Открыты новые офисы в Краснодаре и Самаре.',
                'Фокус компании был направлен на автоматизацию цифровых каналов и бизнес-процессов для заказчиков.',
                'Для развития экспертизы в области искусственного интеллекта была создана практика Data Science.',
                'Запущены новые направления по обучению студентов в "Учебном центре" Neoflex.',
                'В рамках социальных инициатив компании стартовала программа по обучению компьютерной грамотности и программированию для детей в детских домах.',
                'География проектов: Россия, Великобритания, Латвия, Франция, Германия, Грузия, Мальта, Греция, Турция, Иордания, Индия, Пакистан, Саудовская Аравия, Кабо-Верде, Вьетнам, Индонезия, Ангола, Нигерия, ЮАР, Китай, Узбекистан, Филиппины.',
              ]),
              const SizedBox(height: 16),
              _buildYearSection('2022', [
                'В 2022 году фокус компании Neoflex был направлен на разработку и внедрение сложных бизнес-приложений с использованием передовых и современных методологий.',
                'Компания реализовала ряд ключевых проектов в крупнейших российских банках и страховых компаниях.',
              ]),
              const SizedBox(height: 16),
              _buildYearSection('2023', [
                'В 2023 году фокус компании был направлен на разработку и внедрение сложных бизнес-приложений с использование передовых и современных методологий.',
                'Технологическая экспертиза Neoflex была расширена и дополнена целым рядом центров компетенций и направлений.',
              ]),
              const SizedBox(height: 16),
              _buildYearSection('2024', [
                'В 2024 году компания Neoflex продемонстрировала значительный рост по всем направлениям деятельности.',
                'Основные результаты года:',
                '• Рост ключевых финансовых показателей составил более 25%',
                '• Численность команды увеличилась на 200+ сотрудников',
                'Среди ключевых новинок:',
                '• Neoflex Reporting Risk',
                '• Neoflex Foundation',
                '• Neoflex Reporting Studio',
                '• NEOMSA APIM',
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: _gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: const Text(
        'Neoflex создает ИТ-платформы для цифровой трансформации бизнеса, помогая заказчикам получать устойчивые конкурентные преимущества в цифровую эпоху.\n\n'
        'Мы фокусируемся на заказной разработке программного обеспечения и внедрении сложных информационных систем, используя передовые технологии и подходы.\n\n'
        'Наш отраслевой опыт и технологическая экспертиза, усиленная собственными акселераторами разработки, позволяют решать бизнес-задачи любого уровня сложности. Наши клиенты это – 21 компания из рейтинга RAEX-600, 23 компании из рейтинга РБК ТОП-100 и 41 российский банк из ТОП-100.',
        style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
      ),
    );
  }

  Widget _buildYearSection(String year, List<String> points) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: _gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            year,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ...points.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(
                            fontSize: 16, height: 1.5, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
