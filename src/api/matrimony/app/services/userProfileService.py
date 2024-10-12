from app.models.createUserProfile import CreateUserProfile
from app.repositories.userProfileRepository import call_create_user_profile_procedure


async def create_user_profile(user_profile: CreateUserProfile) -> int:
    user_profile_id = await call_create_user_profile_procedure(
        user_profile.user_id,
        user_profile.nationality,
        user_profile.religion,
        user_profile.height,
        user_profile.marital_status,
        user_profile.bio
    )
    return user_profile_id