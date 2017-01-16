import ddf.minim.*;
 
Minim minim;
AudioPlayer fight;
AudioSample start;
AudioSample over;
AudioSample fire;
AudioSample burst;
AudioSample explode;

// OOP
Bullet       bulletArray[];
Enemy        enemyArray[];
Fighter      fighter;
Treasure     treasure;
HPBar        hpBar[];
FlameManager flame;
Bomb         bomb;
Text         note;

// set (x, y) coordinates
int xBg1 = 0, xBg2 = 640, yBg = 0;
int numEnemy = 9;
int xHp = 10, yHp = 10;

// system status
int score;
int gameState;                   // game status
int enemyWave;                   // enemy status
int count, count1;               // counter for entering auto pilot

// set speed
int speedBg = 2;

// declare variables for the images
PImage imgStart1, imgStart2, imgEnd1, imgEnd2, imgBg1, imgBg2;

// key pressed status
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

// enemy status
boolean escape = false;

// set constant
final int GAME_START = 0, GAME_RUN = 1, GAME_LOSE = 2;

// weapon status
int numShoot=5;
int numWeapon=0;

boolean spacePressed = false;

void setup (){
  size(640,480);
  minim = new Minim(this);
  // this loads mp3 from the data folder
  over = minim.loadSample("gameover.mp3");
  start = minim.loadSample("jingle2.wav");
  fire = minim.loadSample("fire.mp3", 256);
  burst = minim.loadSample("explode.mp3", 256);
  explode = minim.loadSample("explode.mp3", 256);
  fight = minim.loadFile("Holst Mars.mp3");
  start.trigger();
  initGame ();
  imgStart1 = loadImage("img/start1.png");                     // load image start1.png to variable imgStart1
  imgStart2 = loadImage("img/start2.png");                     // load image start2.png to variable imgStart2
  imgEnd1 = loadImage("img/end1.png");                         // load image end1.png to variable imgEnd1
  imgEnd2 = loadImage("img/end2.png");                         // load image end2.png to variable imgEnd2
  imgBg1 = loadImage("img/bg1.png");                           // load image bg1.png to variable imgBg1
  imgBg2 = loadImage("img/bg2.png");                           // load image bg2.png to variable imgBg2
}

void initGame () {
  gameState = GAME_START;
  enemyWave = 0;
  score = 0;
  count = 0;
  count1 = 0;
  note = new Text();
  fighter = new Fighter("img/fighter.png");
  treasure = new Treasure("img/treasure.png");
  bomb = new Bomb();
  hpBar = new HPBar[6];
  hpBar[5] = new HPBar(xHp, yHp, "img/hp.png");
  for(int i=0; i<hpBar.length-1; i++){
    hpBar[i] = new HPBar(xHp, height-20-(5-i)*hpBar[5].sizeY*3/2, "img/hp.png");
  }
  enemyArray = new Enemy[numEnemy];
  bulletArray = new Bullet[numShoot];
  escape = false;
  for(int i=0; i<numEnemy; i++){
    enemyArray[i] = new Enemy("img/enemy.png");
  }
  for(int i=0; i<5; i++){
    enemyArray[i].life = true;
  }
  flame = new FlameManager();
  frameRate(60);
  spacePressed = false;
  for(int i=0; i<numShoot; i++){
    bulletArray[i] = new Bullet("img/shoot.png");
    bulletArray[i].fire = false;
  }
}

void scoreChange(int value){
  score += value;
  note.moveTo(15, 460);
  note.display(24, 255, "Score = "+score);
}

boolean isHit(int ax, int ay, int aw, int ah, int bx, int by, int bw, int bh){
  if(ay <= by + bh && ay >= by - ah && ax <= bx + bw && ax >= bx - aw){
    return true;
  }else{
    return false;
  }
}

