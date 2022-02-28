public class Player {
  private int x;
  private final int y;
  private final int w;
  private final int h;
  private final float speed;
  private final PImage img;
  
  public Player() {
    this.w = 26;
    this.h = 16;
    
    this.x = (width / 2) - (this.w / 2);
    this.y = height - 88;
    
    this.speed = 2.5;
    this.img = loadImage("player.png");
  }
  
  public float x() {
    return this.x;
  }
  
  public float y() {
    return this.y;
  }
  
  public void show() {
    image(this.img, this.x, this.y, this.w, this.h);
  }
  
  public void move(String dir) {
    float current_speed = (dir == "LEFT") ? -this.speed : this.speed;
    
    if (this.x + current_speed >= 0 && this.x + current_speed + this.w <= width) {
      this.x += current_speed;
    }
  }
  
  public boolean isHit(Bullet bullet) {
    boolean isPlayerHitX = ((bullet.x + bullet.w) >= this.x && bullet.x <= (this.x + this.w));
    boolean isPlayerHitY = (bullet.y <= (this.y + this.h) && (bullet.y + bullet.h) >= this.y);
    
    if (isPlayerHitX && isPlayerHitY) {
      println("[Game] Player has been destroyed!");
      return true; 
    }
    
    return false;
  }
}
