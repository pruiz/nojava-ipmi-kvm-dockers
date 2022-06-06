#!/usr/bin/python

import sys
import os
import logging
import subprocess
import time


from supervisor.childutils import listener


def main(args):
    logging.basicConfig(stream=sys.stderr, level=logging.DEBUG, format='%(asctime)s %(levelname)s %(filename)s: %(message)s')
    logger = logging.getLogger("supervisord-eventlistener")
    debug_mode = True if 'DEBUG' in os.environ else False
    sleepTime = 0
    eventNames = []
    
    if 'PROCESSNAME' in os.environ:
        processNames = os.environ["PROCESSNAME"].split(';')
    else: 
        logger.critical("Set PROCESSNAME in environment!");
        exit(1)

    if 'EVENTS' in os.environ:
        eventNames = os.environ["EVENTS"].split(',')

    if 'EXECUTE' in os.environ:
        executeCommand = os.environ["EXECUTE"].split(" ")
    else:
        logger.critical("Set EXECUTE in environment!")
        exit(1)

    if 'DELAY' in os.environ:
        sleepTime = int(os.environ["DELAY"])

    while True:
        headers, body = listener.wait(sys.stdin, sys.stdout)
        body = dict([pair.split(":") for pair in body.split(" ")])

        if debug_mode: 
            logger.debug("ENV: %r", repr(os.environ))
            logger.debug("Headers: %r", repr(headers))
            logger.debug("Body: %r", repr(body))
            logger.debug("Args: %r", repr(args))

        try:
            if body["processname"] in processNames and (len(eventNames) == 0 or headers["eventname"] in eventNames):
                if debug_mode:
                    logger.debug("Process %s entered %s state...", (headers["eventname"], body["processname"]))
                time.sleep(sleepTime); 
                if debug_mode:
                    logger.debug("Execute %s after %s (sec)...", os.environ["EXECUTE"], sleepTime)
                res = subprocess.call(executeCommand, stdout=sys.stderr)
        except Exception as e:
            logger.critical("Unexpected Exception: %s", str(e))
            listener.fail(sys.stdout)
            exit(1)
        else:
            listener.ok(sys.stdout)

if __name__ == '__main__':
    main(sys.argv[1:])
