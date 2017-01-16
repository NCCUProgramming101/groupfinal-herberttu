class HPBar {
  int x, y, hp, sizeX, sizeY;
  PImage img ;
  
  HPBar (int x, int y, String imgPath){
    this.x = x;
    this.y = y;
    hp = 0;
    img = loadImage(imgPath);
    sizeX = img.width;
    sizeY = img.height;
  }
  
  void display(int hp, color c, float t){
    // 顯示血條
    colorMode(RGB);
    fill(c);  // red for fighter hp bar
    if(this.hp < hp){
      if(this.hp<100){
        this.hp++;
      }
      rect(x+12*t, y+3*t, this.hp*1.95*t, 20*t);  // draw hp bar
    }else if(this.hp > hp){
      if(this.hp>0){
        this.hp--;
      }
      rect(x+12*t, y+3*t, this.hp*1.95*t, 20*t);  // draw hp bar
    }else{
      rect(x+12*t, y+3*t, this.hp*1.95*t, 20*t);  // draw hp bar
    }
    image(img, x, y, sizeX*t, sizeY*t);                       // draw hp gauge
  }
}