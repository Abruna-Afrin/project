from pydantic import BaseModel

class UserCreate(BaseModel):
    first_name: str
    last_name: str
    dob: str
    gender: str
    email: str
    phone: int
    address: str

# example payload for testing
{
  "first_name": "John",
  "last_name": "Doe",
  "dob": "1990-01-01",
  "gender": "Male",
  "email": "john.doe@example.com",
  "phone": 1234567890,
  "address": "123 Main Street"
}