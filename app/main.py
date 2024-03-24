from fastapi import FastAPI
#import cv2
#import os
from .routers import welcome
app = FastAPI()



@app.get('/')
async def read_main():
    return {"msg": "Hello World"}

@app.get('/users/{user_id}')
def read_item(user_id: int):
    return {'user_id': user_id}
