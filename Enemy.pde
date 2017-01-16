class Enemy  {
  int x, y, speedX, speedY, size, sizeC, hp;
  PImage img;
  boolean life, track;
  
  Enemy(String filename){
    speedX = 4;
    speedY = 4;
    life = false;
    img = loadImage(filename);
    size = img.width;
    sizeC = 300;
    x = - size;
    y = 0;
    hp = 20;
  }
  
  void move(){
    moveForward();
    if(dist(fighter.x, fighter.y, x, y) <= 500){
      if(fighter.x > x){  // enemy2 track fighter y location
        if(y >= fighter.y + (fighter.size - size)/2 + speedY && y > speedY){
          y -= speedY*(1-(fighter.x-x)/width);
          track = true;
        }else if(y <= fighter.y + (fighter.size - size)/2 - speedY && y < height - size - speedY){
         y += speedY*(1-(fighter.x-x)/width);
          track = false;
        }
      }else{
        if(track){  // enemy2 loss tracking with fighter
          y -= speedY*(1-(fighter.x-x)/width);
        }else{
          y += speedY*(1-(fighter.x-x)/width);
        }
      }
    }
  }
  
  void moveForward(){
      x += speedX;
  }
  
  void display(){
    if(life){
      image(img, x, y);
    }
  }
  
  void hitFighter(int i){
    if(isHit(fighter.x, fighter.y, fighter.size, fighter.size, x, y, size, size)){
      if(life && fighter.hp >0){
        fighter.hp -= 20;                   // fighter hp lose 20%
        if(fighter.hp <= 0){
          fighter.hp = 0;
          flame.add(fighter.x-15, fighter.y-15, numEnemy);
          explode.trigger();
        }
        life = false;
        flame.add(x, y, i);
        burst.trigger();
      }
      escape = false;
    }
  }

}