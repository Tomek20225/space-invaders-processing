import java.io.RandomAccessFile;

color[] colors = {
  color(237, 223, 23), // żółty
};

public class Game {
  private Player[] players;
  private EnemyPlane plane;
  private Barrier[] barriers;
  private Floor floor;
  private Bullet[][] player_bullets;
  private Bullet[] enemyBullets;
  private String mode;
  private final PFont font;
  private int[] player_scores;
  private int highestScore;
  private int level;
  private int[] player_lives;
  private boolean isPaused;
  private boolean isStarted;
  private boolean isOver;
  
  public Game() {
    this.players = new Player[2];
    this.barriers = new Barrier[4];
    this.player_bullets = new Bullet[2][1];
    this.enemyBullets = new Bullet[3];
    this.level = 1;
    this.player_lives = new int[]{3, 3};
    this.player_scores = new int[]{0, 0};
    this.isPaused = true;
    this.isStarted = false;
    this.isOver = false;
    
    try {
      this.highestScore = readHighestScore(); 
    }
    catch (Exception e) {
      println(e); 
    }
    
    this.font = createFont("space_invaders.ttf", 16);
    textFont(this.font);
    textSize(16);
  }
  
  private void setupLevel() {
    this.players[0] = new Player();
    
    if (this.mode == "MULTIPLAYER") {
      this.players[1] = new Player(); 
    }
    
    this.plane = new EnemyPlane(this.level);
    
    int barrierWidth = 44;
    float barriersDist = (width - (4 * barrierWidth)) / 5;
    float barrierX = barriersDist;
    for (int i = 0; i < barriers.length; i++) {
      this.barriers[i] = new Barrier(barrierX, height - 132);
      barrierX += barriersDist + barrierWidth;
    }
    
    int floor_w = 434;
    float floor_x = (width - floor_w) / 2;
    this.floor = new Floor(floor_x, height - 44, floor_w);
    
    this.removeBullets();
    this.isPaused = false;
  }
  
  private void showHeader() {
    fill(255);
    
    textAlign(LEFT, BOTTOM);
    text("SCORE<1>", 28, 24);
    text(this.player_scores[0], 58, 54);
    
    textAlign(CENTER, BOTTOM);
    text("HI-SCORE", width / 2, 24);
    text(this.highestScore, width / 2, 54);
    
    textAlign(RIGHT, BOTTOM);
    text("SCORE<2>", width - 28, 24);
    if (this.mode == "MULTIPLAYER" || !this.isStarted()) {
      text(this.player_scores[1], width - 58, 54);
    }
  }
  
  private void showFooter() {
    fill(255);
    
    float textY = height - 44 + 4;
    
    textAlign(LEFT, TOP);
    text(this.player_lives[0], 28, textY);
    
    textAlign(RIGHT, TOP);
    text("CREDIT  00", width - 28, textY);
    
    this.floor.fillGaps();
    this.floor.show();
    
    float xLivesBegin = 28 + 22;
    for (int i = 0; i < ((this.player_lives[0] - 1 > 3) ? 3 : this.player_lives[0] - 1); i++) {
      image(loadImage("player.png"), xLivesBegin + (i * 26) + (i * 4), textY, 26, 16); 
    }
    
    if (this.mode == "MULTIPLAYER") {
      xLivesBegin = 190;
      
      fill(255);
      textAlign(LEFT, TOP);
      text(this.player_lives[1], 170, textY);
    
      for (int i = 0; i < ((this.player_lives[1] - 1 > 3) ? 3 : this.player_lives[1] - 1); i++) {
        image(loadImage("player.png"), xLivesBegin + (i * 26) + (i * 4), textY, 26, 16); 
      }
    }
  }
  
  private void showSimplifiedFooter() {
    fill(255);
    
    float textY = height - 44 + 4;
    
    textAlign(RIGHT, TOP);
    text("CREDIT  01", width - 28, textY);
  }
  
  private void showOptions() {
    fill(255);
    
    textAlign(CENTER, TOP);
    text("PLAY", width / 2, 130);
    text("SPACE    INVADERS", width / 2, 176);
    
    text("1 PLAYER -- PRESS 1", width / 2, 238);
    text("2 PLAYERS -- PRESS 2", width / 2, 270);
    
    text("BY TOMASZ KAPCIA", width / 2, 332);
    text("INFORMATYKA    GR. G13", width / 2, 364);
    text("1 SEM.    2020/2021", width / 2, 396);
  }
  
  public void showGameOver() {
    this.showHeader();
    
    textAlign(CENTER, TOP);
    
    fill(255);
    text("GAME OVER", width / 2, 131);
    
    fill(255, 0, 0);
    text("GAME OVER", width / 2, 130);
    
    fill(255);
    text("RESTART GAME -- PRESS 1", width / 2, 238);
  }
  
