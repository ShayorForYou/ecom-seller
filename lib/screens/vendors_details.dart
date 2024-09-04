import 'dart:convert';
import 'dart:math';

import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/screens/vendor_payment.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import '../custom/my_app_bar.dart';

class VendorDetails extends StatefulWidget {
  const VendorDetails({super.key});

  @override
  State<VendorDetails> createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails> {
  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  final TransformationController _transformationController =
      TransformationController();

  Random r = Random();
  final Map<int, Map<String, String>> nodeData = {}; // Store node data

  @override
  void initState() {
    super.initState();
    _transformationController.value = Matrix4.diagonal3Values(0.5, 0.5, 1);

    loadGraph();
  }

  void loadGraph() {
    const jsonString = '''
    {
      "vendors": [
        {
          "id": 1,
          "name": "Acme Corp",
          "address": "123 Main St, Springfield",
          "email": "contact@acmecorp.com",
          "children": [
            {
              "id": 2,
              "name": "Beta Ltd",
              "address": "456 Elm St, Springfield",
              "email": "info@betaltd.com",
              "children": [
                {
                  "id": 5,
                  "name": "Gamma Inc",
                  "address": "789 Oak St, Springfield",
                  "email": "support@gammainc.com"
                },
                {
                  "id": 6,
                  "name": "Delta LLC",
                  "address": "101 Pine St, Springfield",
                  "email": "sales@deltallc.com",
                  "children": [
                    {
                      "id": 7,
                      "name": "Epsilon Co",
                      "address": "202 Maple St, Springfield",
                      "email": "contact@epsilonco.com"
                    },
                    {
                      "id": 8,
                      "name": "Zeta Enterprises",
                      "address": "303 Birch St, Springfield",
                      "email": "info@zetaenterprises.com"
                    }
                  ]
                }
              ]
            },
            {
              "id": 3,
              "name": "Theta Solutions",
              "address": "404 Cedar St, Springfield",
              "email": "support@thetasolutions.com"
            },
            {
              "id": 4,
              "name": "Iota Services",
              "address": "505 Walnut St, Springfield",
              "email": "contact@iotaservices.com",
              "children": [
                {
                  "id": 9,
                  "name": "Kappa Systems",
                  "address": "606 Chestnut St, Springfield",
                  "email": "info@kappasystems.com"
                },
                {
                  "id": 10,
                  "name": "Lambda Technologies",
                  "address": "707 Redwood St, Springfield",
                  "email": "support@lambdatechnologies.com"
                },
                {
                  "id": 11,
                  "name": "Mu Innovations",
                  "address": "808 Willow St, Springfield",
                  "email": "sales@muinnovations.com",
                  "children": [
                    {
                      "id": 12,
                      "name": "Nu Ventures",
                      "address": "909 Aspen St, Springfield",
                      "email": "contact@nuventures.com"
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
    ''';

    final data = json.decode(jsonString);
    final vendors = data['vendors'];
    buildGraph(vendors[0], null);
  }

  void buildGraph(Map<String, dynamic> vendor, Node? parent) {
    final node = Node.Id(vendor['id'].toString()); // Ensure ID is a String
    graph.addNode(node);

    // Store node data
    nodeData[vendor['id']] = {
      'name': vendor['name'],
      'address': vendor['address'],
      'email': vendor['email'],
    };

    if (parent != null) {
      graph.addEdge(parent, node);
    }

    if (vendor['children'] != null) {
      for (var child in vendor['children']) {
        buildGraph(child, node);
      }
    }
  }

  Widget rectangleWidget(String id) {
    final intId = int.tryParse(id) ?? 0;
    final data = nodeData[intId] ?? {};
    return InkWell(
      onTap: () {
        // print('Vendor $id');
        //show popup
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const VendorPayment(),
          ),
        );
      },
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                data['name'] ?? 'Unknown',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                data['address'] ?? 'No Address',
                style: const TextStyle(),
              ),
              const SizedBox(height: 4),
              Text(
                data['email'] ?? 'No Email',
                style: const TextStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        bottom: null,
        title: 'Manage Vendors',
        centerTitle: true,
      ).show(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: InteractiveViewer(
              transformationController: _transformationController,
              constrained: false,
              boundaryMargin: const EdgeInsets.all(8),
              minScale: 0.1,
              maxScale: 5.6,
              child: Padding(
                padding: const EdgeInsets.all(200.0),
                child: GraphView(
                  paint: Paint()
                    ..color = MyTheme.app_accent_color
                    ..strokeWidth = 2
                    ..style = PaintingStyle.stroke,
                  graph: graph,
                  algorithm: BuchheimWalkerAlgorithm(
                      builder, TreeEdgeRenderer(builder)),
                  builder: (Node node) {
                    var id = node.key!.value as String;
                    return rectangleWidget(id);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
