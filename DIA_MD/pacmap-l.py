import numpy as np
import pacmap
IFILE="ionosphere.arff"

def get_fit():
    with open(IFILE, 'r') as f:
        data = np.asarray(
            [[float(z) for z in y[:-3].split(",")] 
            for y in filter(lambda x: x[0] in ["0","1"],f.readlines())])

    embedding = pacmap.PaCMAP()
    fit = embedding.fit_transform(data,init="pca")
    return fit

f = get_fit()
print()
