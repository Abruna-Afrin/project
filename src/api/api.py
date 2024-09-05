from fastapi import FastAPI, HTTPException
from user_service import UserService, UserProfile

app = FastAPI()
user_service = UserService()

@app.post("/create_user_profile/")
def create_user_profile(user_profile: UserProfile):
    result = user_service.create_user_profile(user_profile)
    if "error" in result:
        raise HTTPException(status_code=500, detail=result["error"])
    return result

@app.get("/get_user_profile/{user_id}")
def get_user_profile(user_id: int):
    result = user_service.get_user_profile(user_id)
    if "error" in result:
        raise HTTPException(status_code=500, detail=result["error"])
    if "message" in result:
        raise HTTPException(status_code=404, detail=result["message"])
    return result