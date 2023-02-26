from fastapi.testclient import TestClient

from my_try_webapi.main import app

client = TestClient(app)

def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}

def test_read_item():
    response = client.get('/users/100')
    assert response.status_code == 200
    assert response.json() == {'user_id': 100}
