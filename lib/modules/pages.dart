import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PageA extends StatelessWidget {
	const PageA({super.key});

	@override
	Widget build(BuildContext context) {
		Methods.read();
		return Scaffold(
			appBar: AppBar(title: const Text('Catalogue (Page A)'),),
			body: FutureBuilder(
				future: Methods.read(),
				builder: (context, snapshot) {
				  if(snapshot.hasError){
						return Center(child: Text(snapshot.error.toString()),);
					}else{
						List<Map<String,dynamic>> temp = [];
						return ListView.builder(
							itemCount: snapshot.data!.length,
							itemBuilder: (context, index) {
							  return Items(data: snapshot.data![index], function: () {
									temp.clear();
									temp.addAll(snapshot.data!.where((element) => snapshot.data![index]['id'] == element['parent']));
									Navigator.push(context, MaterialPageRoute(builder: (context) {
									  if(temp.length>1) {
											return PageB(data: temp,);
										} else {
											return PageC(data: snapshot.data![index],);
										}
									},));
								},);
							},
						);
					}
				},
			),
		);
	}
}

class PageB extends StatelessWidget {
	final List<Map<String,dynamic>>? data;
	const PageB({super.key, this.data});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Catalogue (Page B)'),),
			body: ListView.builder(
				itemCount: data!.length,
				itemBuilder: (context, index) {
					List<Map<String,dynamic>> temp = [];
				  return Items(data: data![index], function: () {
						temp.clear();
						temp.addAll(data!.where((element) => data![index]['id'] == element['parent']));
						Navigator.push(context, MaterialPageRoute(builder: (context) {
							if(temp.length>1) {
							  return PageB(data: temp,);
							} else {
							  return PageC(data: data![index],);
							}
						},));
					},);
				},
			),
		);
	}
}

class PageC extends StatelessWidget {
	final Map<String,dynamic>? data;
	const PageC({super.key, this.data});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Catalogue (Page C)'),),
			body: Padding(
			  padding: const EdgeInsets.all(10.0),
			  child: Center(
			    child: Card(
					elevation: 10,
					child: Column(
						mainAxisSize: MainAxisSize.min,
						children: <Widget>[
							ListTile(
								title: const Text('Name'), leading: CircleAvatar(child: Text(data!['id'].toString())),
								subtitle: Text(data!['name']), trailing: Text('ID : ${data!["id"]}'),
							),
							ListTile(
								title: const Text('Slug'), leading: CircleAvatar(child: Text(data!['parent'].toString())),
								subtitle: Text(data!['slug']), trailing: Text('Parent ID : ${data!["parent"]}'),
							),
						],
					),
			    ),
			  ),
			)
		);
	}
}

class Items extends StatelessWidget {
	final Map<String,dynamic>? data;
	final VoidCallback? function; 
	const Items({super.key, this.data, this.function});

	@override
	Widget build(BuildContext context) {
		return ListTile(
			title: Text(data!['name']), subtitle: Text(data!['slug']),
			leading: CircleAvatar(child: Text(data!['id'].toString())),
			onTap: function, trailing: Text(data!['parent'].toString()),
		);
	}
}


class Methods{
	static Future<List<Map<String,dynamic>>> read() async {
			final String response = await rootBundle.loadString('assets/data.json');
			final List<dynamic> list = json.decode(response) as List<dynamic>;
			return list.map((e) => e as Map<String,dynamic>).toList();
	}
}