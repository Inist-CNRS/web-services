#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import string
import regex as re
import sys


def reverseDico(dico):
    """Takes a dictionary object as input and outputs a version with inverted values and keys"""
    new_dico = {value: key for key, value in dico.items()}
    return new_dico


def transliterateCyrillic(text, dico, source_script="Cyrillic"):
    """
    Takes a string of Cyrillic text and returns a Latin alphabet transcription according to ISO 9 norms
    Also allows for Latin to Cyrillic retrotransliterations by specifying source_script="Latin"
    """
    transliterated_text = []
    if source_script[0:3].lower() == "lat":
        dico = reverseDico(dico)

    treated_text_numerals, _, _ = treatRomanNumerals(text)
    treated_text_nonnumerals = cyrillicizeNonNumerals(treated_text_numerals)
    text = treated_text_nonnumerals

    for char in text:
        if char not in dico:
            if (
                char in string.digits
                or char in string.punctuation
                or char in string.ascii_letters
            ):
                transliterated_char = char
            else:
                transliterated_char = char
        else:
            transliterated_char = dico.get(char, char)
        transliterated_text.append(transliterated_char)
    return "".join(transliterated_text)


def transliterate(text, system, dico, to_latin=True):
    """
    Takes a text and returns a transliteration of that text.
    This function takes three arguments:
    * text - The text to be transliterated
    * system - the language or writing system to base the translation on
    * dico - The dictionary (json)
    * to_latin - whether the transliteration
    """
    if system == "Cyrillic":
        if to_latin:
            transliteration = transliterateCyrillic(text, dico)
        else:
            transliteration = latinToCyrillic(text)  # Not yet implemented
        return transliteration
    else:
        raise ValueError("The language you provided is not available.")


def identifyRomanNumerals(input_string):
    """Identifies all Roman numerals in a text and returns a list of occurrences."""
    pattern = r"\b[CСMМ]*[XVIХІ]+\b"
    matches = re.findall(pattern, input_string)
    return matches


def swapLetterLookalikes(input_string, source_script="Latin"):
    """
    Takes a string and replaces any Latin or Cyrillic characters with their lookalikes in the other alphabet.
    By default, the function replaces Latin with Cyrillic characters. Otherwise, specify source_script = "Cyrillic"
    """
    lookalikes = {
        "A": "А",
        "a": "а",
        "B": "В",
        "E": "Е",
        "e": "е",
        "H": "Н",
        "I": "І",
        "i": "і",
        "J": "Ј",
        "j": "ј",
        "K": "К",
        "M": "М",
        "O": "О",
        "o": "о",
        "P": "Р",
        "p": "р",
        "C": "С",
        "c": "с",
        "T": "Т",
        "Y": "У",
        "X": "Х",
        "y": "у",
    }
    for key, val in lookalikes.items():
        if source_script[0:3].lower() == "cyr":
            input_string = input_string.replace(val, key)
        elif source_script[0:3].lower() == "lat":
            input_string = input_string.replace(key, val)
    return input_string


def latinizeRomanNumerals(input_string):
    """
    Takes as input a string and replaces Cyrillic Roman numerals with Latin ones.
    """
    roman_numerals = identifyRomanNumerals(input_string)
    for numeral in roman_numerals:
        pattern = re.escape(numeral)
        swapped_numeral = swapLetterLookalikes(numeral, source_script="Cyrillic")
        input_string = re.sub(pattern, swapped_numeral, input_string)

    return input_string


def identifyNonRomanNumerals(input_string):
    """Identifies all non-Roman numeral portions in a text and returns a list of occurrences."""
    pattern = r"\b[CСMМ]*[XVIХІ]+\b"

    # Use re.split to split by Roman numerals and capture the non-matching parts
    non_roman_parts = re.split(pattern, input_string)

    # Filter out any empty strings resulting from the split
    non_roman_parts = [part for part in non_roman_parts if part.strip()]

    return non_roman_parts


def cyrillicizeNonNumerals(input_string):
    """Replaces latin Characters in a string with their Cyrillic counterparts, provided that they do not occur in a segment identified as a Roman numeral"""
    non_numerals = identifyNonRomanNumerals(input_string)
    for item in non_numerals:
        pattern = re.escape(item)
        swapped_item = swapLetterLookalikes(item, source_script="Latin")
        # Replace only the exact matches of the identified numeral
        input_string = re.sub(pattern, swapped_item, input_string)
    return input_string


def treatRomanNumerals(text):
    text_contains_roman_numerals = "False"
    text_contains_cyrillic_roman_numerals = "False"
    roman_nums = identifyRomanNumerals(text)

    if len(roman_nums) >= 1:
        text_contains_roman_numerals = "True"
    if text_contains_roman_numerals == "True":
        for num in roman_nums:
            if containsCyrillicCharacters(num):
                text_contains_cyrillic_roman_numerals = "True"
                break
    text = latinizeRomanNumerals(text)
    return text, text_contains_roman_numerals, text_contains_cyrillic_roman_numerals


def containsCyrillicCharacters(input_string):
    """Determines whether a string contains Cyrillic characters"""
    pattern = r"\p{Cyrillic}"
    return bool(re.search(pattern, input_string))


def main():
    with open("./v1/utilities/cyrillic_table.json", "r") as f:
        cyrillic_dico = json.load(f)

    for line in sys.stdin:
        data = json.loads(line)
        data["value"] = transliterate(
            data["value"], system="Cyrillic", dico=cyrillic_dico
        )
        sys.stdout.write(json.dumps(data, ensure_ascii=False))
        sys.stdout.write("\n")


if __name__ == "__main__":
    main()
