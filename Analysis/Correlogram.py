from __future__ import print_function as _, division as _
import sys
import os
import numpy as np
from concurrent import futures
from matplotlib import pyplot as plt

def nonnancount(x):
    return (-np.isnan(x)).sum()

timetype = 'f4'
histtype = 'u4'

plotspikes=0
decimals=6
#parameters for doing the histogram
nBinsHist=2000
totalTime=2.0
binMax=1000e-3
binMin=-binMax
binWidth=(binMax-binMin)/nBinsHist
#print "binWidth:",binWidth
#bins=np.arange(binMin,binMax+binWidth,binWidth)
bins=np.linspace(binMin, binMax, nBinsHist)

isiBurstCutoff = 0.025
firstSpikeShift = 0.015

reshuffleOffset = 0.5

steadyState = 0.0 # 0.3
spikedBeforeSteadyOnly = False
minSpikeCount = 0 # 3
useFirstInHistogram = True
useLastInHistogram = True

N = 1000
#maxspikes = 20
shuffles = 5 
#bins = np.linspace(0, maxspikes, 50)

netsize1=501
netsize2=499
netsize=1000
NumPairs=0

filename = sys.argv[1] if len(sys.argv) > 1 else 'SPcell_D1_noDA_06_5hz.spikes'

if filename == 'flat':
    maxspikes = 5
    spikeTime = [sorted(np.random.rand(np.random.randint(maxspikes)) * binMax)
                 for _ in range(N)]
    filename = 'flat'

elif filename == 'flat w/ cutoff':
    meanspikes = 1200
    spikeTime = [sorted(np.random.rand(np.random.poisson(meanspikes)) * binMax)
                 for _ in range(N)]
    for i, tt in enumerate(spikeTime):
        tt = np.array(spikeTime[i])
        spikeTime[i] = [tt[0]] + list(tt[1:][np.diff(tt) > 0.004])

elif filename == 'flat with trains':
    def trains():
        meantrains = 3
        meanspikes = 1.5
        intertrainisi = 0.012
        intertrainisinoise = 0
        intertrainnoise = 0.001
        minisi = 0.004

        time = 0
        while time < binMax:
            t = np.random.exponential(binMax / meantrains)
            time += t

            n = np.random.geometric(1 / meanspikes)
            itisi = intertrainisi + np.random.randn(n) * intertrainisinoise
            isis = np.cumsum(minisi + np.random.exponential(itisi - minisi, size=n))
            times = time + isis
            yield times[(times < binMax) & (times >= 0)]
            time = times[-1]

    spikeTime = [sorted(np.hstack(trains()))
                 for _ in range(N)]

else:
    data = np.loadtxt(filename)
    filename2 = sys.argv[2] if len(sys.argv) > 2 else filename.replace('_D1_', '_D2_')
    assert filename != filename2
    data2 = np.loadtxt(filename2)
    spikeTime=[[] for _ in range(netsize)]

    for i in range(data.shape[0]):
        spikeTime[int(data[i,0]) - 1].append(data[i,1])

    for i in range(data2.shape[0]):
        spikeTime[int(data2[i,0]) - 1 + netsize1].append(data2[i,1])

    # #Removing initial delay from entire dataset to prevent initial offset from biasing shuffling
    # baseline = data[0,1]
    # #baseline = 0.062405
    # for i in range(netsize):
    #     for j in range(len(spikeTime[i])):
    #         spikeTime[i][j] = round(spikeTime[i][j]-baseline,decimals)

    #del data, data2


#spikeTimes = [np.cumsum(np.random.rand(np.random.randint(maxspikes)))
 #             for _ in range(N)]

# Calculating correlation
#for i in range(netsize):
#    freq.append(1/mean(np.diff(spikeTime[i])))

