import java.util.Collections;
import java.util.*;

// Every image consists of 784 (28*28) pixels
static final int DOODLE_PIXELS = 784;
static final int SIZE_TRAINING_DATA = 800;
static final int SIZE_TESTING_DATA = 200;

static final int CAT = 0;
static final int CLOUD = 1;
static final int SMILEY = 2;

HashMap<Integer, String> doodleElements;

byte[] catsData;
byte[] cloudsData;
byte[] smileysData;

Dataset cats;
Dataset clouds;
Dataset smileys;

ArrayList<Data> trainingData;
ArrayList<Data> testingData;

NeuralNetwork nn;

int epochCounter;
double lastTestResult;

void setup() {
  size(560, 280);
  background(255);
  
  doodleElements = new HashMap<Integer, String>();
  fillMap();
  
  loadData();

  cats = new Dataset(SIZE_TRAINING_DATA, SIZE_TESTING_DATA, catsData, CAT);
  clouds = new Dataset(SIZE_TRAINING_DATA, SIZE_TESTING_DATA, cloudsData, CLOUD);
  smileys = new Dataset(SIZE_TRAINING_DATA, SIZE_TESTING_DATA, smileysData, SMILEY);

  prepareTrainingData();
  prepareTestingData();

  nn = new NeuralNetwork(DOODLE_PIXELS, 64, 3);

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
    // Reset canvas
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

  for (int i = 0; i < SIZE_TRAINING_DATA; i++) {
    trainingData.add(cats.trainingData[i]);
    trainingData.add(clouds.trainingData[i]);
    trainingData.add(smileys.trainingData[i]);
  }

  Collections.shuffle(trainingData);
}

void prepareTestingData() {
  testingData = new ArrayList<Data>();

  for (int i = 0; i < SIZE_TESTING_DATA; i++) {
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
    double[] inputs = new double[DOODLE_PIXELS];
    for (int j = 0; j < inputs.length; j++) {
      inputs[j] = ((double)(trainingData.get(i).data[j] & 0xFF)) / 255;
    }
    double[] targets = trainingData.get(i).target;

    nn.train(inputs, targets);
  }
  epochCounter++;
}

double testAll() {
  double correctGuesses = 0;

  for (int i = 0; i < testingData.size(); i++) {
    double[] inputs = new double[DOODLE_PIXELS];
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
      correctGuesses++;
    }
  }

  return (correctGuesses / testingData.size()) * 100;
}

String guessUserInput() {
  double[] inputs = new double[DOODLE_PIXELS];
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
