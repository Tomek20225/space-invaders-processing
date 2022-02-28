public class Floor extends PieceCollection {
  public Floor(float xF, float yF, int w) {
    super(xF, yF, w / 2, 1);
    
    for (int y = 0; y < super.h; y++) {
      for (int x = 0; x < super.w; x++) {
        super.pieces[y][x] = true;
      }
    }
  }
  
  public void fillGaps() {
    for (int i = 0; i < super.pieces[0].length; i++) {
      if (i % 3 == 0) {
        super.pieces[0][i] = true; 
      }
    }
  }
}
