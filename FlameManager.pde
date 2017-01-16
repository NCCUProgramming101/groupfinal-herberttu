class FlameManager {
/*
  PImage[] flameImgs = new PImage[5];

  private int[] flameFrameCount; // 這個火焰經過幾次系統影格了 -> 被 draw 了幾次 -> 便可透過 frameRate 來轉換成畫了幾秒。
  private float[] flameX ; 
  private float[] flameY ;
  private int boomIndex = 0 ; // 現在要用哪一來儲存爆炸狀態 -> 同時也代表，我要去用 array 的第幾格存。

  private int periodFrame  ; // 每一張火焰地圖，要播放幾個 frame 


  FlameManager(int periodFrame ) { 

    this.periodFrame = periodFrame ; 
    int bufferSize = 10 ;    // bufferSize 意指，可以緩存幾個火焰，越大就越不容易有火焰突然不見的問題。

    for (int i = 0; i < 5; i++) {
      flameImgs[i] = loadImage("img/flame" + (i+1) +".png");
    }

    flameFrameCount = new int  [bufferSize]; 
    flameX          = new float[bufferSize] ; 
    flameY          = new float[bufferSize] ;

    for (int i = 0; i < flameFrameCount.length; i++) {
      flameFrameCount[i] = 9999 ;
    }
  }
*/
  int numFrames=5;
  int flameBuffer=numEnemy+2;
  int [] currentFrame = new int[flameBuffer];
  PImage [] imgFlames = new PImage[numFrames];
  int [] xFlames = new int[flameBuffer];
  int [] yFlames = new int[flameBuffer];
  boolean [] flameOn = new boolean[flameBuffer];

  FlameManager(){
    for (int i=0; i<numFrames; i++){
      imgFlames[i] = loadImage("img/flame" + (i+1) + ".png");
    }
    for (int i=0; i<flameBuffer; i++){    
      currentFrame[i] = 0;
      xFlames[i] = 0;
      yFlames[i] = 0;
      flameOn[i] = false;
    }
  }
  
  void display (int i) {
      if(flameOn[i]){
        if(frameCount % (60/10) == 0){
          if(currentFrame[i] < numFrames){
            image(imgFlames[currentFrame[i]], xFlames[i], yFlames[i]);
            currentFrame[i]++;
          }else{
            currentFrame[i] = 0;
            flameOn[i] = false;
          }
        }
      }
  }

  void add (int x, int y, int i) {
    xFlames[i] = x;
    yFlames[i] = y;
    flameOn[i] = true;
    currentFrame[i] = 0;    
  }
}