from fastapi import FastAPI
from app.api.v1.UserController import router as user_router
from app.api.v1.UserProfileController import router as user_profile_router
from app.api.v1.UserEducationController import router as user_education_router

app = FastAPI()

app.include_router(user_router, prefix="/user")
app.include_router(user_profile_router, prefix="/userprofile")
app.include_router(user_education_router, prefix="/usereducation")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
