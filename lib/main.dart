import 'package:catalouge/modules/pages.dart';
import 'package:flutter/material.dart';

void main() {
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Catalogue', debugShowCheckedModeBanner: false,
			theme: ThemeData(primarySwatch: Colors.indigo,),
			home: const PageA(),
		);
	}
}