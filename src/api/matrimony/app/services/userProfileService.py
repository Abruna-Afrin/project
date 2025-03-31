from app.models.createUserProfile import UserProfile
from app.repositories.userProfileRepository import call_create_user_profile_procedure

async def create_user_profile(user: UserProfile) -> int:
    UserProfileId = await call_create_user_profile_procedure(
        user.UserId,
    user.Nationality,
    user.Religion,
    user.Height,
    user.Marital_Status,
    user.Bio
   
    )

    return UserProfileId