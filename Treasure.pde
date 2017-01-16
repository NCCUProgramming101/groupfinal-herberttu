class Treasure {
  int x, y;
  float size;
  PImage img;
  boolean enhance;
  
  Treasure(String filename){
    enhance = false;
    img = loadImage(filename);
    size = img.width;
    x = floor(random(width - size));            // treasure x coordinate
    y = floor(random(height - size));           // treasure y coordinate
  }
  
  void gain(){
    if(isHit(fighter.x, fighter.y, fighter.size, fighter.size, x, y, (int)size, (int)size)){
      if(fighter.hp > 0){
        if(enhance){
          fighter.hp += 20;                     // fighter hp gain 20%
        }else{
          fighter.hp += 10;                     // fighter hp gain 10%
        }
        if(fighter.hp >= 100){
          fighter.hp = 100;
        }
      }
      enhance = (floor(random(2)) == 0) ? true : false;
      if(enhance){
        size = img.width*1.4;
      }else{
        size = img.width;
      }
      x = floor(random(width - size));          // treasure x coordinate
      y = floor(random(height - size));         // treasure y coordinate
    }
  }
  
  void display(){
    image(img, x, y, size, size);
  }
  
}