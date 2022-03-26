import numpy as np
import tensorflow as tf
from tensorflow.keras import layers, optimizers, losses, activations, regularizers
import pickle
IFILE = "data/notMNIST-nodup.pickle"
OUTFILE = "model_weights.bin"
image_size = 28
num_labels = 10
np.random.seed(133)
tf.random.set_seed(133)


def reformat(dataset, labels):
    dataset = dataset.reshape((-1, image_size * image_size)).astype(np.float32)
    labels = (np.arange(num_labels) == labels[:, None]).astype(np.float32)
    return dataset, labels


if __name__ == "__main__":
    tf.get_logger().setLevel('INFO')
    with open(IFILE, 'rb') as f:
        save = pickle.load(f)
        train_dataset = save['train_dataset']
        train_labels = save['train_labels']
        valid_dataset = save['valid_dataset']
        valid_labels = save['valid_labels']
        test_dataset = save['test_dataset']
        test_labels = save['test_labels']
        del save  # hint to help gc free up memory
    print('Training set', train_dataset.shape, train_labels.shape)
    print('Validation set', valid_dataset.shape, valid_labels.shape)
    print('Test set', test_dataset.shape, test_labels.shape)
    train_dataset, train_labels = reformat(train_dataset, train_labels)
    valid_dataset, valid_labels = reformat(valid_dataset, valid_labels)
    test_dataset, test_labels = reformat(test_dataset, test_labels)

    stop_condition = tf.keras.callbacks.EarlyStopping(
        monitor='val_loss', patience=10)

    model = tf.keras.Sequential([
        layers.Dense(4096, activation=activations.relu,
                     kernel_regularizer=regularizers.l2(0.001)),
        layers.Dropout(0.5),
        layers.Dense(4096, activation=activations.relu,
                     kernel_regularizer=regularizers.l2(0.001)),
        layers.Dropout(0.5),
        layers.Dense(train_labels[0].size, activation=None),
        layers.Softmax()
    ])

    model.compile(
        optimizer=optimizers.Adam(learning_rate=0.0001),
        loss=losses.CategoricalCrossentropy(),
        metrics=['accuracy']
    )
    print("------- WARNINGS MOSTLY END HERE --------")
    print("------- WARNINGS MOSTLY END HERE --------")
    print("------- WARNINGS MOSTLY END HERE --------")
    print("Train-time validation using test dataset")
    history = model.fit(
        train_dataset,
        train_labels,
        batch_size=8192,
        epochs=1000,
        validation_data=(valid_dataset, valid_labels),
        validation_freq=1,
        verbose=2,
        callbacks=[stop_condition]
    )
    print("Test-time accuracy using validation dataset")
    val_loss, val_acc = model.evaluate(valid_dataset, valid_labels, verbose=2)
    print("Test-time accuracy using test dataset")
    val_loss, val_acc = model.evaluate(test_dataset, test_labels, verbose=2)
    model.save_weights(OUTFILE)
