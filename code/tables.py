import pandas as pd
import numpy as np
import glob, os
import matplotlib.pyplot as plt
import time

subjects = ['S01','S02','S03','S04','S05']
errD = {}

for subject in subjects:
  d={}
  cnt=0
  for file in glob.glob("../dataset/"+subject+"*.jpeg"):
    cnt+=1
    #print(file)
    if not d:
      d={str(cnt): file}
    else:
      d[str(cnt)]=file
  
  print len(d)
  print d['1']
  print d['6200']
  
  d1 = pd.read_csv('exp1-'+subject+'-OutTe.csv', index_col=0, header=None)
  d2 = pd.read_csv('exp1-'+subject+'-OutVa.csv', index_col=0, header=None)
  df = pd.concat([d1, d2])
  
  #print df.describe()
  #print df.head()
  
  outDf = df.ix[:,1:31]
  tarDf = df.ix[:,32:62]
  tarDf.columns = [x for x in range(1,32)]
  
  difDf = outDf - tarDf
  
  #print outDf.head()
  #print tarDf.head()
  #print difDf.head()
  
  errDf = difDf.abs()
  errDf = errDf.sum(axis=1)

  print errDf.head()
  print errDf.describe()
  print errDf.sort_values()

  #plt.figure()
  #errDf.sort_values().plot(use_index=False)
  #plt.show()
  #print errDf.idxmax()
  #print errDf.idxmin()
  
  #print d[str(errDf.idxmax())]
  #print d[str(errDf.idxmin())]
  
  tarIdxDf = tarDf.idxmax(axis=1)
  outIdxDf = outDf.idxmax(axis=1)
  
  #print tarIdxDf.head()
  #print outIdxDf.head()
  
  for x in range(0, tarIdxDf.shape[0]):
    if not tarIdxDf.iloc[[x]].equals(outIdxDf.iloc[[x]]):
      tmpT = tarIdxDf.iloc[[x]]
      tmpO = outIdxDf.iloc[[x]]
      idx = tmpT.index.tolist()[0]
      #print errDf[idx]
      tmpE = errDf[tmpT.index.tolist()[0]]
      #print tmpE
      #print type(tmpE)
      if isinstance(tmpE, pd.Series):
        #print "careful!!!"
        tmpE = tmpE.drop_duplicates()
        tmpE = tmpE.tolist()[0]

      #print tmpE
      #print tmpO
      file = d[str(tmpT.index.tolist()[0])][11:-5]
      #print file
      data = [tmpT.tolist()[0], tmpO.tolist()[0], tmpE]
      #print data
      #time.sleep(0.1)
      if not errD:
        errD={str(file): data}
      else:
        errD[str(file)]=data
  
  print errD

errorsDf = pd.DataFrame.from_dict(errD, orient='index')
errorsDf.columns = ['target', 'predicted','error']
errorsDf['target'].replace(2,'2/V', inplace=True)
errorsDf['target'].replace(6,'6/W', inplace=True)
errorsDf['target'].replace(10,'A', inplace=True)
errorsDf['target'].replace(11,'B', inplace=True)
errorsDf['target'].replace(14,'E', inplace=True)
errorsDf['target'].replace(15,'F', inplace=True)
errorsDf['target'].replace(16,'G', inplace=True)
errorsDf['target'].replace(17,'H', inplace=True)
errorsDf['target'].replace(18,'I', inplace=True)
errorsDf['target'].replace(19,'K', inplace=True)
errorsDf['target'].replace(21,'M', inplace=True)
errorsDf['target'].replace(22,'N', inplace=True)
errorsDf['target'].replace(23,'O', inplace=True)
errorsDf['target'].replace(26,'R', inplace=True)
errorsDf['target'].replace(27,'S', inplace=True)
errorsDf['target'].replace(28,'T', inplace=True)
errorsDf['target'].replace(30,'X', inplace=True)

errorsDf['predicted'].replace(2,'2/V', inplace=True)
errorsDf['predicted'].replace(6,'6/W', inplace=True)
errorsDf['predicted'].replace(10,'A', inplace=True)
errorsDf['predicted'].replace(11,'B', inplace=True)
errorsDf['predicted'].replace(12,'C', inplace=True)
errorsDf['predicted'].replace(14,'E', inplace=True)
errorsDf['predicted'].replace(17,'H', inplace=True)
errorsDf['predicted'].replace(18,'I', inplace=True)
errorsDf['predicted'].replace(21,'M', inplace=True)
errorsDf['predicted'].replace(22,'N', inplace=True)
errorsDf['predicted'].replace(23,'O', inplace=True)
errorsDf['predicted'].replace(24,'P', inplace=True)
errorsDf['predicted'].replace(26,'R', inplace=True)
errorsDf['predicted'].replace(27,'S', inplace=True)
errorsDf['predicted'].replace(28,'T', inplace=True)
errorsDf['predicted'].replace(29,'U', inplace=True)
errorsDf['predicted'].replace(30,'X', inplace=True)
errorsDf['predicted'].replace(31,'Y', inplace=True)


#print errorsDf
errorsDf['file name'] = errorsDf.index
errorsDf['subject']=errorsDf['file name'].str[0:3]
errorsDf.reset_index(drop=True, inplace=True)
print errorsDf.head()
print errorsDf.describe()
errorsDf.to_csv('errors.csv')






