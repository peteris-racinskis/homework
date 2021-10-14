#!/usr/bin/python3
import cv2
import numpy as np

def read_image(filename: str) -> np.ndarray:
    return cv2.imread(filename, cv2.IMREAD_GRAYSCALE)

def transpose(image: np.ndarray) -> np.ndarray:
    return image.T

def fft(image: np.ndarray) -> np.ndarray:
    pass

def filter(transformed_image):
    pass

img = transpose(read_image("flower.jpg"))
cv2.imshow('test1',img)
cv2.waitKey(0)
cv2.destroyAllWindows()
img2 = transpose(img)
cv2.imshow('test2',img2)
cv2.waitKey(0)
cv2.destroyAllWindows()
img.shape
x = 2 + 2
print(x)