import logging
from app.models.createUserProfile import UserProfile
from fastapi import APIRouter, HTTPException
from app.services.userProfileService import create_user_profile
router = APIRouter()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
@router.post("/")
async def create_user_profile_endpoint(user: UserProfile):
    try:
            UserProfileId = await create_user_profile
            return {"user_profile_id": UserProfileId}
    except Exception as e: 
          logger.exception("Error creating user Profile")
          raise HTTPException(status_code=400, detail= str(e))