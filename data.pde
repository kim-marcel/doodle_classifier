class Data {
  static final int DIMENSION = 784;

  byte[][] trainingData;
  byte[][] testingData; 

  int sizeTrainingData;
  int sizeTestingData;

  Data(int sizeTrainingData, int sizeTestingData, byte[] data) {
    trainingData = new byte[sizeTrainingData][DIMENSION];
    testingData = new byte[sizeTestingData][DIMENSION];

    this.sizeTrainingData = sizeTrainingData;
    this.sizeTestingData = sizeTestingData;
    
    prepareData(data);
  }

  void prepareData(byte[] data) {
    int totalDataSize = sizeTrainingData + sizeTestingData;
    for (int i = 0; i < totalDataSize; i++) {
      int offset = i * DIMENSION;

      byte[] element = new byte[DIMENSION];
      for (int j = 0; j < DIMENSION; j++) {
        element[j] = data[j + offset];
      }

      if (i < 800) {
        trainingData[i] = element;
      } else {
        testingData[i - sizeTrainingData] = element;
      }
    }
  }
}
