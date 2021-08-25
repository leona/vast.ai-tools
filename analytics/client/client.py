import sys
import settings
import os
import time
from lib.sys import log

if __name__ == '__main__':
    param = sys.argv[1]
    log("Started with action:", settings.args.action)
    
    if settings.args.action == "account":
        from crons import account
        account.run()
    elif settings.args.action == "system":
        from crons import system
        system.run()
    elif settings.args.action == "event":
        from crons import event

        event.run()
    else:
        print("None found")
