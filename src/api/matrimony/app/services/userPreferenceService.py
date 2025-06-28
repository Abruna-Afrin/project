from app.models.createPreference import CreatePreference
from app.repositories.userPreferenceRepository import call_create_user_preference_procedure

async def create_user_preference(user:CreatePreference)-> int:
    UserPreferenceId = await call_create_user_preference_procedure(
    user.UserId,
    user.nationality,
    user.religion,
    user.height,
    user.education,
    user.occupation,
    user.location
        )
    return  UserPreferenceId 