import 'package:flutter/material.dart';

class NewsTile extends StatelessWidget {
  const NewsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Breaking News: Ancient Artifacts Discovered in Egyptian Tomb",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const Wrap(
              runSpacing: -4,
              spacing: 4,
              children: [
                Chip(label: Text("Archeology")),
                Chip(label: Text("Ancient History")),
                Chip(label: Text("Egyptian History")),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
                "Archaeologists have unearthed a previously undiscovered tomb in the Valley of the Kings, Egypt. The tomb, believed to belong to a high-ranking official from the 18th dynasty, contains a wealth of artifacts, including intricately decorated pottery, jewelry, and a pristine sarcophagus. Experts are excited about the potential insights into ancient Egyptian culture and politics. The discovery is hailed as one of the most significant in recent decades, promising to shed new light on this fascinating period of history. Further excavations are planned to uncover more about the tomb's occupant and their role in ancient society."),
          ],
        ),
      ),
    );
  }
}
