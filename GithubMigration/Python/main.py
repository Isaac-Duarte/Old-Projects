import json

with open("raw_data.json") as json_file:
    jsonObject = json.load(json_file)

    for key in jsonObject:
        print("[JsonProperty(PropertyName = \"" + key + "\")]\npublic string " + key + " { get; set; }\n")