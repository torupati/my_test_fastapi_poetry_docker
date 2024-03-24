import time
import logging
import threading

"""
Memo:
About lock, see 
- https://docs.python.org/3.10/library/threading.html#lock-objects
- https://stackoverflow.com/questions/5185568/python-conditional-with-lock-design
"""

logger = logging.getLogger(__name__)

logger.setLevel(logging.DEBUG)
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s [%(levelname)s] %(filename)s, lines %(lineno)d. %(message)s')

class WorkerFoo(threading.Thread):
    def __init__(self):
        super(WorkerFoo, self).__init__()
        self._data = None
        self._lock = threading.Lock()
        self._exit_loop = False

    def Push(self, data):
        logger.debug("data arrived %s", data)
        with self._lock:
            self._data = data

    def exit_loop(self):
        with self._lock:
            self._exit_loop = True

    def run(self):
        logger.info("start")
        while True:
            self._lock.acquire()
            _exit_loop = False
            try:
                _exit_loop = self._exit_loop
                _local_data = self._data
                self._data = None
            finally:
                self._lock.release()
            # check exit
            if _exit_loop:
                logger.warning("exit loop")
                break
            # do som eprocessing
            if _local_data is not None:
                logger.info("data processing: %s", _local_data)
                del _local_data
            time.sleep(1)
        logger.info("lease while loop of thread.")


if __name__ == '__main__':
    th = WorkerFoo()
    th.start()
    time.sleep(3)
    th.Push([1,2,3])
    time.sleep(3)
    th.Push([4,5,6])
    th.exit_loop()
    th.join()
