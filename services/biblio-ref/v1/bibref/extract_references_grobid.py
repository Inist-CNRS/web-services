import requests
import os
import sys
from lxml import etree


GROBID_URL = os.getenv("GROBID_API_URL")


def extract_references_tei(pdf_path):
    with open(pdf_path, 'rb') as pdf_file:
        files = {
            'input': (pdf_path, pdf_file, 'application/pdf')
        }
        data = {
            'includeRawCitations': '1'
        }
        try:
            response = requests.post(GROBID_URL, files=files, data=data)

            if response.status_code == 200:
                tei_xml = response.text
                return tei_xml
            else:
                sys.stderr.write(
                    f"\nError API grobid : {str(response.status_code)}\n"
                    )
                return None

        except Exception as e:
            sys.stderr.write(f"\nError with grobid : {str(e)}\n")
            return None


def extract_raw_refs(tei_xml):
    if tei_xml is None:
        return []
    root = etree.fromstring(tei_xml.encode('utf-8'))
    ns = {'tei': 'http://www.tei-c.org/ns/1.0'}

    raw_ref_elements = root.xpath(
        "//tei:note[@type='raw_reference']",
        namespaces=ns
        )

    raw_refs = [ref.text for ref in raw_ref_elements if ref.text]

    return raw_refs
