from app.models.createUser import UserCreate
from app.repositories.userRepository import call_create_user_procedure


async def create_user(user: UserCreate) -> int:
    user_id = await call_create_user_procedure(
        user.first_name,
        user.last_name,
        user.dob,
        user.gender,
        user.email,
        user.phone,
        user.address
    )
    return user_id
