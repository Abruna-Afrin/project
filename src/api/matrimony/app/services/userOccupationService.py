from app.models.createOccupation import CreateOccupation
from app.repositories.userOccupationRepository import call_create_user_occupation_procedure

async def create_user_occupation(user:CreateOccupation)-> int:
    UserOccupationId = call_create_user_occupation_procedure(
    user.UserId,
    user.Occupation_Title,
    user.Occupation_Description,
    user.AverageSalary,
    user.DateAdded
    )

    return UserOccupationId

