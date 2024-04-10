import csv
import pickle
import sys

# to save csv file to a pickle format
input_file = sys.argv[1]
output_file = input_file.replace('.csv', '.pickle').replace('.txt', '.pickle')

data = []

with open(input_file, 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        data.append(row[0])

with open(output_file, 'wb') as file:
    pickle.dump(data, file)
