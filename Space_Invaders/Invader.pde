public class Invader {
  private int x;
  private float realX;
  private float y;
  private final int w;
  private final int h;
  private final PImage img0;
  private final PImage img1;
  private int state;
  private final int pxDiff;
  private final color fill;
  private final int points;
  
  public Invader(float x, float y, int w, int h, PImage img0, PImage img1, color fill, int points) {
    this.realX = x;
    this.x = floor(x);
    this.y = y;
    this.w = w;
    this.h = h;
    this.img0 = img0;
    this.img1 = img1;
    this.fill = fill;
    this.state = 0;
    this.pxDiff = 2;
    this.points = points;
  }
  
  public float x() {
    return this.x; 
  }
  
  public float realX() {
    return this.realX; 
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
  
  public int getPoints() {
    return this.points; 
  }
  
  public void switchState() {
    this.state = (this.state == 0) ? 1 : 0;
  }
  
  public void show() {
    PImage currentImage = (this.state == 0) ? this.img0 : this.img1;
    image(currentImage, this.x, this.y, this.w, this.h);
  }
  
  public void move(String dir, float speed) {
    speed = (dir == "LEFT") ? -speed : speed;
    this.realX += speed;
    
    int prevX = this.x;
    int newX = floor(this.realX);
    
    if (abs(newX - prevX) >= pxDiff) {
      this.x = newX;
      this.switchState();
    }
  }
  
  public void moveDown(int dist) {
    this.y += dist; 
  }
}
