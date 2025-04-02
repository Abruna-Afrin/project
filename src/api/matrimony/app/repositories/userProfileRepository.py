from sqlalchemy import create_engine, text
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_async_engine(DATABASE_URL, echo= True)
sessionLocal = sessionmaker(autocommit=False, autoflush = False, bind = engine, class_ =AsyncSession )


async def call_create_user_profile_procedure(user_id: int, nationality: str, religion: str, height: str, marital_status: str, bio: str ) -> int:
    async with sessionLocal() as session:
        async with session.begin():
            result = await session.execute(
                text ("CALL CreateUserProfile(:user_id, :nationality, :religion, :height, :marital_status, :bio, @p_UserProfileId)"),
                {
                    user_id: user_id,
                    "nationality": nationality,
                    "religion": religion,
                    "height": height,
                    "marital_status": marital_status,
                    "bio": bio

                }
                
            )
            UserProfile_Id = (await session.execute(text("Select @p_UserProfileId"))).scalar()
            return UserProfile_Id 