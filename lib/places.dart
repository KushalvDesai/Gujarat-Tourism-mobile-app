import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart';
import 'home.dart';

List<List<dynamic>> touristPlaces = [
  [
    'Gir National Park',
    'Famous for Asiatic lions, this national park is a must-visit wildlife destination in Gujarat.',
    'assets/images/girPark.jpg',
    500.0,
  ],
  [
    'Statue of Unity',
    'World\'s tallest statue dedicated to Sardar Vallabhbhai Patel, located near vadodara.',
    'assets/images/statueOfUnity.jpg',
    750.0,
  ],
];

class TouristPlacesScreen extends StatelessWidget {
  const TouristPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourist Places'),
        backgroundColor: Colors.orange[600],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: touristPlaces.length,
        itemBuilder: (context, index) {
          final place = touristPlaces[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(place[2]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    place[0],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(place[1], style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${(place[3] as double).toInt()}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TicketBookingScreen(
                                selectedPlaceIndex: index,
                              ),
                            ),
                          );
                        },
                        child: const Text('Book Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TicketBookingScreen extends StatefulWidget {
  final int? selectedPlaceIndex;

  const TicketBookingScreen({super.key, this.selectedPlaceIndex});

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  final _visitorsController = TextEditingController();
  final _dateController = TextEditingController();
  int? selectedPlaceIndex;

  @override
  void initState() {
    super.initState();
    selectedPlaceIndex = widget.selectedPlaceIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Tickets'),
        backgroundColor: Colors.orange[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Book Your Ticket',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text(
              'Select Place:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: selectedPlaceIndex,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Choose a destination',
              ),
              items: List.generate(touristPlaces.length, (index) {
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(touristPlaces[index][0]),
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectedPlaceIndex = value;
                });
              },
            ),
            const SizedBox(height: 16),

            const Text(
              'Number of Visitors:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _visitorsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter number of visitors',
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Visit Date:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'DD/MM/YYYY',
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: _generateTicket,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Generate Ticket',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateTicket() {
    if (selectedPlaceIndex != null &&
        _visitorsController.text.isNotEmpty &&
        _dateController.text.isNotEmpty) {
      String ticketNumber =
          'GT${Random().nextInt(100000).toString().padLeft(5, '0')}';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TicketDisplayScreen(
            ticketNumber: ticketNumber,
            placeIndex: selectedPlaceIndex!,
            visitors: int.parse(_visitorsController.text),
            visitDate: _dateController.text,
            userName: currentUser.isNotEmpty ? currentUser[2] : 'User',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
    }
  }
}

class TicketDisplayScreen extends StatelessWidget {
  final String ticketNumber;
  final int placeIndex;
  final int visitors;
  final String visitDate;
  final String userName;

  const TicketDisplayScreen({
    super.key,
    required this.ticketNumber,
    required this.placeIndex,
    required this.visitors,
    required this.visitDate,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final place = touristPlaces[placeIndex];
    double totalAmount = (place[3] as double) * visitors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Generated'),
        backgroundColor: Colors.orange[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'TICKET CONFIRMED',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Ticket No: $ticketNumber',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildTicketRow('Name:', userName),
                  _buildTicketRow('Destination:', place[0]),
                  _buildTicketRow('Visit Date:', visitDate),
                  _buildTicketRow('Visitors:', visitors.toString()),
                  _buildTicketRow(
                    'Price per person:',
                    '₹${(place[3] as double).toInt()}',
                  ),
                  const Divider(thickness: 2),
                  _buildTicketRow(
                    'Total Amount:',
                    '₹${totalAmount.toInt()}',
                    isTotal: true,
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Please show this ticket at the entrance',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
