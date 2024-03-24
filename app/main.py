from fastapi import FastAPI
from .routers import welcome
app = FastAPI()
app.include_router(welcome.router)

