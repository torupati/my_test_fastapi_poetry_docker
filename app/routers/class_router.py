from fastapi import APIRouter, File, Request
from app.processors.backside_worker import WorkerFoo
import logging



logger = logging.getLogger('uvicorn')

class RouterToWorker(object):
    def __init__(self):
        self._var = 100
        self._worker = WorkerFoo()
        self.router = APIRouter()
        self.router.add_api_route('/worker/push_file', self.push_file, methods=['Post'])

        # start backend worker thread
        self._worker.start()

    async def push_file(self, file:bytes=File(...)):
        _byte_data = file
        self._worker.Push(_byte_data)
        return {'status': 'OK'}
