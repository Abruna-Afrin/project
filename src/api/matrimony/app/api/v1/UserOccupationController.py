import logging
from app.models.createOccupation import CreateOccupation
from app.services.userOccupationService import create_user_occupation
from fastapi import APIRouter, HTTPException


router = APIRouter()
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@router.post("/")
async def Create_occupation_endpoint(user:CreateOccupation):
    try:
        user_id = await create_user_occupation(user)
        return {"user_id": user_id}
    except Exception as e:
        logger.exception("Error Creating Occupation.")
        raise HTTPException(status_code=400, detail=str(e))