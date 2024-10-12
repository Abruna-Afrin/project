import logging;

from app.models.createUserProfile import CreateUserProfile
from fastapi import APIRouter, HTTPException
from app.services.userProfileService import create_user_profile

router = APIRouter()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@router.post("/")
async def create_user_profile_endpoint(user_profile: CreateUserProfile):
    try:
        user_profile_id = await create_user_profile(user_profile)
        return {"user_profile_id": user_profile_id}
    except ValueError as e:
        logger.exception("Error creating user profile")
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        logger.exception("Error creating user profile")
        raise HTTPException(status_code=500, detail="Server error")