#    meanISI.append(mean(np.diff(spikeTime[i])))
#    stdISI.append(std(np.diff(spikeTime[i])))
#    for j in range(netsize):
#	if (i != j):
#		timeDiffs=list()
#		for m in spikeTime[i]:
#			for n in spikeTime[j]:
                #Only include time differences within bins, but it might not matter
#				if (abs(m-n)<binMax):
#					timeDiffs.append(m-n)

# Shuffle

T = np.empty((N, max(len(l) for l in spikeTime)), dtype=timetype)
for i, l in enumerate(spikeTime):
    T[i, :len(l)] = l
    T[i, len(l):] = np.nan
if steadyState:
    T -= steadyState
    if spikedBeforeSteadyOnly:
        T[np.nanmin(T, axis=1) > 0] = np.nan

    T[T <= 0] = np.nan
    T = np.sort(T, axis=1)

if minSpikeCount > -1:
    T = T[-np.isnan(T[:, minSpikeCount])]
    N = T.shape[0]

def shuffle_everything(T):
    dT = np.diff(T, axis=1)
    dT = np.hstack((T.T[:1].T, dT))
    dT = np.concatenate([dT[None,...] for _ in range(shuffles)])

    assert dT.shape[1] == N
    assert dT.shape[0] == shuffles

    for i in range(dT.shape[1]):
        length = nonnancount(dT[0, i])
        for s in range(shuffles):
            np.random.shuffle(dT[s, i, :length])

    newT = np.cumsum(dT, axis=2)
    print('newT.shape =', newT.shape, 'newT.dtype =', newT.dtype)
    return newT

def shuffle_bursts(T):
    dT = np.diff(T, axis=1)
    dT = np.hstack((T.T[:1].T, dT))
    dT = np.concatenate([dT[None,...] for _ in range(shuffles)])

    assert dT.shape[1] == N
    assert dT.shape[0] == shuffles

    for i in range(dT.shape[1]):
        length = nonnancount(dT[0, i])
        for s in range(shuffles):
            dt = dT[s, i, :length]
            indices = np.hstack(([0],
                                 np.where(dt > isiBurstCutoff)[0]))
            bursts = np.hstack((np.diff(indices),
                                [dt.size - indices[-1]]))
            k = np.arange(indices.size)
            np.random.shuffle(k)
            indices = indices[k]
            bursts = bursts[k]

            out = np.empty_like(dt)
            offset = 0
            for j in range(indices.size):
                c = bursts[j]
                out[offset:offset + c] = dt[indices[j]:indices[j] + c]
                offset += c
            dT[s, i, :length] = out

    newT = np.cumsum(dT, axis=2)
    print('newT.shape =', newT.shape, 'newT.dtype =', newT.dtype)
    return newT

def shuffle_everything_first_long(T):
    dT = np.diff(T, axis=1)
    dT = np.hstack((T.T[:1].T, dT))
    dT = np.concatenate([dT[None,...] for _ in range(shuffles)])
    #
    assert dT.shape[1] == N
    assert dT.shape[0] == shuffles
    #
    for i in range(dT.shape[1]):
        length = nonnancount(dT[0, i])
        any_long = (dT[0, i] > isiBurstCutoff).any()
        for s in range(shuffles):
            while True:
                np.random.shuffle(dT[s, i, :length])
                # if dT[s, i, 0] < isiBurstCutoff and T[i, 1] - T[i, 0] > isiBurstCutoff:
                if any_long and dT[s, i, 0] < isiBurstCutoff:
                    print('reshuffling', i)
                    continue
                break
    #
    newT = np.cumsum(dT, axis=2)
    print('newT.shape =', newT.shape, 'newT.dtype =', newT.dtype)
    return newT

