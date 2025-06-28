from pydantic import BaseModel

class CreatePreference(BaseModel):

    nationality: str
    religion:str
    height: str
    education: str
    occupation: str
    location: str