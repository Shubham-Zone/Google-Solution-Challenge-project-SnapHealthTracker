import 'package:flutter/material.dart';

class HealthTipsPage extends StatelessWidget {

  final List<String> healthTips = [
    "Drink plenty of water every day.",
    "Eat a balanced and nutritious diet.",
    "Get at least 30 minutes of exercise daily.",
    "Ensure proper sleep for overall well-being.",
    "Practice mindfulness and meditation.",
    "Laugh and find joy in small things.",
    "Connect with loved ones regularly.",
    "Limit processed foods and sugar intake.",
    "Take breaks and stretch during work.",
    "Cultivate a positive mindset.",
  ];

  final List<String> positiveMessages = [
    "You are stronger than you think.",
    "Every day is a new opportunity for happiness.",
    "Your health is an investment, not an expense.",
    "Believe in yourself and all that you are.",
    "Positivity is a choice that becomes a lifestyle.",
    "Take care of your body; it's the only place you have to live.",
    "Every small positive change can lead to a healthier lifestyle.",
    "Your journey to a healthier life begins with a single step.",
    "You have the power to create a healthy and happy life.",
    "Radiate positive vibes and attract good energy.",
  ];

  HealthTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Tips & Positivity"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: "Health Tips"),
            for (String tip in healthTips) HealthTipCard(tip: tip),
            const SizedBox(height: 20),
            const SectionTitle(title: "Positive Messages"),
            for (String message in positiveMessages) PositiveMessageCard(message: message),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class HealthTipCard extends StatelessWidget {
  final String tip;

  const HealthTipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          leading: const Icon(Icons.favorite, color: Colors.red,),
          title: Text(tip),
        ),
      ),
    );
  }
}

class PositiveMessageCard extends StatelessWidget {

  final String message;

  const PositiveMessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          leading: const Icon(Icons.sentiment_satisfied, color: Colors.orangeAccent,),
          title: Text(message),
        ),
      ),
    );
  }


}