def shuffle_everything_keep_initial(T, hedgehog_mode=False):
    dT = np.diff(T, axis=1)
    dT = np.hstack((T.T[:1].T, dT))
    dT = np.concatenate([dT[None,...] for _ in range(shuffles)])
    #
    assert dT.shape[1] == N
    assert dT.shape[0] == shuffles
    #
    for i in range(dT.shape[1]):
        length = nonnancount(dT[0, i])
        for s in range(shuffles):
            np.random.shuffle(dT[s, i, 1:length])
    #
    if hedgehog_mode:
        for s in range(shuffles):
            which = -np.isnan(dT[s, :, 0])
            initial = dT[s, which, 0]
            np.random.shuffle(initial)
            dT[s, which, 0] = initial
    #
    newT = np.cumsum(dT, axis=2)
    print('newT.shape =', newT.shape, 'newT.dtype =', newT.dtype)
    return newT

def shuffle_everything_keep_initial_gaussian_shift(T):
    dT = np.diff(T, axis=1)
    dT = np.hstack((T.T[:1].T, dT))
    dT = np.concatenate([dT[None,...] for _ in range(shuffles)])
    #
    assert dT.shape[1] == N
    assert dT.shape[0] == shuffles
    #
    for i in range(dT.shape[1]):
        length = nonnancount(dT[0, i])
        for s in range(shuffles):
            np.random.shuffle(dT[s, i, 1:length])
    #
    for s in range(shuffles):
        which = -np.isnan(dT[s, :, 0])
        dT[s, which, 0] += np.random.normal(0, firstSpikeShift, which.sum())
    #
    newT = np.cumsum(dT, axis=2)
#    newT[newT >= totalTime] -= 2 * totalTime
#    newT[newT <= totalTime] += 2 * totalTime
#    for s in range(newT.shape[0]):
#        for i in range(newT.shape[1]):
#            np.sort(newT[s, i])

    print('newT.shape =', newT.shape, 'newT.dtype =', newT.dtype)
    return newT

def shuffle_everything_twice(T):
    newT = shuffle_everything_keep_initial(T)
    newT += reshuffleOffset
    newT %= totalTime
    newT = np.sort(newT, axis=2)
    #
    dT = np.diff(newT, axis=2)
    dT = np.concatenate((newT[:, :, :1], dT), axis=2)
    for i in range(dT.shape[1]):
        length = nonnancount(dT[0, i])
        for s in range(shuffles):
            np.random.shuffle(dT[s, i, :length])
    newT = np.cumsum(dT, axis=2)
    #
    return newT

newT = shuffle_everything(T)
#newT = shuffle_bursts(T)
#newT = shuffle_everything_first_long(T)
#newT = shuffle_everything_keep_initial(T)
#newT = shuffle_everything_keep_initial_gaussian_shift(T)
#newT = shuffle_everything_twice(T)

def histogram(items, bins):
    """Count items in [[bins[0], bins[1]),
                       [bins[0], bins[1]),
                       ...
                       [bins[0], bins[1])]
    (note the asymmetry)
    """
    bins = bins[:, None]
    fitting = (items >= bins[:-1]) & (items <= bins[1:])
    sum = fitting.sum(axis=1, dtype=histtype)
    assert sum.sum() == (-np.isnan(items)).sum()
    return sum

def histogram2(items, bins):
    left, right = bins[0], bins[-1]
    step = (right - left) / bins.size
    where = (items - left) // step
    assert (where >= 0).all()
    assert (where < bins.size - 1).all()
    hist = np.zeros(bins.size - 1)
    for w in where:
        hist[w] += 1

def histogram3(items, bins):
    left, right = bins[0], bins[-1]
    step = (right - left) / bins.size
    out = np.empty_like(items, dtype=int)
    where = np.floor_divide(items - left, step, out=out)
    k = (where >= 0) & (where < bins.size-1)
    #assert (where >= 0).all()
    #assert (where < bins.size - 1).all()
    return np.bincount(where[k], minlength=bins.size - 1)

def histogram4(items, weight, bins):
    left, right = bins[0], bins[-1]
    step = (right - left) / (bins.size - 1)
    out = np.empty_like(items, dtype=int)
    where = np.floor_divide(items - left, step, out=out)
    k = (where >= 0) & (where < bins.size-1)
