
import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
import nltk


def split_sentences_nltk(text):
    # Use NLTK's sentence tokenizer
    sentences = nltk.sent_tokenize(text)
    return sentences


def multilingual_tokenizer(text):
    # Use NLTK's word_tokenize to tokenize the sentence
    output = []
    tokens = nltk.word_tokenize(text)
    for token in tokens:
        if "'" in token:
            if token not in ["'", "'s", "n't", "'re"]:
                token = token.split("'")
                to_add = []
                for elt in token:
                    to_add.append(elt+"'")
                output += to_add[:-1]
                output.append(to_add[-1][:-1])
                continue
        output.append(token)
        
    return output


def remove_occurences(lt, k):
    while k in lt:
        lt.remove(k)
    return lt


def text_to_indices(words, word2idx, max_length):
    word_indices = [word2idx.get(word, word2idx["<UNK>"]) for word in words]
    # Padding: ensure words fit max_length
    padded_words = word_indices + [word2idx["<PAD>"]] * (max_length - len(word_indices))
    
    return torch.tensor(padded_words).unsqueeze(0)


def extract_entities(data, model, word2idx, idx2tag, max_length, threshold=0.8):
    output = {"PER": [], "LOC": [], "ORG": []}
    model.eval()

    for sentence in data:
        words_tensor = text_to_indices(sentence, word2idx, max_length)
        all_proba = []
        with torch.no_grad():
            predictions = model(words_tensor)
            probabilities = F.softmax(predictions, dim=2)
            
            # Get the predicted tags based on the highest probability
            _, predicted_tags = torch.max(probabilities, dim=2)

            max_prob, _ = torch.max(probabilities, dim=2)
            all_proba.append(max_prob.flatten().tolist())

        predicted_tags = predicted_tags.squeeze().cpu().numpy()
        predicted_tags = [idx2tag[tag] for tag in predicted_tags]
        all_proba = all_proba[0]
        current_entity = None
        current_tag = None

        # Process the words and their corresponding predicted tags
        for word, tag, proba in zip(sentence, predicted_tags, all_proba):
            # Pretty usual to get sequences
            if tag != "O":
                if current_entity is None:
                    current_entity = word
                    current_tag = tag
                    confidence_score = [proba]
                    continue
                if tag == current_tag:
                    current_entity += " " + word
                    confidence_score.append(proba)
                    continue
                # Here we consider the thereshold
                if np.mean(confidence_score) > threshold:
                    output[current_tag].append(current_entity)
                current_entity = None
                current_tag = None
                confidence_score = []
            else:
                if current_entity is not None:
                    # Here we consider the thereshold
                    if np.mean(confidence_score) > threshold:
                        output[current_tag].append(current_entity)
                    current_entity = None
                    confidence_score = []

        if current_entity is not None:
            if len(current_entity) < 100:
                output[current_tag].append(current_entity)

    return output


# model
class SelfAttentionLayer(nn.Module):
    def __init__(self, feature_size):
        super(SelfAttentionLayer, self).__init__()
        self.feature_size = feature_size
        # Q, K, V
        self.key = nn.Linear(feature_size, feature_size)
        self.query = nn.Linear(feature_size, feature_size)
        self.value = nn.Linear(feature_size, feature_size)

    def forward(self, x, mask=None):
        keys = self.key(x)
        queries = self.query(x)
        values = self.value(x)

        scores = torch.matmul(queries, keys.transpose(-2, -1)) / torch.sqrt(torch.tensor(self.feature_size, dtype=torch.float32))

        if mask is not None:
            scores = scores.masked_fill(mask == 0, -1e9)  # apply mask to scores
        attention_weights = F.softmax(scores, dim=-1)
        output = torch.matmul(attention_weights, values)

        return output, attention_weights
class LSTM_NER(nn.Module):
    def __init__(self, vocab_size, tagset_size, embed_dim=200, hidden_dim=256):
        super(LSTM_NER, self).__init__()
        self.hidden_dim = hidden_dim
        self.embedding = nn.Embedding(vocab_size, embed_dim)
        self.lstm = nn.LSTM(embed_dim, hidden_dim, num_layers=2, dropout=0.5, batch_first=True, bidirectional=True)
        self.attention = SelfAttentionLayer(2 * hidden_dim)
        self.fc = nn.Linear(2 * hidden_dim, tagset_size)

    def forward(self, x, mask=None):
        x = self.embedding(x)
        x, _ = self.lstm(x)
        x, _ = self.attention(x, mask)
        x = self.fc(x)
        return x
    