void draw() {
  switch(gameState){
    case GAME_START:
      gameStart();
      break;
    case GAME_RUN:
      gameRun();
      break;
    case GAME_LOSE:
      gameLose();
      break;
  }
}

void gameStart(){
  if(mouseX >= 208 && mouseX <= 452 && mouseY >= 378 && mouseY <= 412){
    image(imgStart1, 0, 0);
    if(mousePressed){
      fight.play();
      fight.loop();
      gameState = GAME_RUN;
    }    
  }else{
    image(imgStart2, 0, 0);
  }
}

void gameRun(){
  backGround();
  treasure.gain();
  treasure.display();
  bomb.gain();
  bomb.display();
  enemy();
  weapon();
  shootEnemy();
  fighter.move();
  if(fighter.hp == 0){
    flame.display(numEnemy);
    if(!flame.flameOn[numEnemy] && hpBar[5].hp == 0){
      fight.pause();
      over.trigger();
      gameState = GAME_LOSE;
    }
  }else{
    fighter.display();
  }

// Auto Pliot enable
  if(enemyWave!=4){
    if(count >= 120){
      fighter.autoAction();
    }else{
      count++;
      note.moveTo(15, 65);
      note.display(18, #00FFFF, "Manual Mode - will enter Auto Pliot in "+(float)(floor((121-count)/6)/10.0)+" sec.");
    }
    if(keyPressed){
      count = 0;
      spacePressed = false;
      note.moveTo(15, 65);
      note.display(18, #FFFFFF, "Manual Mode");
    }
  }
  
  bomb.stock();
  if(enemyWave == 3){
    for(int i=0; i<5; i++){
      if(hpBar[i].hp > 0){
        hpBar[i].display(enemyArray[i].hp, #00FF00, 0.6);
      }
    }
  }else if(enemyWave == 4 && score > 3000){
    if(hpBar[4].hp > 0){
      hpBar[4].display(enemyArray[0].hp, #00FF80, 1);
    }
  }
  hpBar[5].display(fighter.hp, #FF0000, 1);
  scoreChange(0);
}

void gameLose(){
  if(mouseX >= 206 && mouseX <= 436 && mouseY >= 308 && mouseY <= 348){
    image(imgEnd1, 0, 0);
    if(mousePressed){
      initGame ();
      fight.play();
      fight.loop();
      gameState = GAME_RUN;
    }
  }else{
    image(imgEnd2, 0, 0);
  }
}

void backGround(){
  image(imgBg1, xBg1-width, yBg, width, height);    // draw bg1
  image(imgBg2, xBg2-width, yBg, width, height);    // draw bg2
  xBg1 += speedBg;                                  // rolling background with bg1.png
  xBg2 += speedBg;                                  // rolling background with bg2.png
  xBg1 %= width*2;                                  // repeat bp1
  xBg2 %= width*2;                                  // repeat bp2
}

void enemy(){
  switch(enemyWave){
// enemy in a line
    case 0:
      if(enemyArray[0].x <= - enemyArray[0].size){
        enemyArray[0].y = floor(random(height-enemyArray[0].size));
        for(int i=0; i<5; i++){
          enemyArray[i+1].x = enemyArray[i].x - enemyArray[0].size*4/3;
          enemyArray[i+1].y = enemyArray[i].y;
        }
      }
      for(int i=0; i<5; i++){
        if(enemyArray[i].life == true){
          enemyArray[i].display();
        }
        flame.display(i);
        enemyArray[i].moveForward();
      }
      //enemyArray[0].move();
      if(enemyArray[0].x > width + enemyArray[0].size*19/3){
        for(int i=0; i<numEnemy; i++){
          enemyArray[i].x = - enemyArray[0].size;                                       // Enemy show up at original x and random y
          enemyArray[i].y = floor(random(height - enemyArray[0].size));                 // Enemy y coordinate is random at 0 to 420 = 480 - 60
          enemyArray[i].life = false;
        }        
        for(int i=0; i<5; i++){
          enemyArray[i].life = true;
        }
        enemyWave = 1;
        count1 = 0;
      }
      break;
// enemy in a slash
    case 1:
      if(enemyArray[0].x <= - enemyArray[0].size){
        enemyArray[0].y = floor(random(height-enemyArray[0].size*3));
        for(int i=0; i<5; i++){
          enemyArray[i+1].x = enemyArray[i].x - enemyArray[0].size*4/3;
          enemyArray[i+1].y = enemyArray[i].y + enemyArray[0].size/2;
        }
      }
      for(int i=0; i<5; i++){
        if(enemyArray[i].life == true){
          enemyArray[i].display();
        }
        flame.display(i);
        enemyArray[i].moveForward();
      }
      //enemyArray[0].move();
      if(enemyArray[0].x > width + enemyArray[0].size*19/3){
        for(int i=0; i<numEnemy; i++){
          enemyArray[i].x = - enemyArray[0].size;                                       // Enemy show up at original x and random y
          enemyArray[i].y = floor(random(height - enemyArray[0].size));                 // Enemy y coordinate is random at 0 to 420 = 480 - 60
          enemyArray[i].life = false;
        }
        for(int i=1; i<numEnemy; i++){
          enemyArray[i].life = true;
        }
        enemyWave = 2;
        count1 = 0;
      }
      break;
// enemy in a diamond
    case 2:
      if(enemyArray[0].x <= -enemyArray[0].size){
        enemyArray[0].y = floor(random(2*enemyArray[0].size, height-enemyArray[0].size*3));
        for(int i=0; i<numEnemy-1; i++){
          if(i<=4){
            enemyArray[i+1].x = enemyArray[0].x-abs(4+abs(i%3-floor(i/3))-2)*enemyArray[0].size;
            enemyArray[i+1].y = enemyArray[0].y+(i-2)*enemyArray[0].size;
          }else{
            enemyArray[i+1].x = enemyArray[0].x-abs(abs(i%3-floor(i/3))-2)*enemyArray[0].size;
            enemyArray[i+1].y = enemyArray[0].y+(i-6)*enemyArray[0].size;
          }
        }
      }
      for(int i =0; i<numEnemy; i++){
        if(enemyArray[i].life == true){
          enemyArray[i].display();
        }
        flame.display(i);
        enemyArray[i].moveForward();
      }
      //enemyArray[0].move();
      if(enemyArray[0].x > width + enemyArray[0].size*5){
        for(int i=0; i<numEnemy; i++){
          enemyArray[i] = new Boss();
          enemyArray[i].x = - enemyArray[0].size;                                       // Enemy show up at original x and random y
          enemyArray[i].y = floor(random(height - enemyArray[0].size));                 // Enemy y coordinate is random at 0 to 420 = 480 - 60
          enemyArray[i].life = false;
        }        
        for(int i=0; i<5; i++){
          enemyArray[i].life = true;
          // enemyArray[i].hp = 100;
          hpBar[i].display(enemyArray[i].hp, #00FF00, 0.6);
        }
        enemyWave = 3;
        count1 = 0;
      }
      break;
// Boss in a straight
    case 3:
      if(enemyArray[0].x <= - enemyArray[0].size){
        enemyArray[0].y = floor(random(height-enemyArray[0].size*19/3));
        for(int i=0; i<5; i++){
          enemyArray[i+1].x = enemyArray[i].x;
          enemyArray[i+1].y = enemyArray[i].y + enemyArray[0].size*6/5;
        }
      }
      for(int i=0; i<5; i++){
        if(enemyArray[i].life == true){
          enemyArray[i].display();
        }
        flame.display(i);
        enemyArray[i].moveForward();
      }
      //enemyArray[0].move();
      if(enemyArray[0].x > width + enemyArray[0].size){
        for(int i=0; i<5; i++){
          hpBar[i].hp = 0;
        }
        enemyArray[0] = new Carrier();
        enemyArray[0].life = true;
        enemyArray[0].x = - (enemyArray[0].size+enemyArray[0].sizeC)/2;                                // Enemy show up at original x and random y
        enemyArray[0].y = floor(random(height/4, height*3/4));                 // Enemy y coordinate is random at 0 to 420 = 480 - 60        
        for(int i=1; i<numEnemy; i++){
          enemyArray[i] = new Enemy("img/enemy.png");
          enemyArray[i].x = enemyArray[0].x;                                // Enemy show up at original x and random y
          enemyArray[i].y = enemyArray[0].y;                 // Enemy y coordinate is random at 0 to 420 = 480 - 60
          enemyArray[i].speedX = floor(random(2,7));
          enemyArray[i].speedY = floor(random(2,7));
          enemyArray[i].life = true;
        }        
        enemyWave = 4;
        count1 = 0;
      }
      break;
// Boss in a Carrier
    case 4:
    if(enemyArray[0].x <= - (enemyArray[0].size+enemyArray[0].sizeC)/2){
      enemyArray[0].hp = 100;
      hpBar[4].hp = 10;
    }
    if(enemyArray[0].hp == 0){
      enemyArray[0].x += 1;
      enemyArray[0].y += 1;
      pushMatrix();
      rotate(PI*71/36);
      enemyArray[0].display();
      popMatrix();
      colorMode(HSB);
      fill(random(0,255), 255, 255);
      noStroke();
      textSize(80);
      text("You Are Winner", 20, 240);
      if(enemyArray[0].y >= height){
        fighter.x -= fighter.keySpeed;
      }
      if(mousePressed){
        fight.pause();
        start.trigger();
        initGame();
        gameState = GAME_START;
      }
    }else{
      for(int i=0; i<numEnemy; i++){
        enemyArray[i].display();
        flame.display(i);
        enemyArray[i].move();
      }
      for(int i=0; i<numEnemy; i++){
        if(enemyArray[i].x > width + enemyArray[0].size){
          enemyArray[i].x = enemyArray[0].x;                                // Enemy show up at original x and random y
          enemyArray[i].y = enemyArray[0].y;                 // Enemy y coordinate is random at 0 to 420 = 480 - 60
          enemyArray[i].life = true;
          enemyArray[i].hp = 20;
          enemyArray[i].speedX = floor(random(2,7));
          enemyArray[i].speedY = floor(random(2,7));
        }
      }
    }
  }
  
// Enemy hit Fighter   
  for(int i=0; i<numEnemy; i++){
    enemyArray[i].hitFighter(i);
  }

}

void weapon(){
  if(spacePressed) { // detect space key 
    if(!bulletArray[numWeapon].fire){
      bulletArray[numWeapon].fire = true;
      bulletArray[numWeapon].moveTo(fighter.x+10, fighter.y+(fighter.size-bulletArray[0].sizeY)/2);
      bomb.num --;
      fire.trigger();
    }
  }
  for(int i=0; i<numShoot; i++){
    if(bulletArray[i].fire){
      bulletArray[i].action();
    }
  }
}

void shootEnemy(){
// hit Enemy
  for(int i=0; i<numShoot; i++){
    bulletArray[i].hitEnemy();
  }

// miss shot
  for(int i=0; i<numShoot; i++){
    if(bulletArray[i].x <= 0){
      bulletArray[i].fire = false;
    }
  }
}

void keyPressed() {
  if (key == CODED) { // detect special keys 
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
  if (key == 32 && bomb.num > 0){  // detect space key pressed to load weapon
    spacePressed = true;
  }
}

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
    }
  }
  if (key == 32){  // detect space key pressed to load weapon
    spacePressed = false;
    for(int i=0; i<numShoot; i++){
      if(!bulletArray[i].fire){
        numWeapon = i;
      }
    }
  }
}