  private void removeBullets() {
    for (int i = 0; i < this.enemyBullets.length; i++) {
      this.enemyBullets[i] = null;
    }
    
    for (int i = 0; i < this.player_bullets[0].length; i++) {
      this.player_bullets[0][i] = null;
    }
    
    if (this.mode == "MULTIPLAYER") {
      for (int i = 0; i < this.player_bullets[1].length; i++) {
        this.player_bullets[1][i] = null;
      }
    }
  }
  
  private void respawnPlayer(int player_num) {
    player_num--;
    this.isPaused = true;
    
    if (this.player_lives[player_num] > 0) {
      this.player_lives[player_num]--;
      this.players[player_num] = new Player();
      
      println("[Game] Respawning player " + (player_num + 1) + ". Lives left: " + this.player_lives[player_num]);
      delay(1500);
      
      this.players[player_num].show();
      this.removeBullets();
      
      delay(1500);
      this.isPaused = false;
    }
    else {
       println("[Game] PLAYER " + player_num + " IS DONE FOR!");
       this.players[player_num] = null;
       this.isPaused = false;
    }
    
    if (this.players[0] == null && this.players[1] == null) {
      println("[Game] GAME OVER!");
      this.gameOver();
    }
  }
  
  private void nextLevel() {
    this.isPaused = true;
    this.level++;
    this.player_lives[0]++;
    
    if (this.mode == "MULTIPLAYER") {
      this.player_lives[1]++; 
    }
    
    println("[Game] ADVANCING TO LEVEL " + this.level);
    delay(2000);
    
    this.setupLevel();
  }
  
  public boolean isPaused() {
    return this.isPaused; 
  }
  
  public boolean isStarted() {
    return this.isStarted; 
  }
  
  public boolean isOver() {
    return this.isOver; 
  }
  
  private void gameOver() {
    delay(2000);
    this.isOver = true;
    this.isPaused = false;
    this.isStarted = true;
  }
  
  public void start(String mode) {
    this.mode = mode;
    this.isStarted = true;
    
    this.setupLevel();
  }
  
  public void showMenu() {
    this.showHeader();
    this.showOptions();
    this.showSimplifiedFooter();
  }
  
  public String mode() {
    return this.mode; 
  }
  
  private void saveHighestScore() throws Exception {
    RandomAccessFile raf = null;
    
    try {
      raf = new RandomAccessFile(System.getProperty("user.dir") + "/space_invaders.dat", "rw");
      raf.seek(0);
      raf.writeInt(this.highestScore);
    }
    catch (Exception e) {
      println(e); 
    }
    finally {
      if (raf != null) {
        raf.close(); 
      }
    }
  }
  
  private int readHighestScore() throws Exception {
    RandomAccessFile raf = null;
    int result = 0;
    
    try {
      raf = new RandomAccessFile(System.getProperty("user.dir") + "/space_invaders.dat", "r");
      raf.seek(0);
      result = raf.readInt();
    }
    catch (Exception e) {
      println(e); 
    }
    finally {
      if (raf != null) {
        raf.close(); 
      }
    }
    
    return result;
  }
  
  private void checkPlayerBullets() {
    int max = (this.mode == "MULTIPLAYER") ? 1 : 0;
    
    for (int p = 0; p <= max; p++) {
      for (int i = 0; i < this.player_bullets[0].length; i++) {
        if (this.player_bullets[p][i] != null) {
          for (int b = 0; b < this.barriers.length; b++) {
            if (this.barriers[b].isHit(this.player_bullets[p][i])) {
              this.player_bullets[p][i].explodeFail();
              this.player_bullets[p][i] = null;
              break;
            }
          }
          
          if (this.player_bullets[p][i] != null) {
            for (int b = 0; b < this.enemyBullets.length; b++) {
              if (this.enemyBullets[b] != null && this.player_bullets[p][i].collidesWith(this.enemyBullets[b])) {
                this.player_bullets[p][i].explodeFail(true);
                this.player_bullets[p][i] = null;
                
                if (random(0, 1) > 0.2) {
                  this.enemyBullets[b] = null;
                }
                
                break;
              }
            }
          }
          else {
            continue; 
          }
          
          if (this.player_bullets[p][i] != null) {
            int pointsGained = this.plane.isHit(this.player_bullets[p][i]);
            
            if (pointsGained != 0) {
              this.player_scores[p] += pointsGained;
              println("[Game] PLAYER " + (p + 1) + " SCORE: " + this.player_scores[p]); 
              
              if (this.player_scores[p] > this.highestScore) {
                this.highestScore = this.player_scores[p];
                
                try {
                  this.saveHighestScore();
                }
                catch (Exception e) {
                  println(e); 
                }
              }
              
              this.player_bullets[p][i].explode();
              this.player_bullets[p][i] = null;
               
              continue;
            }
          }
          else {
            continue; 
          }
          
          if (this.player_bullets[p][i] != null && this.player_bullets[p][i].isOutOfBounds()) {
            this.player_bullets[p][i].explodeFail();
            this.player_bullets[p][i] = null;
            continue;
          }
          
          if (this.player_bullets[p][i] != null) {
            this.player_bullets[p][i].show();
            this.player_bullets[p][i].move();
          }
        }
      }
    }
  }
  
