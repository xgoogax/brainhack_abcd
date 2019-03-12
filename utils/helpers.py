import numpy as np 


def normalize_data(data: np.array, standardize=True):
    means = np.mean(data, axis=0)
    stds = np.std(data, axis=0)+10e-11
    if not standardize:
        return data-means
    return (data-means)/stds

def mse(real, pred):
    print(real.shape, pred.shape)
    return np.mean(np.square(real-pred))

def run_experiment(clf, X, y, val_X, val_Y):
    clf = clf
    clf.fit(X,y)
    preds = clf.predict(val_X)
    curr_mse = mse(preds, val_Y)
    return clf,curr_mse