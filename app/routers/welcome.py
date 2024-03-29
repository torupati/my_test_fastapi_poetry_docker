import logging
from fastapi import APIRouter

router = APIRouter()
logger = logging.getLogger('uvicorn')

@router.get('/')
async def read_main():
    return {"msg": "Hello World"}

@router.get('/users/{user_id}')
def read_item(user_id: int):
    """_summary_

    Args:
        user_id (int): user ID

    Returns:
        _type_: _description_
    """
    return {'user_id': user_id}
