import java.util.Collections;

byte[] catsData;
byte[] cloudsData;
byte[] smileysData;

Dataset cats;
Dataset clouds;
Dataset smileys;

ArrayList<Data> trainingData;

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

  nn = new NeuralNetwork(784, 64, 3);

  trainMultipleEpochs(1);

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
  println("Training finished");
}
