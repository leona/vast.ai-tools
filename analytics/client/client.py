import sys
import settings
import os
import time

if __name__ == '__main__':
    param = sys.argv[1]

    if param == "account":
        from crons import account
        account.run()
    elif param == "system":
        from crons import system
        system.run()
    else:
        from crons import account, system
        print("None found")
