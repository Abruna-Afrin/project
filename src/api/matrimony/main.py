from fastapi import FastAPI
from app.api.v1.UserController import router as user_router
from app.api.v1.userProfileController import router as user_profile_router

app = FastAPI()

app.include_router(user_router, prefix="/user")
app.include_router(user_profile_router, prefix="/userProfile")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
