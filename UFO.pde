public class UFO extends Invader {
  public UFO() {
    super(-50, 86, 48, 21, loadImage("ufo.png"), loadImage("ufo.png"), color(51, 183, 60), 200);
  }
  
  public boolean isOutOfBounds() {
    if (super.x > width) println("[Game] UFO flew away!");
    return (super.x > width); 
  }
}
