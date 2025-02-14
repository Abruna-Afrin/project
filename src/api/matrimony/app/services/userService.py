from app.models.createUser import UserCreate, UserUpdate, UserResponse
from app.repositories.userRepository import (
    call_create_user_procedure,
    get_user_by_id_db,
    update_user_db,
    delete_user_db,
    get_users_db
)
from app.core.exceptions import UserNotFoundException, DatabaseException
from typing import List

async def create_user(user: UserCreate) -> int:
    try:
        user_id = await call_create_user_procedure(
            user.first_name,
            user.last_name,
            str(user.dob),
            user.gender,
            user.email,
            user.phone,
            user.address
        )
        return user_id
    except Exception as e:
        raise DatabaseException(f"Failed to create user: {str(e)}")

async def get_user_by_id(user_id: int) -> UserResponse:
    user = await get_user_by_id_db(user_id)
    if not user:
        raise UserNotFoundException(f"User with id {user_id} not found")
    return UserResponse(**user)

async def update_user(user_id: int, user_update: UserUpdate) -> UserResponse:
    # First check if user exists
    existing_user = await get_user_by_id_db(user_id)
    if not existing_user:
        raise UserNotFoundException(f"User with id {user_id} not found")
    
    # Update only provided fields
    update_data = user_update.dict(exclude_unset=True)
    if not update_data:
        return UserResponse(**existing_user)
    
    try:
        updated_user = await update_user_db(user_id, update_data)
        return UserResponse(**updated_user)
    except Exception as e:
        raise DatabaseException(f"Failed to update user: {str(e)}")

async def delete_user(user_id: int) -> None:
    # First check if user exists
    existing_user = await get_user_by_id_db(user_id)
    if not existing_user:
        raise UserNotFoundException(f"User with id {user_id} not found")
    
    try:
        await delete_user_db(user_id)
    except Exception as e:
        raise DatabaseException(f"Failed to delete user: {str(e)}")

async def get_users() -> List[UserResponse]:
    try:
        users = await get_users_db()
        return [UserResponse(**user) for user in users]
    except Exception as e:
        raise DatabaseException(f"Failed to retrieve users: {str(e)}")
