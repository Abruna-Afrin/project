from pydantic import BaseModel


class CreateUserProfile(BaseModel):
    user_id: int
    nationality: str
    religion: str
    height: str
    marital_status: str
    bio: str

# json example
# {
#   "user_id": 1,
#   "nationality": "Indian",
#   "religion": "Hindu",
#   "height": "5'8",
#   "marital_status": "Married",
#   "bio": "I am a programmer"
# }