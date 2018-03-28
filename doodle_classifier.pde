import java.util.Collections;
import java.util.*;

byte[] catsData;
byte[] cloudsData;
byte[] smileysData;

Dataset cats;
Dataset clouds;
Dataset smileys;

ArrayList<Data> trainingData;
ArrayList<Data> testingData;

static final int CAT = 0;
static final int CLOUD = 1;
static final int SMILEY = 2;

HashMap<Integer, String> doodleElements;

NeuralNetwork nn;

int epochCounter;
double lastTestResult;

void setup() {
  size(560, 280);
  background(255);

  loadData();

  cats = new Dataset(800, 200, catsData, CAT);
  clouds = new Dataset(800, 200, cloudsData, CLOUD);
  smileys = new Dataset(800, 200, smileysData, SMILEY);

  prepareTrainingData();
  prepareTestingData();

  doodleElements = new HashMap<Integer, String>();
  fillMap();

  nn = new NeuralNetwork(784, 64, 3);

  epochCounter = 0;
  lastTestResult = 0;
}

void draw() {
  strokeWeight(8);
  stroke(0);
  if (mousePressed && mouseX < 280 && pmouseX < 280) {
    line(pmouseX, pmouseY, mouseX, mouseY);
  }

  // Text/ right half of canvas
  strokeWeight(0);
  stroke(255);
  rect(280, 0, 280, 280);
  fill(255);
  textSize(20);
  text("Epoch: " + epochCounter, 300, 30);
  text("Test result: " + nf((float)lastTestResult, 2, 2) + "%", 300, 70);
  text("Guess: " + guessUserInput(), 300, 110);
  fill(0);
}

void keyReleased() {
  switch (key) {
  case 'r':
    // Training
    trainOneEpoch();
    break;
  case 'e':
    // Testing
    double percentage = testAll();
    lastTestResult = percentage;
    break;
  case 'd':
    // Delete drawing
    background(255);
    break;
  }
}

void loadData() {
  catsData = loadBytes("data/cat1000.bin");
  cloudsData = loadBytes("data/cloud1000.bin");
  smileysData = loadBytes("data/smiley1000.bin");
}

void prepareTrainingData() {
  trainingData = new ArrayList<Data>();

  for (int i = 0; i < 800; i++) {
    trainingData.add(cats.trainingData[i]);
    trainingData.add(clouds.trainingData[i]);
    trainingData.add(smileys.trainingData[i]);
  }

  Collections.shuffle(trainingData);
}

void prepareTestingData() {
  testingData  = new ArrayList<Data>();

  for (int i = 0; i < 200; i++) {
    testingData.add(cats.testingData[i]);
    testingData.add(clouds.testingData[i]);
    testingData.add(smileys.testingData[i]);
  }

  Collections.shuffle(testingData);
}

void trainMultipleEpochs(int amount) {
  for (int i = 0; i < amount; i++) {
    trainOneEpoch();
  }
}

void trainOneEpoch() {
  for (int i = 0; i < trainingData.size(); i++) {
    double[] inputs = new double[784];
    for (int j = 0; j < inputs.length; j++) {
      inputs[j] = ((double)(trainingData.get(i).data[j] & 0xFF)) / 255;
    }
    double[] targets = trainingData.get(i).target;

    nn.train(inputs, targets);
  }
  epochCounter ++;
}

double testAll() {
  double correctGuesses = 0;

  for (int i = 0; i < testingData.size(); i++) {
    double[] inputs = new double[784];
    for (int j = 0; j < inputs.length; j++) {
      inputs[j] = ((double)(trainingData.get(i).data[j] & 0xFF)) / 255;
    }

    double[] guess = nn.guess(inputs);
    ArrayList<Double> result = new ArrayList<Double>();
    for (int j = 0; j < guess.length; j++) {
      result.add(guess[j]);
    }

    double m = Collections.max(result);
    int index = result.indexOf(m);

    if (index == trainingData.get(i).label) {
      correctGuesses ++;
    }
  }

  return (correctGuesses / testingData.size()) * 100;
}

String guessUserInput() {
  double[] inputs = new double[784];
  PImage img = get(0, 0, 280, 280);
  img.resize(28, 28);
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    double value = (((double)(img.pixels[i]) / 16777216) * -1);
    inputs[i] = value;
  }
  double[] guess = nn.guess(inputs);
  ArrayList<Double> result = new ArrayList<Double>();
  for (int j = 0; j < guess.length; j++) {
    result.add(guess[j]);
  }

  double m = Collections.max(result);
  int index = result.indexOf(m);

  String classification = doodleElements.get(index);
  return classification;
}

void fillMap() {
  doodleElements.put(CAT, "Cat");
  doodleElements.put(CLOUD, "Cloud");
  doodleElements.put(SMILEY, "Smiley");
}
