from pydantic import BaseModel

class CreateOccupation(BaseModel):

    Occupation_Title: str
    Occupation_Description: str
    AverageSalary: str
    DateAdded: str
