from utilities import telegram_request

res = telegram_request("/getUpdates")

if len(res['result']) == 0:
    print(res, "Failed. Have you sent /start yet?")
    exit()

chat_id = res['result'][0]['message']['chat']['id']
print(chat_id)
