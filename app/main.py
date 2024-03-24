from fastapi import FastAPI
from .routers import welcome
from .routers import class_router

app = FastAPI()
app.include_router(welcome.router)

router_to_worker = class_router.RouterToWorker()
app.include_router(router_to_worker.router)
