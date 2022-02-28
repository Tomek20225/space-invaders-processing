public class EnemyPlane {
  private final int rows;
  private final int cols;
  private int invaderCount;
  private final int invaderSize;
  
  private float planeSpeed;
  private float invaderSpeed;
  private Invader[][] invaders;
  
  private float xBegin;
  private float xEnd;
  private float yBegin;
  private float yEnd;
  
  private final String startDirection;
  private String currentDirection;
  
  private UFO ufo = null;
  private final float ufoProbability;
  private final float ufoSpeed;
  
  
  public EnemyPlane(int level) {
    level--;
    
    this.rows = 5;
    this.cols = 11;
    this.invaderCount = this.rows * this.cols;
    this.invaderSize = 32;
    
    this.xBegin = (width - (this.cols * this.invaderSize)) / 2;
    this.xEnd = this.xBegin + (this.invaderSize * this.cols);
    this.yBegin = 132 + this.invaderSize * (level % 4);
    this.yEnd = this.yBegin + (this.rows * invaderSize);
    
    this.startDirection = "RIGHT";
    this.currentDirection = this.startDirection;
    
    this.planeSpeed = 4.75 + (level * 0.5);
    this.invaderSpeed = this.planeSpeed / this.invaderCount;
    this.invaders = new Invader[this.rows][this.cols];
    
    this.ufoProbability = 0.000324;
    this.ufoSpeed = 1.5;
    
    
    for (int y = 0; y < this.rows; y++) {
      for (int x = 0; x < this.cols; x++) {
        float invaderX = this.xBegin + (x * this.invaderSize);
        float invaderY = this.yBegin + (y * this.invaderSize);
        
        if (y == 0) {
          this.invaders[y][x] = new Squid(invaderX, invaderY);
        }
        else if (y == 1 || y == 2) {
          this.invaders[y][x] = new Crab(invaderX, invaderY);
        }
        else {
          this.invaders[y][x] = new Octopus(invaderX, invaderY);
        }
      }
    }
  }
  
  public float getFirstInvaderX() {
    for (int x = 0; x < this.cols; x++) {
      for (int y = this.rows - 1; y >= 0; y--) {
        if (this.invaders[y][x] != null) {
          return this.invaders[y][x].realX();
        }
      }
    }
    return -1; 
  }
  
  public float getLastInvaderX() {
    for (int x = this.cols - 1; x >= 0; x--) {
      for (int y = this.rows - 1; y >= 0; y--) {
        if (this.invaders[y][x] != null) {
          return this.invaders[y][x].realX + this.invaderSize;
        }
      }
    }
    return -1; 
  }
  
  public float getLastInvaderY() {
    Invader[] bottomInvaders = this.getBottomInvaders();
    float maxY = -1;
   
    for (int i = 0; i < bottomInvaders.length; i++) {
       if (bottomInvaders[i] != null && bottomInvaders[i].y + this.invaderSize > maxY) {
          maxY = bottomInvaders[i].y + this.invaderSize;
       }
    }
    
    return maxY;
  }
  
  public Invader[] getBottomInvaders() {
    Invader[] bottomInvaders = new Invader[this.cols];
    
    for (int x = 0; x < this.cols; x++) {
      for (int y = this.rows - 1; y >= 0; y--) {
        if (this.invaders[y][x] != null) {
          bottomInvaders[x] = this.invaders[y][x];
          break;
        }
      }
    }
    
    return bottomInvaders;
  }
  
  public Invader getRandomBottomInvader() {
    Invader[] bottomInvaders = this.getBottomInvaders();
    int bottomInvadersLeft = 0;
    
    for (int i = 0; i < bottomInvaders.length; i++) {
      if (bottomInvaders[i] != null) {
        bottomInvadersLeft++; 
      }
    }
    
    int randomInvaderIndex = floor(random(0, bottomInvadersLeft)), z = 0;

    for (int i = 0; i < bottomInvaders.length; i++) {
      if (bottomInvaders[i] != null) {
        if (z == randomInvaderIndex && bottomInvaders[i].y() < (height - 102)) {
          return bottomInvaders[i];
        }
        z++;
      }
    }
    
    return null;
  }
  
  public void show() {
    if (this.isEmpty())
      return;

    for (int y = 0; y < this.rows; y++) {
      for (int x = 0; x < this.cols; x++) {
        if (this.invaders[y][x] != null) {
          this.invaders[y][x].show();  
        }
      }
    }
    
    if (this.ufo != null) {
      this.ufo.show();
    }
  }
  
  public void move() {
    if (this.isEmpty())
      return;
    
    for (int y = 0; y < this.rows; y++) {
      for (int x = 0; x < this.cols; x++) {
        if (this.invaders[y][x] != null) {
          this.invaders[y][x].move(this.currentDirection, this.invaderSpeed);
        }
      }
    }
    
    this.xBegin = this.getFirstInvaderX();
    this.xEnd = this.getLastInvaderX();

    boolean bounced = false;
    
    if (this.xEnd >= width) {
      this.currentDirection = "LEFT";
      bounced = true;
    }
    else if (this.xBegin <= 0) {
      this.currentDirection = "RIGHT"; 
      bounced = true;
    }
    
    if (bounced) {
      this.yBegin += this.invaderSize;
      //this.yEnd = this.yBegin + (this.rows * invaderSize);
      this.yEnd = this.getLastInvaderY();
      
      for (int y = 0; y < this.rows; y++) {
        for (int x = 0; x < this.cols; x++) {
          if (this.invaders[y][x] != null) {
            this.invaders[y][x].moveDown(this.invaderSize);
          }
        }
      }
    }
    
    if (this.ufo == null) {
      if (random(0, 1) <= this.ufoProbability) {
        this.ufo = new UFO();
        println("[Game] A wild UFO appeared!");
      }
    }
    else {
      if (this.ufo.isOutOfBounds()) {
        this.ufo = null; 
      }
      else {
        this.ufo.move("RIGHT", this.ufoSpeed); 
      }
    }
  }
  
  public boolean isOnBottom() {
    return this.getLastInvaderY() > height - 88;
  }
  
  public boolean isEmpty() {
    return (this.invaderCount == 0) ? true : false;
  }
  
  public int isHit(Bullet bullet) {
    int pointsGained = 0;
    
    for (int y = 0; y < this.rows; y++) {
      for (int x = 0; x < this.cols; x++) {
        if (this.invaders[y][x] != null) {
          boolean isHitX = ((bullet.x() + bullet.width()) >= this.invaders[y][x].x() && bullet.x() <= (this.invaders[y][x].x() + this.invaders[y][x].width()));
          boolean isHitY = (bullet.y() <= (this.invaders[y][x].y() + this.invaders[y][x].height()) && bullet.y() >= this.invaders[y][x].y());
          
          if (isHitX && isHitY) {
            println("[Game] Invader " + (x + y * this.cols) + " destroyed!");
            
            pointsGained = this.invaders[y][x].getPoints();
            this.invaders[y][x] = null;
            this.invaderCount--;
            this.invaderSpeed = this.planeSpeed / this.invaderCount;
            
            return pointsGained;
          }
        }
      }
    }
    
    if (this.ufo != null) {
      boolean isUfoHitX = ((bullet.x() + bullet.width()) >= this.ufo.x() && bullet.x() <= (this.ufo.x() + this.ufo.width()));
      boolean isUfoHitY = (bullet.y() <= (this.ufo.y() + this.ufo.height()) && bullet.y() >= this.ufo.y());
    
      if (isUfoHitX && isUfoHitY) {
        println("[Game] UFO destroyed!");
        
        pointsGained = this.ufo.getPoints();
        this.ufo = null;
      }
    }
    
    return pointsGained;
  }
}
