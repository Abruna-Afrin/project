from sqlalchemy import create_engine, text
from sqlalchemy.ext.asyncio import AsyncSession,create_async_engine
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_async_engine(DATABASE_URL, echo = True)
sessionLocal = sessionmaker(autocommit=False, bind = engine, class_= AsyncSession)

async def call_create_user_preference_procedure(user_id: int, nationality: str, religion:str, height: str, education: str, occupation: str, location: str)->int:
    async with sessionLocal as session:
        async with session.begin():
            result = await session.execute(
                text("CALL CreatePreference(:user_id, :nationality, :religion, :height, : education, :occupation, :location, @p_UserPreId)"),
                {
                    user_id: user_id,
                    "nationality":nationality,
                    "religion":religion,
                    "height":height,
                    "education"  : education,
                    "occupation":occupation,
                    "location":location
                }
            )
            UserPreference_id = (await session.execute(text("select @p_UserPreId"))).scalar
            return UserPreference_id