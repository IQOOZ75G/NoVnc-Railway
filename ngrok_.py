import os
import time
import json
from pyngrok import ngrok
NGROK_APIKEY = os.environ.get("NGROK_APIKEY", "2OqCWfqxhtrbMNyRGDzDCwbneMV_6kCm5ZwBZca919Vi94nPp")
ngrok.set_auth_token(NGROK_APIKEY)
uri=ngrok.connect(0000, "tcp")
open("/work/noVNC/ngrok.txt", "w").write(uri.public_url)
open("/work/noVNC/ngrok.json", "w").write(json.dumps(uri.data))
while True:
    time.sleep(60*60*24)
