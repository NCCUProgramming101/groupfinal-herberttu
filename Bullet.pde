class Bullet  {
  int x, y, speed, sizeX, sizeY;
  PImage img;
  boolean fire;
  
  Bullet(String filename){
    x = 0;
    y = 0;
    speed = 7;
    img = loadImage(filename);
    sizeX = img.width;
    sizeY = img.height;
    fire = false;
  }
  
  void moveTo(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  void hitEnemy(){
    for(int i=0; i<numEnemy; i++){  
      if(isHit(x, y, sizeX, sizeY, enemyArray[i].x, enemyArray[i].y, enemyArray[0].size, enemyArray[0].size)){
        if(fire && enemyArray[i].life){
          fire = false;
          if(enemyArray[i].hp >0){
            enemyArray[i].hp -= 20;            // enemy hp lose 20%
            scoreChange(20);
            burst.trigger();
          }
          if(enemyArray[i].hp <= 0){
            flame.add(enemyArray[i].x-10, enemyArray[i].y-10, i);
            enemyArray[i].life = false;
            explode.trigger();
          }
        }
      }
    }
  }
  
  void action(){
      if(closestEnemy(this.x, this.y) != -1){
        if(enemyArray[closestEnemy(this.x, this.y)].y <= y + (sizeY-enemyArray[0].size)/2 - speed){
          moveUp();
          displayUp();
        }else if(enemyArray[closestEnemy(this.x, this.y)].y >= y + (sizeY-enemyArray[0].size)/2 + speed){
          moveDown();
          displayDown();
        }else{
          moveForward();
          display();
        }
      }else{
        moveForward();
        display();
      }
  }
  
  void moveForward(){
    x -= speed;
  }
  
  void moveUp(){
    x -= speed;
    y -= speed;
  }
  
  void moveDown(){
    x -= speed;
    y += speed;  
  }
  
  void display(){
    image(img, x, y);
  }
  
  void displayUp(){
    pushMatrix();
    translate(x, y);
    rotate(PI/6);
    image(img, 0, 0);
    popMatrix();
  }
  
  void displayDown(){
    pushMatrix();
    translate(x, y);
    rotate(PI*11/6);
    image(img, 0, 0);
    popMatrix();
  }
  
  int closestEnemy(int x, int y){
    int index=0;
    float dis=1000;
    for(int i=0; i<numEnemy; i++){
      if(enemyArray[i].x <= x+sizeX && dist(x, y, enemyArray[i].x, enemyArray[i].y)<dis && enemyArray[i].life){
        dis = dist(x, y, enemyArray[i].x, enemyArray[i].y);
        index = i;
      }
    }
    if(enemyArray[index].x <= x+sizeX && enemyArray[index].life){
      return index;
    }else{
      return -1;
    }
  }
}