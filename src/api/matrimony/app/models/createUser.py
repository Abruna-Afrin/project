from pydantic import BaseModel, Field, validator
from datetime import date
from typing import Optional
import re

class UserBase(BaseModel):
    first_name: str = Field(..., min_length=2, max_length=50)
    last_name: str = Field(..., min_length=2, max_length=50)
    dob: date
    gender: str = Field(..., pattern="^(Male|Female|Other)$")
    email: str = Field(..., max_length=100)
    phone: str = Field(..., min_length=10, max_length=15)
    address: str = Field(..., max_length=200)

    @validator('phone')
    def validate_phone(cls, v):
        if not re.match(r'^\+?1?\d{9,15}$', v):
            raise ValueError('Invalid phone number format')
        return v

    @validator('dob')
    def validate_dob(cls, v):
        if v > date.today():
            raise ValueError('Date of birth cannot be in the future')
        return v

    @validator('email')
    def validate_email(cls, v):
        if not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', v):
            raise ValueError('Invalid email format')
        return v

class UserCreate(UserBase):
    pass

class UserUpdate(BaseModel):
    first_name: Optional[str] = Field(None, min_length=2, max_length=50)
    last_name: Optional[str] = Field(None, min_length=2, max_length=50)
    email: Optional[str] = Field(None, max_length=100)
    phone: Optional[str] = Field(None, min_length=10, max_length=15)
    address: Optional[str] = Field(None, max_length=200)

    @validator('phone')
    def validate_phone(cls, v):
        if v and not re.match(r'^\+?1?\d{9,15}$', v):
            raise ValueError('Invalid phone number format')
        return v

    @validator('email')
    def validate_email(cls, v):
        if v and not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', v):
            raise ValueError('Invalid email format')
        return v

class UserResponse(UserBase):
    user_id: int

    class Config:
        from_attributes = True

# example payload for testing
# {
#   "first_name": "John",
#   "last_name": "Doe",
#   "dob": "1990-01-01",
#   "gender": "Male",
#   "email": "john.doe@example.com",
#   "phone": "+1234567890",
#   "address": "123 Main Street"
# }