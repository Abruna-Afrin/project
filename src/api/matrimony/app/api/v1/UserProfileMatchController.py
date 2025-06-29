import logging
from app.models.createProfileMatch import CreateProfileMatch
from fastapi import APIRouter, HTTPException
from app.services.userProfilematchService import create_user_profile_match
router = APIRouter()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
@router.post("/")
async def create_user_profile_match_endpoint(user: CreateProfileMatch):
    try:
            Match_id = await create_user_profile_match
            return {"user_profile_id": Match_id}
    except Exception as e: 
          logger.exception("Error creating user Profile")
          raise HTTPException(status_code=400, detail= str(e))