import 'package:flutter/material.dart';
import '../models/replies_model.dart';

class ReplyScreen extends StatefulWidget {
  final Reply reply;
  final Function(Reply) onSave;
  final Function(Reply) onDelete;

  ReplyScreen({required this.reply, required this.onSave, required this.onDelete});

  @override
  _ReplyScreenState createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _replyController.text = widget.reply.content;
  }

  void _saveReply() {
    widget.reply.content = _replyController.text;
    widget.onSave(widget.reply);
  }

  void _deleteReply() {
    widget.onDelete(widget.reply);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _replyController,
            decoration: InputDecoration(
              hintText: "Edit your reply here...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            maxLines: null,
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _saveReply,
                child: Text("Save"),
              ),
              ElevatedButton(
                onPressed: _deleteReply,
                child: Text("Delete"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
