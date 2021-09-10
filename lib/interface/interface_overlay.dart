import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/player/game_player.dart';
import 'package:mountain_fight/player/remote_player.dart';

///
/// Created by
///
/// ─▄▀─▄▀
/// ──▀──▀
/// █▀▀▀▀▀█▄
/// █░░░░░█─█
/// ▀▄▄▄▄▄▀▀
///
/// Rafaelbarbosatec
/// on 09/09/21
class InterfaceOverlay extends StatefulWidget {
  final GameController gameController;
  const InterfaceOverlay({Key key, this.gameController}) : super(key: key);

  @override
  _InterfaceOverlayState createState() => _InterfaceOverlayState();
}

class _InterfaceOverlayState extends State<InterfaceOverlay>
    implements GameListener {
  GamePlayer _player;
  final double _sizeBar = 100;
  final double _maxLife = 100;
  final double _maxStamina = 100;
  List<String> nickNames = [];
  double life = 0;
  double stamina = 0;

  @override
  void initState() {
    widget.gameController.setListener(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          _buildLife(),
          Align(
            alignment: Alignment.topRight,
            child: _buildPlayersOn(),
          )
        ],
      ),
    );
  }

  Widget _buildPlayersOn() {
    return Opacity(
      opacity: 0.8,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 150,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Playes on',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 100,
              height: 1,
              color: Colors.white.withOpacity(0.5),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: nickNames.length,
                itemBuilder: (context, index) {
                  return Text(
                    nickNames[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLife() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _player?.nick ?? '',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 100,
            height: 1,
            color: Colors.white.withOpacity(0.5),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Life',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          Container(
            height: 10,
            width: _sizeBar,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.white),
            ),
            alignment: Alignment.centerLeft,
            child: Container(
              height: 10,
              width: _sizeBar * (life / _maxLife),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            'Stamina',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          Container(
            height: 10,
            width: _sizeBar,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.white),
            ),
            alignment: Alignment.centerLeft,
            child: Container(
              height: 10,
              width: _sizeBar * (stamina / _maxStamina),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void changeCountLiveEnemies(int count) {}

  @override
  void updateGame() {
    if (!mounted) return;
    _player = widget.gameController.player as GamePlayer;
    if (life != _player.life) {
      setState(() {
        life = _player.life;
      });
    }
    if (stamina != _player.stamina) {
      setState(() {
        stamina = _player.stamina;
      });
    }
    if (nickNames.length != widget.gameController.livingEnemies.length) {
      setState(() {
        nickNames = widget.gameController.livingEnemies.map((e) {
          return (e as RemotePlayer).nick;
        }).toList();
      });
    }
  }
}
