// Put all the other classes here

class Text{
  int x, y;
  
  Text(){
    x = 0;
    y = 0;
  }
  
  void moveTo(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  void display(int size, color c, String s){
    textSize(size);
    fill(c);
    text(s, x, y);
  }

}

class Bomb extends Treasure {
  int num;
  
  Bomb(){
    super("img/Moocs-element-gainbomb.png");
    size = 41;
    num = 5;
    x = floor(random(width - size));          // treasure x coordinate
    y = floor(random(height - size));         // treasure y coordinate
  }
  
  void gain(){
    if(isHit(fighter.x, fighter.y, fighter.size, fighter.size, x, y, (int)size, (int)size)){
      if(enhance){
        num += 20;                     // fighter gain full of bombs
      }else{
        num += 5;                      // fighter gain 5 bombs
      }
      if(num >= 20){
        num = 20;
      }
      enhance = (floor(random(5)) == 0) ? true : false;
      if(enhance){
        size = img.width*1.4;
      }else{
        size = img.width;
      }
      x = floor(random(width - size));          // treasure x coordinate
      y = floor(random(height - size));         // treasure y coordinate
    }
  }
  
  void stock(){
    for (int i = 0; i < num; i++) {
      image(bulletArray[0].img, 230 + 40 * (i % 10), 25 * floor((i / 10)), bulletArray[0].sizeX, bulletArray[0].sizeY);  // draw weapon
    }
  }
  
}