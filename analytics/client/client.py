import sys
import settings
from crons import account, system#, rotate
import os
import time

if __name__ == '__main__':
    account.run()
    system.run()

    while True:
        time.sleep(10)
