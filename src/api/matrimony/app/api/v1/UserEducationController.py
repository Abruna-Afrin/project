import logging 

from app.models.createEducation import CreateEducation
from fastapi import APIRouter, HTTPException
from app.services.userEducationService import create_user_education

router = APIRouter()
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@router.post("/")
async def Create_education_endpoint(user: CreateEducation):
    try:
        user_id = await create_user_education(user)
        return {"user_id": user_id}
    except Exception as e:
        logger.exception("Error Creating Education")
        raise HTTPException(status_code=400, detail=str(e))