import 'package:flutter/material.dart';

class AccountLinkScreen extends StatelessWidget {
  final VoidCallback onComplete;

  AccountLinkScreen({required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('계좌를 연결해주세요.'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement actual account linking logic
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('계좌 연결'),
                    content: Text('계좌가 성공적으로 연결되었습니다.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onComplete();
                        },
                        child: Text('확인'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('계좌 연결하기'),
          ),
        ],
      ),
    );
  }
}