#    assert (where >= 0).all()
#    assert (where < bins.size - 1).all()
    return np.bincount(where[k], weight[k], minlength=bins.size - 1)

def diff_and_hist(args):
    times, i, bins = args
    diffs = times[:, None, i:i+1, :] - times[:, :, None, :]
    diffs[:, i, :, :] = np.nan
    diffs = diffs[-np.isnan(diffs)]
    return histogram3(diffs, bins)

def diff_and_hist2(args):
    times, i, bins = args
    out = np.zeros(bins.size-1)
    for j in range(times.shape[1]):
        if j != i:
            diffs = times[:, None, i:i+1, :] - times[:, j:j+1, None, :]
            diffs = diffs[-np.isnan(diffs)]
            hist = histogram3(diffs, bins)
            norm = hist.sum()
            if norm != 0:
                out += hist / norm
    return out

def diff_and_hist3(args):
    times, i, bins, weights = args
    diffs = times[:, None, i:i+1, :, None] - times[:, :, None, None, :]
    # offsets = np.random.rand(*diffs.shape[:3]) * totalTime*2 - totalTime
    # diffs += offsets[..., None, None]
    diffs[:, i, ...] = np.nan
    # diffs[diffs > totalTime] -= 2*totalTime
    # diffs[diffs < -totalTime] += 2*totalTime
    if not useFirstInHistogram:
        diffs[:, :, :, 0, :] = np.nan
        diffs[:, :, :, :, 0] = np.nan
    if not useLastInHistogram:
        raise NotImplemented

    k = -np.isnan(diffs)
    weight = np.broadcast_arrays(diffs, weights[i][:, None, None, None])[1]
    diffs = diffs[k]
    weight = weight[k]
    return histogram4(diffs, weight, bins)

numspikes = (-np.isnan(T)).sum(axis=1)
weights = 1 / (numspikes[:,None] * numspikes)
weights[np.isinf(weights)] = 0

spikers = nonnancount(T)

number_cpus = os.sysconf('SC_NPROCESSORS_ONLN')
with futures.ThreadPoolExecutor(number_cpus) as exe:
    hists = exe.map(diff_and_hist3,
                    ((newT, i, bins, weights) for i in range(N)))
    hist = np.sum((h[None, :] for h in hists), dtype=float, axis=1)[0] / N
    del hists

print(hist / shuffles)

oldT = T[None, ...]
with futures.ThreadPoolExecutor(number_cpus) as exe:
    hists = exe.map(diff_and_hist3,
                    ((oldT, i, bins, weights) for i in range(N)))
    hist_unshuffled = np.sum((h[None, :] for h in hists), dtype=float, axis=1)[0] / N
    del hists

print(hist_unshuffled)

def isi_histogram_plot(bins, **hists):
    middles = (bins[:-1] + bins[1:]) / 2
    f = plt.figure()
    f.canvas.set_window_title('isi histogram ' + filename)
    for label, hist in hists.items():
        f.gca().plot(middles, hist, label=label)
    f.gca().legend()
    f.show()
    return f

def isi_histogram_diff_plot(bins, histun, histsh):
    middles = (bins[:-1] + bins[1:]) / 2
    f = plt.figure()
    f.canvas.set_window_title('isi histogram difference ' + filename)
    ax = f.gca()
    ax.plot(middles, histun - histsh, label='unshuffled - shuffled')
    ax.legend()
    f.show()
    return f

def isi_histogram_by_number_plot(bins, T, maxspike=4, additive=False):
    middles = (bins[:-1] + bins[1:]) / 2
    f = plt.figure()
    f.canvas.set_window_title('isi histogram by number ' + filename)
    base = np.zeros_like(middles)
    for i in range(maxspike):
        spikes = T[:, i][-np.isnan(T[:, i])]
        diffs = spikes[:, None] - spikes
        for j in range(diffs.shape[0]):
            diffs[j, j] = np.nan
        hist = histogram3(diffs.ravel(), bins)
        f.gca().plot(middles, base + hist, label='spike #{} ({})'.format(i + 1, j))
        if additive:
            base += hist
    f.gca().legend()
    f.show()
    return f

