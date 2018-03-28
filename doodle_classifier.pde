import java.util.Collections;

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

NeuralNetwork nn;

void setup() {
  size(280, 280);
  background(0);

  loadData();

  cats = new Dataset(800, 200, catsData, CAT);
  clouds = new Dataset(800, 200, cloudsData, CLOUD);
  smileys = new Dataset(800, 200, smileysData, SMILEY);

  prepareTrainingData();
  prepareTestingData();

  nn = new NeuralNetwork(784, 64, 3);

  trainMultipleEpochs(5);
  double percentage = testAll();

  println("% correct: " + percentage);

  System.exit(0);
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
    println("Epoch: " + (i + 1));
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
    for (int j = 0; j < guess.length; j++){
      result.add(guess[j]);
    }
    
    double m = Collections.max(result);
    int index = result.indexOf(m);
    
    if(index == trainingData.get(i).label){
      correctGuesses ++;
    }
  }
  
  return (correctGuesses / testingData.size()) * 100;
}