  private void checkEnemyBullets() {
    for (int i = 0; i < this.enemyBullets.length; i++) {
      if (this.enemyBullets[i] != null) {
        for (int b = 0; b < this.barriers.length; b++) {
          if (this.barriers[b].isHit(this.enemyBullets[i])) {
            this.enemyBullets[i].explodeFail();
            this.enemyBullets[i] = null;
            break;
          }
        }
        
        int max = (this.mode == "MULTIPLAYER") ? 1 : 0;
        for (int p = 0; p <= max; p++) {
          if (this.players[p] != null) {
            if (this.enemyBullets[i] != null && this.players[p].isHit(this.enemyBullets[i])) {
              this.isPaused = true;
              this.enemyBullets[i].explode();
              this.enemyBullets[i] = null;
              this.respawnPlayer(p + 1);
              continue;
            }
          }
          else {
            continue; 
          }
        }
        
        if (this.enemyBullets[i] != null && this.floor.isHit(this.enemyBullets[i])) {
          this.enemyBullets[i].explodeFail();
          this.enemyBullets[i] = null;
          continue;
        }
        
        if (this.enemyBullets[i] != null && this.enemyBullets[i].isOutOfBounds()) {
          this.enemyBullets[i].explodeFail();
          this.enemyBullets[i] = null;
          continue;
        }
        
        if (this.enemyBullets[i] != null) {
          this.enemyBullets[i].show();
          this.enemyBullets[i].move();
        }
      }
      else {
        if (random(0, 1) <= 0.005) {
          this.shootPlayer();
        }
      }
    } 
  }
  
  private void checkBarriers() {
    float invadersBottomY = this.plane.getLastInvaderY();
    for (int i = 0; i < barriers.length; i++) {
      if (invadersBottomY != -1 && invadersBottomY >= height - 102) {
        this.barriers[i].isDestroyedByInvaders(this.plane.getBottomInvaders());
        //this.barriers[i].isDestroyedByInvaders(this.plane.invaders);
      }
      this.barriers[i].show();
    } 
  }
  
  private void movePlayers(boolean[] player1_keys, boolean[] player2_keys) {
    if (!this.isPaused()) {
      if (player1_keys[0]) {
        this.movePlayer(1, "LEFT"); 
      }
      else if (player1_keys[1]) {
        this.movePlayer(1, "RIGHT"); 
      }
      else if (player1_keys[2]) {
        this.shootEnemies(1);
      }
      
      if (this.mode == "MULTIPLAYER") {
         if (player2_keys[0]) {
           this.movePlayer(2, "LEFT"); 
         }
         else if (player2_keys[1]) {
           this.movePlayer(2, "RIGHT"); 
         }
         else if (player2_keys[2]) {
           this.shootEnemies(2);
         }
      }
    }
  }
  
  private void movePlayer(int player_num, String dir) {
    player_num--;
    if (this.players[player_num] != null) {
      this.players[player_num].move(dir);
    }
  }
  
  private void shootEnemies(int player_num) {
    player_num--;
    if (this.players[player_num] != null) {
      for (int i = 0; i < this.player_bullets[player_num].length; i++) {
        if (this.player_bullets[player_num][i] == null) {
          this.player_bullets[player_num][i] = new Bullet(this.players[player_num].x(), this.players[player_num].y(), "PLAYER");
        }
      }
    }
  }
  
  private void shootPlayer() {
    for (int i = 0; i < this.enemyBullets.length; i++) {
      if (this.enemyBullets[i] == null) {
        println("[Enemy] Shooting the player!");
        
        Invader randomInvader = this.plane.getRandomBottomInvader();
        
        if (randomInvader != null) {
          this.enemyBullets[i] = new Bullet(randomInvader.x() + 8, randomInvader.y() + 5, "ENEMY");
        }
        
        return;
      }
    }
  }
  
  public void play(boolean[] player1_keys, boolean[] player2_keys) {
    if (this.players[0] != null || (this.mode == "MULTIPLAYER" && this.players[1] != null)) {
      if (this.players[0] != null) {
        this.players[0].show();
      }
      
      if (this.mode == "MULTIPLAYER" && this.players[1] != null) {
        this.players[1].show();
      }
    }
    else {
      this.gameOver();
      return;
    }
    
    if (this.plane.isOnBottom()) {
      this.gameOver(); 
      return;
    }
    
    if (this.plane.isEmpty()) {
      this.nextLevel();
      return;
    }
    
    this.checkPlayerBullets();
    this.checkEnemyBullets();
    this.checkBarriers();
    
    this.movePlayers(player1_keys, player2_keys);
    
    this.showHeader();
    this.showFooter();
  
    this.plane.show();
    this.plane.move();
  }
}
