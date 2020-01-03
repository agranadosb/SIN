load("tr3D1.gz");
[w,E,k]=perceptron(data,1000, 0.1); [E k]
save("pesos","w");