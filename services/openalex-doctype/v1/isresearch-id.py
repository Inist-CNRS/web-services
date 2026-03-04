#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import pickle
import re
import requests
from typing import Dict
from sklearn.neighbors import KNeighborsClassifier
import os
import sys
import json


class DocumentTypeClassifierModel:

    def __init__(self,
                 model_path: str):
        """
        Constructor

        Parameters
        ----------
        model_path: str
            The path of the model
        """

        self.model_path = model_path

    def load_model(self) -> KNeighborsClassifier:
        """
        This method is used to load the model

        Returns
        -------
        dt_model : KNeighborsClassifier
            The model used for predictions
        """

        model_path = self.model_path
        model_file = open(model_path, 'rb')
        dt_model = pickle.load(model_file)

        return dt_model

    @staticmethod
    def get_label(proba: float) -> bool:
        """
        This method is used to get the label

        Parameters
        ----------
        proba: float
            The confidence score of a prediction

        Returns
        -------
        label: bool
            True if it was classified as research and False otherwise.
            Score>=0.5: research (e.g. original research article, review, clinical study)
            Score<0.5: not research (e.g. book review, abstract, editorial, paratext)
        """
        if proba >= 0.5:
            label = True  # 'research_discourse'
            return label
        else:
            label = False  # 'editorial_discourse'
            return label

    @staticmethod
    def page_counter(page_str: str) -> int:
        """
        This method calculates the page count

        Parameters
        ----------
        page_str: str
            A page string in this format: '2-4'

        Returns
        -------
        page_int: int
            The page count, e.g. 3
        """
        page_int = 1
        if '-' in str(page_str):
            try:
                page_str = re.sub(r'(\.e)[\d]*', '', page_str)
                page_str = re.sub(r'(\.)[\d]*', '', page_str)
                page_str = re.sub(r'(?<=\d)(e)(\d)*', '', page_str)
                page_str = re.sub(r'[^\d-]', '', page_str)
                page_int = int(abs(eval(page_str)))
                page_int += 1
            except:
                pass

        return page_int

    def get_prediction(self,
                       source_type: str,
                       item_type: str,
                       author_count: int,
                       has_license: bool,
                       is_referenced_by_count: int,
                       references_count: int,
                       has_funder: bool,
                       page_count: int,
                       has_abstract: bool,
                       title_word_length: int,
                       inst_count: int,
                       has_oa_url: bool,
                       is_paratext: bool,
                       issue: str) -> Dict[str, float]:
        """
        This method is used to get the prediction

        Parameters
        ----------
        source_type: str
            The source type of the OpenAlex record
        item_type: str
            The item type of the OpenAlex record
        author_count: int
            The author count of the OpenAlex record
        has_license: bool
            Whether the OpenAlex record has a license or not
        is_referenced_by_count: int
            The citation count of the OpenAlex record
        references_count: int
            The reference count of the OpenAlex record
        has_funder: bool
            Whether the OpenAlex record has funding information or not
        page_count: int
            The page count of the OpenAlex record
        has_abstract: bool
            Whether the OpenAlex record has abstract information or not
        title_word_length: int
            The title word length of the OpenAlex record
        inst_count: int
            The institution count of the OpenAlex record
        has_oa_url:
            Whether the OpenAlex record has an OA URL or not
        is_paratext:
            Whether the OpenAlex record is a paratext or not
        issue:
            The journal issue of the OpenAlex record

        Returns
        -------
        dict
            A dict containing the label and the confidence score of the prediction
        """

        dt_model = self.load_model()

        if not (source_type == 'journal' and item_type in ['article', 'review']):
            print('Not source type = "journal" or item type in ("article", "review")')
            return dict(label=None, proba=None)

        probas = dt_model.predict_proba([[int(author_count),
                                          int(has_license),
                                          int(is_referenced_by_count),
                                          int(references_count),
                                          int(has_funder),
                                          int(page_count),
                                          int(has_abstract),
                                          int(title_word_length),
                                          int(inst_count),
                                          int(has_oa_url)]])

        proba = probas[:, 1][0]

        if issue:
            issue = str(issue)
            if 'sup' in issue.lower() or 'meet' in issue.lower():
                proba = 0.0

        if is_paratext:
            proba = 0.0

        label = self.get_label(proba)

        return dict(label=label, proba=proba)

    def make_api_call(self,
                      url: str) -> Dict[str, float]:
        """
        Call the OpenAlex API and apply the classifier on the result

        Parameters
        ----------
        url: str
            URL of an OpenAlex record

        Returns
        -------
        dict
            A dict containing the label and the confidence score of the prediction
        """

        openalex_item_raw = requests.get(url)

        openalex_item = openalex_item_raw.json()

        if not isinstance(openalex_item, dict):
            print('API Call error')
            return dict(label=None, proba=None)

        source_type = None

        primary_location = openalex_item.get('primary_location')
        if primary_location:
            source = primary_location.get('source')
            if source:
                source_type = source.get('type')

        item_type = openalex_item.get('type')

        authors = openalex_item.get('authorships')
        has_license = bool(openalex_item.get('primary_location').get('license'))
        is_referenced_by_count = openalex_item.get('cited_by_count')
        references_works = openalex_item.get('referenced_works')
        has_funder = bool(openalex_item.get('funders'))
        first_page = openalex_item.get('biblio').get('first_page')
        last_page = openalex_item.get('biblio').get('last_page')
        issue = openalex_item.get('biblio').get('issue')
        is_paratext = bool(openalex_item.get('is_paratext'))
        has_abstract = bool(openalex_item.get('abstract_inverted_index'))
        title = openalex_item.get('title')
        inst_count = openalex_item.get('institutions_distinct_count')
        has_oa_url = bool(openalex_item.get('open_access').get('is_oa'))

        if authors:
            author_count = len(authors)
        else:
            author_count = 0

        if references_works:
            references_count = len(references_works)
        else:
            references_count = 0

        if first_page:
            if last_page:
                page_count = self.page_counter(str(first_page) + '-' + str(last_page))
            else:
                page_count = self.page_counter(str(first_page))
        else:
            page_count = 1

        if title:
            title_word_length = len(title.split())
        else:
            title_word_length = 0

        if not inst_count:
            inst_count = 0

        return self.get_prediction(
                source_type=source_type,
                item_type=item_type,
                author_count=author_count,
                has_license=has_license,
                is_referenced_by_count=is_referenced_by_count,
                references_count=references_count,
                has_funder=has_funder,
                page_count=page_count,
                has_abstract=has_abstract,
                title_word_length=title_word_length,
                inst_count=inst_count,
                has_oa_url=has_oa_url,
                is_paratext=is_paratext,
                issue=issue)


# WS
OPENALEX_TOKEN = os.getenv("OPENALEX_API_KEY")
model = DocumentTypeClassifierModel(model_path='v1/model.pkl')


def main():
    for line in sys.stdin:
        line = json.loads(line)
        try:
            value = line["value"]
        except KeyError:
            value = None

        if value:
            try:
                r = model.make_api_call(url=f'https://api.openalex.org/{value}?api_key={OPENALEX_TOKEN}')
                is_research_doc = r.get("label")
                confidence = r.get("proba")
                # Return the proba of being research article
                # If this proba < 0.5, returns False.
                # Then the proba of being not a research doc is 1 - proba of beging research doc
                if not is_research_doc:
                    confidence = 1-confidence
                value = {"isResearchDoc": is_research_doc, "score": confidence}
            except Exception:
                value = {"isResearchDoc": None, "score": None}

        else:
            value = {"isResearchDoc": None, "score": None}

        line["value"] = value
        sys.stdout.write(json.dumps(line))
        sys.stdout.write("\n")


if __name__ == '__main__':
    main()
