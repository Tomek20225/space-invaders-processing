public class Barrier extends PieceCollection {
  public Barrier(float xC, float yC) {
    super(xC, yC, 22, 16);
    
    for (int y = 0; y < super.h; y++) {
      for (int x = 0; x < super.w; x++) {
        if (y == 0 && (x < 4 || x > super.w - 4 - 1)) {
          super.pieces[y][x] = false;
          continue;
        }
        else if (y == 1 && (x < 3 || x > super.w - 3 - 1)) {
          super.pieces[y][x] = false;
          continue;
        }
        else if (y == 2 && (x < 2 || x > super.w - 2 - 1)) {
          super.pieces[y][x] = false;
          continue;
        }
        else if (y == 3 && (x < 1 || x > super.w - 1 - 1)) {
          super.pieces[y][x] = false;
          continue;
        }
        else if (y == 3 && (x < 1 || x > super.w - 1 - 1)) {
          super.pieces[y][x] = false;
          continue;
        }
        else if (y == 12 && (x > 6 && x < super.w - 6 - 1)) {
          super.pieces[y][x] = false;
          continue;
        }
        else if (y == 13 && (x > 5 && x < super.w - 5 - 1)) {
          super.pieces[y][x] = false;
          continue;
        }
        else if (y >= 14 && (x > 4 && x < super.w - 4 - 1)) {
          super.pieces[y][x] = false;
          continue;
        }
        
        super.pieces[y][x] = true;
      }
    }
  }
  
  public boolean isDestroyedByInvaders(Invader[] bottomInvaders) {
    for (int i = 0; i < bottomInvaders.length; i++) {
      if (bottomInvaders[i] != null) {
         if (this.isHit(bottomInvaders[i])) {
           return true;
         }
      }
    }
    return false;
  }
  
  public boolean isDestroyedByInvaders(Invader[][] invaders) {
    for (int y = 0; y < invaders.length; y++) {
      for (int x = 0; x < invaders[0].length; x++) {
        if (invaders[y][x] != null) {
          if (this.isHit(invaders[y][x])) {
            return true;
          }
        }
      }
    }
    return false;
  }
  
  private boolean isPieceHit(int x, int y, Invader invader) {
    if (super.pieces[y][x]) {
      float pieceX = super.x + (x * super.pxScale);
      float pieceY = super.y + (y * super.pxScale);
      boolean isPieceHitX = ((invader.x() + invader.width()) >= pieceX && invader.x() <= (pieceX + super.pxScale));
      boolean isPieceHitY = (invader.y() <= (pieceY + super.pxScale * 10) && (invader.y() + invader.height()) >= pieceY);
          
      if (isPieceHitX && isPieceHitY) {
        super.pieces[y][x] = false;
        return true;
      }
    }
    return false;
  }
  
  public boolean isHit(Invader invader) {
    if (this.isDestroyed()) {
      return false;  
    }
    
    boolean wasHit = false;
    
    for (int y = 0; y < super.h; y++) {
      for (int x = 0; x < super.w; x++) {
        if (this.isPieceHit(x, y, invader)) {
          println("[Barriers] Invader collided with a barrier!");
          wasHit = true;
        }
      }
    }
    
    return wasHit; 
  }
}
