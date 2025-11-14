#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Pipeline to extract tortured abbreviations from suspect scientific articles.
# Developped using the following (unziped) dataset: ../Datasets/PPS/dec_2022_dataset/formatted_data.zip.
# @uthors: Alexandre Clausse, Guillaume Cabanac, Pascal Cuxac, and Cyril Labbé
# @since: 2023
# @version: 5-NOV-2025 -- Pipeline for INIST web service

# Requirements: pip3 install transformers==4.51.3 pandas==1.5.0 torch==2.7.1 accelerate==1.8.1 requests==2.32.3 beautifulsoup4==4.12.3 lxml==5.2.2
# Model download: hf download allenai/scibert_scivocab_uncased --local-dir scibert_model

# Requirements
from bs4 import BeautifulSoup
from transformers import BertTokenizer, BertModel
from transformers.utils.logging import disable_progress_bar
import pandas as pd
import torch
import requests

import os, io, re, json, gc, sys


# Class to standardize text data
class ContentProcessor:

    # Constructor (useless)
    def __init__(self) -> None:
        pass

    # Method to extract text from PDF
    def extract_text(self, pdf_fn: str) -> str:
        with io.open(pdf_fn, "rb") as fd:
            files = {"input": (pdf_fn, fd, "application/pdf")}
            try:
                response = requests.post(os.getenv("GROBID_API_URL"), files=files)
                if response.status_code == 200:
                    tei_xml = BeautifulSoup(response.text, "xml")
                    return "\n".join([e.text for e in tei_xml.findAll("p")])
                else:
                    print(
                        "Grobid API error %s" % str(response.status_code),
                        file=sys.stderr,
                    )
                    return ""
            except Exception as e:
                print("Grobid API error %s" % str(e), file=sys.stderr)
                return ""

    # Method to fix typos due to the extraction
    def fix_typos(self, content: str) -> str:

        # Removing specific characters combinations
        content = content.replace("-(", " (").replace(")-", ") ")
        content = content.replace("((", "(").replace("))", ")")
        content = content.replace("(", " (").replace(")", ") ")
        content = content.replace("/", " ")
        content = content.replace("\u2009", " ")

        # Removing special characters
        for c in [
            ".",
            '"',
            "'",
            ",",
            ":",
            "[",
            "]",
            "{",
            "}",
            "?",
            "!",
            "\\",
            "+",
            "*",
            "ʼ",
            "·",
            "•",
        ]:
            content = content.replace(c, "")
        return content

    # Method to filter abbreviations
    def filter_abbreviations(
        self, abbreviation: str, ignore_lower: bool = False
    ) -> str:

        # Ignoring anomalies such as capitalized, digit-only, lower-only, containing underscore and mono-letter abbreviation
        if not ignore_lower:
            if (
                len(abbreviation[1:-1]) > 2
                and sum(1 for e in abbreviation[1:-1] if e.isupper()) < 2
            ):
                return None
        if len(abbreviation[1:-1]) == sum(1 for e in abbreviation[1:-1] if e.isdigit()):
            return None
        if not ignore_lower:
            if sum(1 for e in abbreviation[1:-1] if e.isupper()) == 0:
                return None
        if "_" in abbreviation[1:-1]:
            return None
        if len(abbreviation[1:-1]) == 1:
            return None
        return abbreviation

    # Method to format abbreviations
    def format_abbreviation(self, abbreviation: str) -> str:

        # Removing dashes, periods and plural form
        abbreviation = abbreviation.replace("-", "").replace(".", "")
        abbreviation = (
            abbreviation[:-2] + abbreviation[-1]
            if re.search(r"\([A-Z0-9]+s\)$", abbreviation) != None
            else abbreviation
        )
        return abbreviation.strip()

    # Method to format content after abbreviations formatting
    def format_content(self, content: str) -> str:

        # Replacing dashes and underscores with whitespaces
        content = content.replace("-", " ").replace("_", " ")

        # Removing parenthesis
        return content.strip()

    # Method to format both content and extracted abbreviations
    def format_both(self, content: list, abbreviations: set) -> list:

        # For each row in content
        for i in range(len(content)):

            # Abbreviation-specific formatting
            if content[i] in abbreviations:
                content[i] = self.format_abbreviation(content[i])

            # Content-specific formatting
            else:
                content[i] = self.format_content(content[i])
        return content


