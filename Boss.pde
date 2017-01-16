class Boss extends Enemy {
  Boss(){
    super("img/boss.png");
    speedX = 1;
    speedY = 1;
    hp = 100;
  }
  
  void hitFighter(int i){
    if(isHit(fighter.x, fighter.y, fighter.size, fighter.size, x, y, size, size)){
      if(life && fighter.hp >0){
        hp = 0;
        fighter.hp -= 50;                   // fighter hp lose 50%
        if(fighter.hp <= 0){
          fighter.hp = 0;
          flame.add(fighter.x, fighter.y, numEnemy);
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