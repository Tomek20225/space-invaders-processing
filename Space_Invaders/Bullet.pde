public class Bullet {
  private float x;
  private float y;
  private final int w;
  private final int h;
  private final String type;
  private final float playerBulletSpeed;
  private final float enemyBulletSpeed;
  private int state;
  private final PImage img;
  private final PImage imgFail;
  private final PImage imgSuccess;
  private final color[] fills;
  private boolean outOfBounds;
  
  public Bullet(float x, float y, String type) {
    this.x = x;
    this.y = y;
    this.w = 2;
    this.h = 7;
    this.type = type;
    this.playerBulletSpeed = 7;
    this.enemyBulletSpeed = 3.5;
    this.state = 0;
    this.img = loadImage("bullet.png");
    this.imgFail = loadImage("fire.png");
    this.imgSuccess = loadImage("explosion.png");
    this.fills = new color[]{color(51, 183, 60), color(255), color(212, 20, 0)};
    this.outOfBounds = false;
    
    if (this.type == "PLAYER") {
      this.x += 12;
    }
  }
  
  public float x() {
    return this.x; 
  }
  
  public float y() {
    return this.y; 
  }
  
  public float width() {
    return this.w; 
  }
  
  public float height() {
    return this.h; 
  }
  
  public String type() {
    return this.type; 
  }
  
  public void explode()  {
    if (this.type == "PLAYER") {
      image(imgSuccess, this.x - 12, this.y - 12, 26, 16);
    }
    else if (this.type == "ENEMY") {
      image(imgSuccess, this.x, this.y, 26, 16);
    }
  }
  
  public void explodeFail()  {
     if (this.type == "PLAYER") {
       image(imgFail, this.x, this.y, 30, 16);
     }
     else if (this.type == "ENEMY") {
       image(imgFail, this.x, this.y - 16, 30, 16);
     }
  }
  
  public void explodeFail(boolean collided)  {
     if (this.type == "PLAYER") {
       image(imgFail, this.x, this.y, 30, 16);
     }
     else if (collided || this.type == "ENEMY") {
       image(imgFail, this.x, this.y - 16, 30, 16);
     }
  }
  
  public void show() {
     noStroke();
    
     if (this.y < 128) {
       fill(this.fills[2]); 
     }
     else if (this.y >= 128 && this.y < height - 102) {
       fill(this.fills[1]); 
     }
     else {
       fill(this.fills[0]); 
     }
     
     if (!this.isOutOfBounds()) {
       if (this.type == "PLAYER") {
         rect(this.x, this.y, this.w, this.h);
       }
       else if (this.type == "ENEMY") {
         rect(this.x, this.y, this.w, this.h);
         rect(this.x - 2, this.y + floor(this.h / 2) - 1, this.w + 4, 2);
       }
     }
  }
  
  public void move() {
    if (this.type == "PLAYER") {
      this.y -= this.playerBulletSpeed;
      
      if (this.y < 80) {
        this.outOfBounds = true;
      }
    }
    else if (this.type == "ENEMY") {
      this.y += this.enemyBulletSpeed;
      
      if (this.y > height - 44) {
        this.outOfBounds = true;
      }
    }
  }
  
  public boolean collidesWith(Bullet bullet) {
    boolean isBulletHitX = ((bullet.x + bullet.w) >= this.x && bullet.x <= (this.x + this.w));
    boolean isBulletHitY = (bullet.y <= (this.y + this.h) && (bullet.y + bullet.h) >= this.y);
    
    if (isBulletHitX && isBulletHitY) {
      println("[Game] Enemy and player bullets collided!");
      return true; 
    }
    
    return false;
  }
  
  public boolean isOutOfBounds() {
    return outOfBounds;
  }
}
