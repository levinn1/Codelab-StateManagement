import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'global_state.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GlobalState(),
      child: MyGlobalCounterApp(),
    ),
  );
}

class MyGlobalCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Global State Example')),
        body: CounterListWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<GlobalState>(context, listen: false).addCounter();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class CounterListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);

    return ReorderableListView.builder(
      onReorder: (oldIndex, newIndex) {
        globalState.reorderCounters(oldIndex, newIndex);
      },
      itemCount: globalState.counters.length,
      itemBuilder: (context, index) {
        return CounterItemWidget(key: ValueKey(index), index: index);
      },
    );
  }
}


class CounterItemWidget extends StatelessWidget {
  final int index;

  const CounterItemWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);
    final counter = globalState.counters[index];

    return Card(
      key: ValueKey(index),
      color: counter.color.withOpacity(0.9),
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          '${counter.label}: ${counter.value}',
          style: TextStyle(color: Colors.white),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.color_lens, color: Colors.white),
              onPressed: () => _pickColor(context, index),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () => _editLabel(context, index),
            ),
            IconButton(
              icon: Icon(Icons.remove, color: Colors.white),
              onPressed: () {
                globalState.decrementCounter(index);
              },
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                globalState.incrementCounter(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pickColor(BuildContext context, int index) async {
    final globalState = Provider.of<GlobalState>(context, listen: false);
    Color? selectedColor = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Counter Color'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: globalState.counters[index].color,
            onColorChanged: (color) {
              Navigator.of(context).pop(color);
            },
          ),
        ),
      ),
    );

    if (selectedColor != null) {
      globalState.updateCounterColor(index, selectedColor);
    }
  }

  void _editLabel(BuildContext context, int index) async {
    final globalState = Provider.of<GlobalState>(context, listen: false);
    String? newLabel = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller =
            TextEditingController(text: globalState.counters[index].label);
        return AlertDialog(
          title: Text('Edit Counter Label'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Counter Label'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newLabel != null) {
      globalState.updateCounterLabel(index, newLabel);
    }
  }
}