# Class for BERT classifier
class BertClassifier(torch.nn.Module):

    def __init__(
        self, model: str, dropout: float, from_pretrained: bool = True
    ) -> None:
        super(BertClassifier, self).__init__()
        self.bert = BertModel.from_pretrained(
            model, local_files_only=True, torch_dtype="auto", device_map="auto"
        )
        self.dropout = torch.nn.Dropout(dropout)
        self.linear = torch.nn.Linear(in_features=768, out_features=2)
        self.relu = torch.nn.ReLU()

    # One-step model forwarding
    def forward(self, input_id: torch.Tensor, mask: torch.Tensor) -> torch.Tensor:
        output = self.bert(input_ids=input_id, attention_mask=mask)
        pooler_output = output.pooler_output
        dropout_output = self.dropout(pooler_output)
        linear_output = self.linear(dropout_output)
        final_layer = self.relu(linear_output)
        return final_layer


# Class to extract abbreviations from TXT files
class AbbreviationExtractor:

    def __init__(self, acr_regex: str, model_name: str, state_dict: str) -> None:
        self._acr_regex = acr_regex
        self._cp = ContentProcessor()
        self._labels = {0: "genuine", 1: "tortured"}
        self._state_dict = state_dict
        self._tokenizer = BertTokenizer.from_pretrained(
            model_name, local_files_only=True, device_map="auto"
        )
        self._classifier = BertClassifier(model_name, dropout=0.0)
        cuda_available = torch.cuda.is_available()
        self._device = torch.device("cuda" if cuda_available else "cpu")
        if cuda_available:
            self._classifier.load_state_dict(torch.load(state_dict, weights_only=True))
            self._classifier.to(self._device)
        else:
            self._classifier.load_state_dict(
                torch.load(state_dict, weights_only=True, map_location=self._device)
            )

    # Method to classify abbreviations
    def _classify_abbreviation(self, path: str, abbreviations: list) -> list:

        # Formatting inputs for classification
        inputs = [e.lower() for e in abbreviations]

        # Tokenizing inputs
        tok_inputs = self._tokenizer(
            inputs,
            padding="max_length",
            max_length=512,
            truncation=True,
            return_tensors="pt",
        )
        tok_inputs.to(self._device)

        # Classifying abbreviation
        with torch.no_grad():
            outputs = (
                self._classifier(tok_inputs["input_ids"], tok_inputs["attention_mask"])
                .argmax(dim=1)
                .cpu()
                .detach()
            )

        # Formatting results
        outputs = [
            {
                "Source": path,
                "Abbreviation": inputs[i],
                "X": self._labels[outputs[i].item()],
            }
            for i in range(len(outputs))
        ]
        return outputs

    # Main method to extract and classify abbreviations from TXT files
    def extract_and_classify_abbreviations(self, data: dict) -> dict:

        result = list()
        files = data

        # For each text file
        for k in files.keys():

            # Fixing typos
            content = self._cp.fix_typos(files[k])

            # Splitting content into bag of words
            split_content = [e for e in content.split(" ") if len(e) > 0]

            # Extracting abbreviations
            abbreviations = re.findall(self._acr_regex, content, flags=re.I | re.M)
            ab = abbreviations.copy()

            # Noise reduction: filtering abbreviations
            abbreviations = [
                self._cp.filter_abbreviations(e, ignore_lower=True)
                for e in abbreviations
            ]
            abbreviations = [e for e in abbreviations if e is not None]

            # Listing the extracted abbreviations
            extracted_abbreviations = list()
            for a in abbreviations:
                for i in range(len(split_content)):
                    if split_content[i] == a:
                        extracted_abbreviations.append(
                            " ".join(split_content[i - len(a) + 2 : i + 1])
                        )

            # Classifying abbreviations
            if len(abbreviations) > 0:
                result += self._classify_abbreviation(k, extracted_abbreviations)
            else:
                print(
                    "Could not find abbreviations in %s" % json.dumps(k),
                    file=sys.stderr,
                )

        # Counting, sorting and exporting the results
        result = pd.DataFrame(result).value_counts()
        result = pd.DataFrame(
            [
                list(result.index[i]) + [result.values[i]]
                for i in range(len(result.index))
            ],
            columns=["Source", "Abbreviation", "Prediction", "Count"],
        )
        result = (
            result[["Abbreviation", "Prediction", "Count"]]
            .drop_duplicates()
            .sort_values(by="Abbreviation")
        )
        return result.to_dict(orient="records")


# Main program
if __name__ == "__main__":

    gc.collect()
    disable_progress_bar()

    ae = AbbreviationExtractor(
        model_name="scibert_model",  # HuggingFace model directory
        state_dict="weights.bin",  # Model weights (.bin)
        acr_regex=r"\([\w\.?&-]{2,}\)",
    )

    for line in sys.stdin:
        data = json.loads(line)
        if "filename" in data.keys():
            content = ae._cp.extract_text(data["filename"])
            data["value"] = ae.extract_and_classify_abbreviations({"value": content})
        else:
            data["value"] = "No data to process"

        json.dump(data, sys.stdout)
        sys.stdout.write("\n")
