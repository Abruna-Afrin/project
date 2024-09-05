from user_repository import UserRepository
from pydantic import BaseModel

# Pydantic model for the request body
class UserProfile(BaseModel):
    user_id: int
    nationality: str
    religion: str
    height: str
    marital_status: str
    bio: str

class UserService:
    def __init__(self):
        self.user_repository = UserRepository()

    def create_user_profile(self, user_profile: UserProfile):
        try:
            self.user_repository.create_user_profile(user_profile)
            return {"message": "User profile created successfully"}
        except Exception as e:
            return {"error": str(e)}
