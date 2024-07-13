import json
from utils.scrape_user import scrape_author


author = "Imane Haidar"
user_info = scrape_author(author)

with open("./samples/test.json", "w") as f:
    f.write(json.dumps(user_info))
