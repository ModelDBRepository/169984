import numpy as np
import os
import glob

files = glob.glob("/Analysis/MSN_noDA_06_5hz.txt")
temp=range(101)
ps_y_cntl = [0]*max(temp)
count = 0
for i, file in enumerate(files):
	count = count +1
	with open(file) as f:
		data=map(float,f)
	ps=np.abs(np.fft.fft(data))**2
	freqs=np.fft.fftfreq(len(data),0.001)
	idx=np.argsort(freqs)
	for j in idx:
		for k in range(100):
			if (freqs[idx[j]]>(k-1) and freqs[idx[j]]<(k+1)):	
				if i == 0:
					print k
					ps_y_cntl[k] = ps[idx[j]]
					print ps_y_cntl[k]
				else:
					ps_y_cntl[k] += ps[idx[j]]
					print ps_y_cntl[k]

print count
np.savetxt("/Analysis/ps_MSN_cntl_01_5hz_2s_04cut.txt",ps_y_cntl)


