import json,ast,sys

data = []

project = ""

def format_data(json_data, project):
    nicedata = ast.literal_eval(json.dumps(json_data, indent=4, sort_keys=True))
    for i in range(len(nicedata)):
        indrow = nicedata[i]
        usersandservice = indrow['members']
        for j in range(len(usersandservice)):
            print("{},{},{}".format(project, indrow['role'], usersandservice[j]))


project = sys.argv[1]
data = sys.stdin.read()
#data = data.encode("ascii", "replace")
data = data.replace("u\'", "\"")
data = data.replace("\'", "\"")
# print(data)
json_data = json.loads(data)
format_data(json_data, project)
