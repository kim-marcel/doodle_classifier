byte[] catsData;
byte[] cloudsData;
byte[] smileysData;

void setup() {
  size(280, 280);
  background(0);

  loadData();
  
  Data cat = new Data(800, 200, catsData);
  Data cloud = new Data(800, 200, catsData);
  Data smiley = new Data(800, 200, catsData);
}

void loadData() {
  catsData = loadBytes("data/cat1000.bin");
  cloudsData = loadBytes("data/cloud1000.bin");
  smileysData = loadBytes("data/smiley1000.bin");
}
