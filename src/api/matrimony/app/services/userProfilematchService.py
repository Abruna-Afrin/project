from app.models.createProfileMatch import CreateProfileMatch
from app.repositories.userProfileMatchRepository import call_create_profile_match_procedure

async def create_user_profile_match(user:CreateProfileMatch)-> int:
    Match_Id = await call_create_profile_match_procedure(
    user.profile1_id,
    user.profile2_id,
    user.match_date,
    user.match_status
    )
    return  Match_Id