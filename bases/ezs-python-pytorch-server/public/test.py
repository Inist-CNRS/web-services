#!/usr/bin/env python
import json
import sys
import torch
import torch.nn as nn

sys.stdout.write('{"torch_version": "' + torch.__version__ + '"}\n')


class TestModel(nn.Module):
    def __init__(self):
        super(TestModel, self).__init__()
        self.fc = nn.Linear(2, 1)

    def forward(self, x):
        return self.fc(x)


model = TestModel()

input_tensor = torch.tensor([[1.0, 2.0]])

output = model(input_tensor)

sys.stdout.write('{"torch_input": "' + str(input_tensor.numpy().tolist()) + '"}\n')
sys.stdout.write('{"torch_output": "' + str(output.detach().numpy().tolist()) + '"}\n')

# sys.stdout.write(json.dumps(input_tensor.numpy().tolist()))
# sys.stdout.write(json.dumps(output.numpy().tolist()))
