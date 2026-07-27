#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import re
import sys


def reverse_dico(dico):
    """Takes a dictionary object as input and outputs a version with inverted values and keys"""
    new_dico = {value: key for key, value in dico.items()}
    return new_dico


def transliterate_greek(text, dico, source_script="Greek"):
    """
    Takes a string of Greek text and returns a Latin alphabet transcription according to ISO 843 norms
    Also allows for Latin to Greek retrotransliterations by specifying source_script="Latin"
    """
    transliterated_text = []
    if source_script[0:3].lower() == "lat":
        dico = reverse_dico(dico)

    for char in text:
        transliterated_char = dico.get(char, char)
        transliterated_text.append(transliterated_char)

    transliterated_text_cln = check_capital("".join(transliterated_text))

    return transliterated_text_cln


def transliterate(text, system, dico, to_latin=True):
    """
    Takes a text and returns a transliteration of that text.
    This function takes three arguments:
    * text - The text to be transliterated
    * system - the language or writing system to base the translation on
    * dico - The dictionary (json)
    * to_latin - whether the transliteration
    """
    if system == "Greek":
        if to_latin:
            transliteration = transliterate_greek(text, dico)
        else:
            transliteration = latin2greek(text)  # Not yet implemented
        return transliteration
    else:
        raise ValueError("The language you provided is not available.")


def swap_lookalikes(input_string, source_script="Latin"):
    """
    Takes a string and replaces any Latin or Greek characters with their lookalikes in the other alphabet.
    By default, the function replaces Latin with Greek characters. Otherwise, specify source_script = "Greek"
    """
    lookalikes = {
        "A": "Α",
        "B": "Β",
        "E": "Ε",
        "H": "Η",
        "I": "Ι",
        "K": "Κ",
        "M": "Μ",
        "µ": "μ",
        "N": "Ν",
        "O": "Ο",
        "o": "ο",
        "P": "Ρ",
        "T": "Τ",
        "Y": "Υ",
        "X": "Χ",
        "Z": "Ζ"
    }
    for key, val in lookalikes.items():
        if source_script[0:3].lower() == "gre":
            input_string = input_string.replace(val, key)
        elif source_script[0:3].lower() == "lat":
            input_string = input_string.replace(key, val)
    return input_string


def hellenize_non_numerals(input_string):
    """Replaces latin Characters in a string with their Greek counterparts"""
    for item in input_string:
        pattern = re.escape(item)
        swapped_item = swap_lookalikes(item, source_script="Latin")
        # Replace only the exact matches of the identified numeral
        input_string = re.sub(pattern, swapped_item, input_string)
    return input_string


def check_capital(input_string):
    """Checks if the word contains only capital letters, in which case, digraphs should be capitalized (cf. <Ch> for <χ> becomes <CH>)"""
    pattern = re.compile(r"(Ch|Th|Ps)[^\.]")
    words = input_string.split(" ")

    for i, word in enumerate(words):
        match = pattern.search(word)
        if match:
            prefix = word[:match.start()]
            suffix = word[match.end():]
            if not prefix.islower() and not suffix.islower(): # 'not islower()' works even if pattern is at the beginning of the word
                words[i] = word.upper()

    return " ".join(words)


def main():
    with open("./v1/utilities/greek_table.json", "r") as f:
        greek_dico = json.load(f)

    for line in sys.stdin:
        data = json.loads(line)
        data["value"] = transliterate(
            data["value"], system="Greek", dico=greek_dico
        )
        sys.stdout.write(json.dumps(data, ensure_ascii=False))
        sys.stdout.write("\n")


if __name__ == "__main__":
    main()
