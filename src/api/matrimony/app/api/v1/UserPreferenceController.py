import logging 

from app.models.createPreference import CreatePreference
from app.services.userPreferenceService import create_user_preference
from fastapi import APIRouter, HTTPException

router = APIRouter()
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@router.post("/")
async def Create_preference_endpoint(user: CreatePreference):
    try:
        user_id = await create_user_preference(user)
        return {"user_id": user_id}
    except Exception as e:
        logger.exception("Error Creating Prefernce")
        raise HTTPException(status_code=400, detail=str(e))