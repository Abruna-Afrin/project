import logging

from app.models.createUser import UserCreate
from fastapi import APIRouter, HTTPException
from app.services.userService import create_user

router = APIRouter()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@router.post("/")
async def create_user_endpoint(user: UserCreate):
    try:
        user_id = await create_user(user)
        return {"user_id": user_id}
    except Exception as e:
        logger.exception("Error creating user")
        raise HTTPException(status_code=400, detail=str(e))