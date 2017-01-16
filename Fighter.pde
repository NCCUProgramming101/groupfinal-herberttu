class Fighter {
  int x,y, hp, keySpeed, size;
  PImage img;
  
  Fighter(String filename){
    keySpeed = 5;                                // set moving speed for fighter
    img = loadImage(filename);                   // load image fighter.png to variable imgFighter
    size = img.width;
    x = width - size - 10;                       // fighter x coordinate
    y = (height - size) / 2;                     // fighter y coordinate
    hp = 20;
  }
  
  void move(){
    keyDetect();
  }
  
  void display(){
    image(img, x, y);
  }
  
  void crash(){
    flame.add(x, y, numEnemy);
    flame.display(numEnemy);
  }
  
  void keyDetect(){
    if (upPressed) {
      if(y >= keySpeed){
        y -= keySpeed;
      }
    }
    if (downPressed) {
      if(y <= height - size - keySpeed){
        y += keySpeed;
      }
    }
    if (leftPressed) {
      if(x > 0 + keySpeed){
        x -= keySpeed;
      }
    }
    if (rightPressed) {
      if(x < width - size - keySpeed){
        x += keySpeed;
      }
    }
  }
  
  void autoAction(){
    if(hp==100){
      if(!isClear()){
        if(bomb.num > 0){
          if(enemyWave !=3){
            autoShot(enemyArray[0], enemyArray[count1]);
          }else{
            autoShot(enemyArray[2], enemyArray[count1]);
          }
        }else{
          spacePressed = false;
          autoPilot();
        }
      }else{
        spacePressed = false;
        if(bomb.num < 20){
          if(enemyWave !=3){
            autoGainBomb();
          }else{
            autoPilot();
          }
        }else{
          note.moveTo(15, 65);
          note.display(18, #FF00FF, "Auto Pilot - full-load power");  
        }
      }
    }else{
      autoPilot();
    }
  }
  
  void autoPilot(){
    if(enemyWave == 0){
      if(x < enemyArray[0].x+enemyArray[0].size*4 && x > enemyArray[0].x-enemyArray[0].size*16/3-size-keySpeed*2 && y < enemyArray[0].y+enemyArray[0].size+keySpeed*2 && y > enemyArray[0].y-size-keySpeed*2){
        escape = true;
        autoEscape(enemyArray[0]);
      }else if(x <= enemyArray[0].x - enemyArray[0].size*16/3 - size - keySpeed){
        escape = false;
      }
    }
    if(enemyWave == 1){
      if(x < enemyArray[0].x+enemyArray[0].size*4 && x > enemyArray[0].x-enemyArray[0].size*16/3-size-keySpeed*2 && y < enemyArray[0].y+enemyArray[0].size*3+keySpeed*2 && y > enemyArray[0].y-size-keySpeed*2){
        escape = true;
        autoEscape(enemyArray[0]);
      }else if(x <= enemyArray[0].x - enemyArray[0].size*16/3 - size - keySpeed){
        escape = false;
      }
    }
    if(enemyWave == 2){
      if(x < enemyArray[0].x+enemyArray[0].size*4 && x > enemyArray[0].x-enemyArray[0].size*4-size-keySpeed*2 && y < enemyArray[0].y+enemyArray[0].size*3+keySpeed*2 && y > enemyArray[0].y-enemyArray[0].size*2-size-keySpeed*2){
        escape = true;
        autoEscape(enemyArray[0]);
      }else if(x <= enemyArray[0].x - enemyArray[0].size*4 - size - keySpeed){
        escape = false;
      }
    }
    if(enemyWave == 3){
      for(int i=0; i<numEnemy; i++){
        if(x < enemyArray[i].x+enemyArray[0].size*3 && x > enemyArray[i].x-size*2-keySpeed*3 && y < enemyArray[i].y+enemyArray[0].size+keySpeed*2 && y > enemyArray[i].y-size-keySpeed*2){
          if(enemyArray[i].life){
            escape = true;
            // autoEscape(bossArray[i]);
            if(enemyArray[0].y > size + keySpeed){
              if(y > keySpeed){
                y -= keySpeed;
                break;
              }
            }else if(enemyArray[4].y < height - enemyArray[0].size - size - keySpeed){
              if(y < height - size - keySpeed){
                y += keySpeed;
                break;
              }
            }
          }
        }else if(x <= enemyArray[i].x - size*2 - keySpeed*2 && !enemyArray[i].life){
          escape = false;
        }
      }
    }
    if(!escape){
      if(hp < 100){
        autoGainTreasure();
      }else if(bomb.num < 20){
        fighter.autoGainBomb();
      }
      spacePressed = false;
    }else{
      note.moveTo(15, 65);
      note.display(18, #FFFF00, "Auto Pilot - Escape Mode");
    }
  }
  
  void autoShot(Enemy e, Enemy e1){
    if(x <= e.x + 3*e.size && x <= width - size - keySpeed){
      x += keySpeed-1; 
    }else if(x >= e.x + e.size*4 && x >= keySpeed){
      x -= keySpeed;
    }
    if(y <= e.y - (size - e.size)/2 - keySpeed){
      y += keySpeed;
    }else if(y >= e.y - (size - e.size)/2 + keySpeed){
      y -= keySpeed;
    }
    if(x> e.x && x <= e.x+5*e.size && e1.life && bomb.num > 0){
      spacePressed = true;
      for(int j=0; j<numShoot; j++){
        if(!bulletArray[j].fire && frameCount % (60/5) == 0){
          numWeapon = j;
        }
      }
    }else{
      count1++;
      count1 %= numEnemy;
      spacePressed = false;
    }
    note.moveTo(15, 65);
    note.display(18, #FF0000, "Auto Pilot - Battle Mode");
  }
  
  void autoGainTreasure(){
    if(y >= treasure.y + treasure.size){
      y -= keySpeed;
    }else if(y <= treasure.y - size){
      y += keySpeed;
    }
    if(x >= treasure.x + treasure.size){
      x -= keySpeed;
    }else if(x <= treasure.x - size){
      x += keySpeed-1;
    }
    note.moveTo(15, 65);
    note.display(18, #00FF00, "Auto Pilot - Gain Treasure Mode");
  }
  
  void autoGainBomb(){
    if(y >= bomb.y + bomb.size){
      y -= keySpeed;
    }else if(y <= bomb.y - size){
      y += keySpeed;
    }
    if(x >= bomb.x + bomb.size){
      x -= keySpeed;
    }else if(x <= bomb.x - size){
      x += keySpeed-1;
    }
    note.moveTo(15, 65);
    note.display(18, #0000FF, "Auto Pilot - Gain Bomb Mode");
  }
  
  void autoEscape(Enemy e){
    if(y >= e.y + (e.size-size)/2 && e.y + e.size*3 + size + keySpeed*2 <= height){
      if(y <= height - size - keySpeed){
        y += keySpeed;
      }
      if(x >= keySpeed){
        x -= keySpeed;
      }
    }else if(y >= e.y + (e.size-size)/2 && e.y + e.size*3 + size + keySpeed*2 > height){
      if(y >= keySpeed){
        y -= keySpeed;
      }
      if(x <= width - size - keySpeed){
        x += keySpeed;
      }
    }else if(y < e.y + (e.size-size)/2 && e.y - e.size*2 - size - keySpeed*2 >= 0){
      if(y >= keySpeed){
        y -= keySpeed;
      }
      if(x >= keySpeed){
        x -= keySpeed;
      }
    }else if(y < e.y + (e.size-size)/2 && e.y - e.size*2 - size - keySpeed*2 < 0){
      if(y <= height - size - keySpeed){
        y += keySpeed;
      }
      if(x <= width - size - keySpeed){
        x += keySpeed;
      }
    }
  }
  
  boolean isClear(){
    for(int i=0; i<numEnemy; i++){
      if(enemyArray[i].life){
        return false;
      }
    }
    return true;
  }
}