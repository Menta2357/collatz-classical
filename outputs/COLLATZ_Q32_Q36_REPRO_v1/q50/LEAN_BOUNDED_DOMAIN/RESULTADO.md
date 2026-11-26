# Front4b · Consumidor para un dominio acotado

El dominio conserva \(\operatorname{Admitted}(N,x,j,S,B)\) completo y añade \(x\le V\), con \(N,V\) fijos para toda la inducción. Por tanto conserva la positividad y paridad, el libro físico \(N\to x\), la ventana de A2 y la racha de unos con ruptura de valoración dos.

La hipótesis del consumidor pide, sólo para cada estado de ese dominio, un pago respecto al mismo \(N\) o un segmento físico que cruce estrictamente bajo su pivote actual \(x\). El reductor del primer cruce conserva el libro desde \(N\). Si devuelve un residual \(u\), el lema de rango da \(u-N<x-N\), de donde \(u<x\). Así \(u<x\le V\) vuelve a admitirlo y permite la inducción fuerte.

La unidad depende de A2FirstCrossingFusion. Compiló en el primer intento y la auditoría separada de sus tres declaraciones encontró sólo los axiomas estándar. Las 115 huellas de los insumos se cotejaron antes y después. El productor total para dicho dominio queda pendiente. [Código Lean](Front4bBoundedProducer.lean) · [Recibo](RECIBO.json)
