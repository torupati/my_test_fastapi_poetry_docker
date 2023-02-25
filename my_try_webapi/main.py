from fastapi import FastAPI
import os

app = FastAPI()

@app.get('/')
async def read_main():
    return {"msg": "Hello World"}

@app.get('/users/{user_id}')
def read_item(user_id: int):
    return {'user_id': user_id}
