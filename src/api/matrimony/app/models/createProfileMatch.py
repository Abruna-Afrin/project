from pydantic import BaseModel
from datetime import date


class CreateProfileMatch(BaseModel):
    profile1_id: int
    profile2_id: int
    match_date: date
    match_status: str