def isi_histogram_triangle_diff_plot(bins, histun):
    middles = (bins[:-1] + bins[1:]) / 2
    f = plt.figure()
    f.canvas.set_window_title('isi histogram difference ' + filename)
    ax = f.gca()
    left, right = bins[(histun>0).argmax()], bins[-(histun>0).argmax()]
    total = histun.sum()
    triangle = np.maximum(np.minimum(middles - left, right - middles), 0)
    triangle *= total.sum() / triangle.sum()
    ax.plot(middles, histun - triangle, label='unshuffled - triangle')
    ax.legend()
    f.show()
    return f

def spike_ini_plot(T, first=True):
    f = plt.figure()
    if first:
        k = T[:,0].argsort()
    else:
        k = np.empty_like(T[:, 0])
        for i in range(k.size):
            tt = T[i]
            try:
                k[i] = tt[-np.isnan(tt)][-1]
            except IndexError:
                k[i] = np.nan
        k = k.argsort()
    ax = f.gca()
    dat = np.ones(T[0].shape)
    for i in range(T.shape[0]):
        ax.plot(T[k[i]], i*dat, '|')
    f.canvas.set_window_title('spike times ' + filename)
    ax.set_xlabel('time / s')
    ax.set_ylabel('first spike time order')
    ax.set_title('{} spikes'.format(spikers))
    f.show()
    return f

def isi_by_spike_number_plot(T, maxspike=4):
    f = plt.figure()
    ax = f.gca()
    dT = np.diff(T[:, :maxspike + 1], axis=1)
    for i in range(dT.shape[1]):
        x = dT[:, i]
        ax.hist(x[-np.isnan(x)], alpha=max(0.3, 1-i/30), normed=1, histtype='step', bins=200, label=str(i))
    ax.legend(loc='best')
    f.canvas.set_window_title('isi by spike number (up to {}) {}'.format(maxspike, filename))
    f.show()
    return f

def isi_plot(T, bins=200):
    f = plt.figure()
    ax = f.gca()
    dT = np.diff(T, axis=1)
    ax.hist(dT[-np.isnan(dT)], normed=1, bins=bins)
    f.canvas.set_window_title('isi ' + filename)
    f.show()
    return f

def isi_recurrence_plot(T):
    dT = np.diff(T, axis=1)
    f = plt.figure()
    ax = f.gca()
    ax.scatter(dT[:-1:2], dT[1::2], marker='.', s=1)
    f.canvas.set_window_title('isi recurrence ' + filename)
    f.show()
    return f

def isi_recurrence_plot2(T):
    dT = np.diff(T, axis=1)
    f = plt.figure()
    ax = f.gca()
    x, y = dT[:-1], dT[1:]
    k = -np.isnan(x) & -np.isnan(y)
    x, y = x[k], y[k]
    hist, binsx, binsy = np.histogram2d(x, y, bins=800, normed=True)
    im = ax.imshow(np.log(hist), interpolation='none', origin='lower',
                   extent=(binsx.min(), binsx.max(), binsy.min(), binsy.max()))
    f.colorbar(im, shrink=0.5, aspect=10)
    f.canvas.set_window_title('isi recurrence ' + filename)
    f.show()
    return f

if False:
    isi_histogram_plot(bins, shuffled=hist / shuffles, unshuffled=hist_unshuffled)
    isi_histogram_diff_plot(bins, hist_unshuffled, hist / shuffles)
    spike_ini_plot(T)
    isi_recurrence_plot2(T)
    raw_input()

hist_s = hist/shuffles
diff = hist_unshuffled - hist_s
np.savetxt("MSN_noDA_06_5hz.txt",diff)
