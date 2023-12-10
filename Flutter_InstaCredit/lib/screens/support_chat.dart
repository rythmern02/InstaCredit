import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/design/textfield.dart';
import 'package:bnpl_flutter/models/signer.dart';
import 'package:ethers/signers/wallet.dart' as ethers;
import 'package:bnpl_flutter/riverpod/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart' as push;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class SupportChat extends ConsumerStatefulWidget {
  const SupportChat({super.key});

  @override
  ConsumerState<SupportChat> createState() => _SupportChatState();
}

class _SupportChatState extends ConsumerState<SupportChat> {
  List<String> _chatlist = [];
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  sendPushChat() async {
    final auth = ref.watch(authStateProvider);
    final ethersWallet = ethers.Wallet.fromPrivateKey(
      bytesToHex(auth.credentials.privateKey),
    );

    final user = await push.createUser(
      signer: EthersSigner(
        ethersWallet: ethersWallet,
        address: ethersWallet.address!,
      ),
      progressHook: (push.ProgressHookType progress) {
        print(progress.progressInfo);
      },
    );

    if (user == null) {
      print('Cannot get user');
      return;
    }

    String? pgpPrivateKey = null;
    pgpPrivateKey = await push.decryptPGPKey(
      encryptedPGPPrivateKey: user.encryptedPrivateKey!,
      wallet: push.getWallet(
        signer: EthersSigner(
          ethersWallet: ethersWallet,
          address: ethersWallet.address!,
        ),
      ),
    );

    final options = push.ChatSendOptions(
      pgpPrivateKey: pgpPrivateKey,
      accountAddress: auth.credentials.address.hexEip55,
      messageContent: _controller.text,
      receiverAddress: '0x37c9D3CE6Be22bDe49aAb7F5Ad2bd6749B2A73F6',
    );

    final result = await push.send(options);
  }

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey('second-sliver-list');
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            SvgPicture.asset(
              'assets/images/background.svg',
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFF202020),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.support_agent_rounded,
                          size: 24,
                          color: Color(0xFFE0E0E0),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Instacredit Support",
                          style: TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: CustomScrollView(
                      center: centerKey,
                      reverse: true,
                      slivers: <Widget>[
                        SliverList(
                          key: centerKey,
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    width: deviceWidth(context) * 0.4,
                                    alignment: Alignment.bottomRight,
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                      color: gold,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      _chatlist[index],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            childCount: _chatlist.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: deviceWidth(context) * 0.8,
                        child: TextFormField(
                          cursorColor: lightGold,
                          controller: _controller,
                          style: const TextStyle(
                            color: lightGold,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            constraints: const BoxConstraints(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1000),
                              borderSide: const BorderSide(
                                color: Color(0xffb5b5b55e),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1000),
                              borderSide: const BorderSide(
                                color: gold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            setState(() {
                              _chatlist = [..._chatlist, _controller.text];
                              _controller.clear();
                            });
                            // sendPushChat();
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: gold,
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
