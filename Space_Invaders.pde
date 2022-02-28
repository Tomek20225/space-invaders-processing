private Game game;
private boolean[] player1_keys;
private boolean[] player2_keys;

public void setup() {
  size(448, 512);
  
  game = new Game();
  
  player1_keys = new boolean[]{false, false, false};
  player2_keys = new boolean[]{false, false, false};
}

public void setMovement(int key, boolean state) {
  switch (key) {
    case 65:
      player1_keys[0] = state;
      break;
    case 68:
      player1_keys[1] = state;
      break;
    case 87:
      player1_keys[2] = state;
      break;
    default:
      break;
  }
  
  if (game.mode() == "MULTIPLAYER") {
    switch (key) {
      case 37:
        player2_keys[0] = state;
        break;
      case 39:
        player2_keys[1] = state;
        break;
      case 38:
        player2_keys[2] = state;
        break;
      default:
        break;
    }
  }
}

public void keyPressed() {
  if (!game.isPaused() && game.isStarted() && !game.isOver()) {
    setMovement(keyCode, true);
  }
  else if (game.isOver()) {
    if (keyCode == 49) {
      game = new Game(); 
    }
  }
  else {
    switch (keyCode) {
      case 49:
        game.start("SINGLEPLAYER");
        break;
      case 50:
        game.start("MULTIPLAYER");
        break;
      default:
        break;
    }
  }
}

public void keyReleased() {
  if (!game.isPaused() && game.isStarted()) {
    setMovement(keyCode, false);
  }
}

public void draw() {
  background(0);
  
  if (game.isStarted() && !game.isOver()) {
    game.play(player1_keys, player2_keys); 
  }
  else if (game.isOver()) {
    game.showGameOver();
  }
  else {
    game.showMenu();
  }
  
  //println(frameRate);
}
