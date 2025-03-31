from pydantic import BaseModel

class UserProfile(BaseModel):
 
    Nationality: str
    Religion: str
    Height: str
    Marital_Status: str
    Bio: str