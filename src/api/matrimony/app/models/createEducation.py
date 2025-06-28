from pydantic import BaseModel

class CreateEducation(BaseModel):
    Degree: str
    Institution: str
    FieldOfStudy: str
    StartDate: str
    EndDate: str
    GPA: str