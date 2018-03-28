class Data{
  
  byte[] data;
  int[] target = {0,0,0};
  
  Data(byte[] data, int label){
    target[label] = 1;
    this.data = data;
  }

}
