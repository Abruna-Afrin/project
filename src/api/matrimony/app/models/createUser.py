from pydantic import BaseModel

class UserCreate(BaseModel):
    first_name: str
    last_name: str
    dob: str
    gender: str
    email: str
    phone: int
    address: str