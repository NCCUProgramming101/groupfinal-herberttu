class Carrier extends Boss {
  PImage imgC;
  
  Carrier(){
    super();
    imgC = loadImage("img/Moocs-element-enemy1.png");
  }
  
  void move(){
    y += speedY;
    if(y >= height*3/4 || y <= height/4){
      speedY *= -1;
    }
    if(score > 3000){
      x += speedX;
      if(x >= sizeC/2 || x <= -(sizeC+size)/2){
        speedX *= -1;
      }
    }
  }
  
  void display(){
    image(imgC, x-(sizeC-size)/2, y-(sizeC-size)/2, sizeC, sizeC);    // draw carrier
    if(life){
      image(img, x, y);
    }
  }
}