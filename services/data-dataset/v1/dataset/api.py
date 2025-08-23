from unidecode import unidecode
from difflib import SequenceMatcher


class API:
    def __init__(self, huggingface_api, kaggle_api, pwc_datasets):
        self.huggingface_api = huggingface_api
        self.kaggle_api = kaggle_api
        self.pwc_datasets = pwc_datasets


    def clean_dataset(self,datasets):
        rmv_words = ["corpus", "datasets", "dataset", "data sets", "data set", "collection"]
        for w in rmv_words:
            if w in datasets:
                datasets = datasets.replace(w, "")
        self.datasets = datasets.split(" and ")
    

    def request_huggingface(self):
        for dataset in self.datasets:
            if dataset.endswith(" "):
                dataset = dataset[:-1]
            best_ratio = 0
            best_link = ""
            api_res = self.huggingface_api.list_datasets(search=dataset)
            for d in api_res:
                name = d.id.split("/")[1]
                url = "https://huggingface.co/datasets/"+d.id
                ratio = SequenceMatcher(None,
                                        unidecode(dataset.lower()),
                                        unidecode(name.lower())).ratio()
                if ratio > best_ratio:
                    best_ratio = ratio
                    best_link = url
            if best_ratio > 0.70:
                return best_link
            else:
                return "None"


    def request_kaggle(self):
        for dataset in self.datasets:
            if dataset.endswith(" "):
                dataset = dataset[:-1]
            best_ratio = 0
            best_link = ""
            api_res = self.kaggle_api.dataset_list(search=dataset, sort_by="hottest")
            if len(api_res) > 0:
                # print(api_res[0])
                best_name = api_res[0].title
                best_link = api_res[0].url
                best_ratio = SequenceMatcher(None,
                                            unidecode(dataset.lower()),
                                            unidecode(best_name.lower())).ratio()
                if best_ratio > 0.7:  # or dataset in best_name:
                    return best_link
                else:
                    if len(dataset) < len(best_name):
                        for i in range(len(best_name)-len(dataset)+1):
                            sratio = SequenceMatcher(None,
                                                    unidecode(dataset.lower()),
                                                    unidecode(best_name[i:i+len(dataset)].lower())
                                                    ).ratio()
                            if sratio > 0.7:
                                return best_link
                    return "None"
            else:
                # print("No result found")
                return "None"


    def request_paper_with_code(self):
        for dataset in self.datasets:
            if dataset.endswith(" "):
                dataset = dataset[:-1]
            dic = self.pwc_datasets
            best_ratio = 0
            best_link = ""
            for name in dic:
                ratio = SequenceMatcher(None,
                                        unidecode(dataset.lower()),
                                        unidecode(name.lower())).ratio()
                if ratio > best_ratio:
                    best_ratio = ratio
                    best_link = dic[name]
            if best_ratio > 0.70:
                return best_link
            else:
                return "None"
