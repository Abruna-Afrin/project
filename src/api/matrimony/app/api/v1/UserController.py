import logging
from typing import List

from fastapi import APIRouter, HTTPException, status
from app.models.createUser import UserCreate, UserResponse, UserUpdate
from app.services.userService import (
    create_user,
    get_user_by_id,
    update_user,
    delete_user,
    get_users
)
from app.core.exceptions import UserNotFoundException, DatabaseException

router = APIRouter()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@router.post("/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user_endpoint(user: UserCreate):
    """
    Create a new user profile
    """
    try:
        user_id = await create_user(user)
        return {"user_id": user_id, **user.dict()}
    except DatabaseException as e:
        logger.exception("Database error while creating user")
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    except Exception as e:
        logger.exception("Error creating user")
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.get("/{user_id}", response_model=UserResponse)
async def get_user_endpoint(user_id: int):
    """
    Get user profile by ID
    """
    try:
        user = await get_user_by_id(user_id)
        return user
    except UserNotFoundException:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    except Exception as e:
        logger.exception(f"Error retrieving user {user_id}")
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

@router.put("/{user_id}", response_model=UserResponse)
async def update_user_endpoint(user_id: int, user_update: UserUpdate):
    """
    Update user profile
    """
    try:
        updated_user = await update_user(user_id, user_update)
        return updated_user
    except UserNotFoundException:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    except Exception as e:
        logger.exception(f"Error updating user {user_id}")
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user_endpoint(user_id: int):
    """
    Delete user profile
    """
    try:
        await delete_user(user_id)
    except UserNotFoundException:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    except Exception as e:
        logger.exception(f"Error deleting user {user_id}")
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

@router.get("/", response_model=List[UserResponse])
async def get_users_endpoint():
    """
    Get all user profiles
    """
    try:
        users = await get_users()
        return users
    except Exception as e:
        logger.exception("Error retrieving users")
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))