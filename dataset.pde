class Dataset {
  // Every image consists of 784 (28*28) pixels
  static final int DOODLE_PIXELS = 784;

  Data[] trainingData;
  Data[] testingData; 

  int sizeTrainingData;
  int sizeTestingData;

  int label;

  Dataset(int sizeTrainingData, int sizeTestingData, byte[] data, int label) {
    trainingData = new Data[sizeTrainingData];
    testingData = new Data[sizeTestingData];

    this.sizeTrainingData = sizeTrainingData;
    this.sizeTestingData = sizeTestingData;

    this.label = label;
    
    prepareData(data);
  }
  
  Dataset(int sizeTrainingData, int sizeTestingData) {
    trainingData = new Data[sizeTrainingData];
    testingData = new Data[sizeTestingData];

    this.sizeTrainingData = sizeTrainingData;
    this.sizeTestingData = sizeTestingData;
  }

  void prepareData(byte[] data) {
    int totalDataSize = sizeTrainingData + sizeTestingData;
    for (int i = 0; i < totalDataSize; i++) {
      int offset = i * DOODLE_PIXELS;

      byte[] element = new byte[DOODLE_PIXELS];
      for (int j = 0; j < DOODLE_PIXELS; j++) {
        element[j] = data[j + offset];
      }

      if (i < sizeTrainingData) {
        trainingData[i] = new Data(element, label);
      } else {
        testingData[i - sizeTrainingData] = new Data(element, label);
      }
    }
  }
}
