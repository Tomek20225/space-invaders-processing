public class PieceCollection {
  private float x;
  private float y;
  private int w;
  private int h;
  private final int pxScale;
  private final color fill;
  private final boolean[][] pieces;
  
  public PieceCollection(float x, float y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.pxScale = 2;
    this.fill = color(51, 183, 60);
    this.pieces = new boolean[this.h][this.w];
  }
  
  public void show() {
    fill(this.fill);
    noStroke();
    
    for (int y = 0; y < this.h * this.pxScale; y += this.pxScale) {
      for (int x = 0; x < this.w * this.pxScale; x += this.pxScale) {
        if (this.pieces[y / this.pxScale][x / this.pxScale]) {
          float pieceX = this.x + x;
          float pieceY = this.y + y;
          rect(pieceX, pieceY, this.pxScale, this.pxScale);
        }
      }
    }
  }
  
  public boolean isDestroyed() {
    for (int y = 0; y < this.h; y++) {
      for (int x = 0; x < this.w; x++) {
        if (this.pieces[y][x]) {
          return false;
        }
      }
    }
    return true;
  }
  
  private boolean isPieceHit(int x, int y, Bullet bullet) {
    if (this.pieces[y][x]) {
      float pieceX = this.x + (x * this.pxScale);
      float pieceY = this.y + (y * this.pxScale);
      boolean isPieceHitX = ((bullet.x() + bullet.width()) >= pieceX && bullet.x() <= (pieceX + this.pxScale));
      boolean isPieceHitY = (bullet.y() <= (pieceY + this.pxScale) && (bullet.y() + bullet.height()) >= pieceY);
          
      if (isPieceHitX && isPieceHitY) {
        for (int yp = y - 2; yp <= y + 2; yp++) {
          for (int xp = x - 2; xp <= x + 2; xp++) {
            if (yp >= 0 && yp < this.h && xp >= 0 && xp < this.w) {
              if (xp == x - 2 || xp == x + 2 || yp == y - 2 || yp == y + 2) {
                if (random(0, 1) >= 0.6) {
                   this.pieces[yp][xp] = false;
                }
              }
              else {
                this.pieces[yp][xp] = false;
              }
            }
          }
        }
        return true;
      }
    }
    return false;
  }
  
  public boolean isHit(Bullet bullet) {
    if (this.isDestroyed()) {
      return false;  
    }
    
    if (bullet.type() == "ENEMY") {
      for (int y = 0; y < this.h; y++) {
        for (int x = 0; x < this.w; x++) {
          if (this.isPieceHit(x, y, bullet)) {
            println("[Barriers & Floors] Piece hit by the enemy!");
            return true;
          }
        }
      }
    }
    else if (bullet.type() == "PLAYER") {
      for (int y = this.h - 1; y >= 0; y--) {
        for (int x = 0; x < this.w; x++) {
          if (this.isPieceHit(x, y, bullet)) {
            println("[Barriers & Floors] Piece hit by the player!");
            return true;
          }
        }
      }
    }
    
    return false; 
  }
}
