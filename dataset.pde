class Dataset {
  static final int DIMENSION = 784;

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
      int offset = i * DIMENSION;

      byte[] element = new byte[DIMENSION];
      for (int j = 0; j < DIMENSION; j++) {
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
