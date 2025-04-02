from app.models.createEducation import CreateEducation
from app.repositories.userEducationRepository import call_create_user_education_procedure

async def create_user_education(user:CreateEducation)-> int:
    UserEducationId = await call_create_user_education_procedure(
    user.UserId,
    user.Degree,
    user.Institution,
    user.FieldOfStudy,
   user.StartDate,
    user.EndDate,
    user.GPA
)
    return UserEducationId