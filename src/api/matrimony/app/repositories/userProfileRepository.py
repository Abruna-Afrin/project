# CREATE PROCEDURE CreateUserProfile(
#     IN p_UserId INT,
#     IN p_Nationality VARCHAR(255),
#     IN p_Religion VARCHAR(255),
#     IN p_Height VARCHAR(255),
#     IN p_Marital_Status VARCHAR(255),
#     IN p_Bio VARCHAR(255),
#     OUT p_ErrorListAsJsonString VARCHAR(max),
#     OUT p_UserProfileId INT
# )

import json
from sqlalchemy import create_engine, text
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_async_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine, class_=AsyncSession)

async def call_create_user_profile_procedure(
    user_id: int,
    nationality: str,
    religion: str,
    height: str,
    marital_status: str,
    bio: str
) -> int:
    async with SessionLocal() as session:
        async with session.begin():
            result = await session.execute(
                text("CALL CreateUserProfile(:user_id, :nationality, :religion, :height, :marital_status, :bio, @p_ErrorListAsJsonString, @p_UserProfileId)"),
                {
                    "user_id": user_id,
                    "nationality": nationality,
                    "religion": religion,
                    "height": height,
                    "marital_status": marital_status,
                    "bio": bio
                }
            )
            error_list_as_json_string = (await session.execute(text("SELECT @p_ErrorListAsJsonString"))).scalar()
            user_profile_id = (await session.execute(text("SELECT @p_UserProfileId"))).scalar()
            error_list = json.loads(error_list_as_json_string)
            if len(error_list) > 0:
                raise ValueError(json.dumps(error_list))
            return user_profile_id