// Lab02. 2D drawing
// 108061203, Célia
// Mar. 20, 2020

/*********************************************************/
/* mouse press to ease the stars                         */
/* keyboard: 's' to screenshot (.tif)                    */
/*           'p' to screenshot (.png)                    */
/*           'LEFT' and  'RIGHT' to get the stars rotate */
/*           'UP' and 'DOWN' to stop the rotation        */
/*           'BLANKSPACE' to reset canvas                */
/*********************************************************/

Star[] s;
color c1 = color(243, 244, 129);
color c2 = color(127, 221, 234);
color c3 = color(239, 204, 210);
color c0 = color(255);
int flag1 = 0;

void setup()
{
  cursor(CROSS);
  size(700, 500);
  stroke(255);
  background(249, 242, 228);
  surface.setResizable(true);

  s = new Star[20];
  for (int i = 0; i < s.length; i++) {
     s[i] = new Star(c1, random(30, width - 30), random(30, height - 30), 5, 5 + 2.5 * i); 
  }
}

void draw()
{ 
  for(int i = 0; i < s.length; i++) {
    s[i].moving();
    if (keyPressed) {
      if (key == CODED) {
        if (keyCode == RIGHT) flag1 = 1;
        if (keyCode == LEFT) flag1 = 2;
        if (keyCode == UP || keyCode == DOWN) flag1 = 0;
      }
      if (key == ' ') background(249, 242, 228);
      if (key == 's') saveFrame("movie_###.tif");
      if (key == 'p') saveFrame("shot_###.png");
    } 
    switch(flag1) {
      case 1: s[i].rot1(); break;
      case 2: s[i].rot2(); break;
      default: s[i].display();
    }
    if (mousePressed) {
      s[i].easing();
      s[i].cchange();
    }
  }
  //saveFrame("movie_###.tif");
}

void mouseReleased() {
  for (int i = 0; i < s.length; i++) 
    s[i].c = color(255); 
}

void star(float x, float y, int n, float r) // (x, y) the center, r: radius
{                                           // n: the number of points (vertex)
  int i;                                    // loop index
  float angle = 2 * PI / (n * 2);           // each angle turned
  float dx, dy;                             // displacement from origin (first point)
  
  beginShape();
  {
    for (i = 0; i < 2 * n; i++) {
      if (i % 2 == 0) {                      // even points
        dx = r * sin(angle * i);
        dy = r * (1 - cos(angle * i));
        vertex(x + dx, y - r + dy);
      } else {                               // odd points
        dx = r / 2 * sin(angle * i);
        dy = r / 2 * (1 - cos(angle * i));
        vertex(x + dx, y - r /2 + dy);
      }
    }
  }
  endShape(CLOSE);
}

class Star {
  color c;              // fill color
  int n;                // number of points
  float r;              // radius of the star
  PVector location = new PVector(0, 0);                                  // current location
  PVector v1 = new PVector(random(-1.5, 1), random(-1.1, 1.2));          // velocity
  PVector acc = new PVector(random(-0.01, 0.02), random(-0.012, 0.01));  // accelaration
  int i = 1;            // flip-flop (stoke color toggling)
  float j = 0.01;       // rotate radian (clockwise)
  float k = -0.02;      // rotate radian (counter-clockwise)
  
  
  Star (color C, float X, float Y, int N, float R) {    // constructor
    c = C;
    location.x = X;
    location.y = Y;
    n = N;
    r = R;
  }
  void display() {                                      // display stars
    fill(c);
    star(location.x, location.y, n, r);
  }

  void easing() {                                       // darg stars given mouse position
    float targetX = mouseX;
    float targetY = mouseY;
    float dx = targetX - location.x;
    float dy = targetY - location.y;
    
    location.x += dx * 0.06;
    location.y += dy * 0.06;
  }
  
  void moving() {                                        // random displacement
   if (v1.x > 5) v1.x = 1;
   if (v1.y > 5) v1.y = 1;
   v1.add(acc);                                          // v = v0 + at
   location.add(v1);                                     // x = x0 + vt
   if (location.x < r || location.x > width - r) v1.x *= random(-1.2, -0.8);
   if (location.y < r || location.y > height - r) v1.y *= random(-1.2, -0.8); 
  }                                                      // bounded in the surface
  
  void cchange() {                                       // color change
   stroke(color(random(60, 100),random(200, 255), random(200, 255)));   
   if (i > 0) c = c1;                                    // stroke color: changes randomly 
   else c = color(c0);                                   //  (somewhere between blue & green
   i *= -1;                                              // star area color toggles
  }
  void rot1() {                                          // rotate (clockwise)
    pushMatrix();
    translate(location.x, location.y);
    j += random(0.03);
    rotate(j);
    fill(c);
    star(0, 0, n, r);                                    // display
    popMatrix();
  }
    void rot2() {                                        // rotate (counter-clockwise)
    pushMatrix();
    translate(location.x, location.y);
    k -= random(0.01, 0.025);
    rotate(k);
    fill(c);
    star(0, 0, n, r);                                   // display  
    popMatrix();
  }
}
