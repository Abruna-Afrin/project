
from sqlalchemy import create_engine, text
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from datetime import date
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_async_engine(DATABASE_URL, echo=True)
sessionLocal = sessionmaker(autocommit=False, bind=engine, class_=AsyncSession)

async def call_create_profile_match_procedure(
    profile1_id: int,
    profile2_id: int,
    match_date: date,
    match_status: str
) -> int:
    async with sessionLocal() as session:
        async with session.begin():
           result = await session.execute(
                text("CALL CreateProfileMatch(profile1_id, :profile2_id, :match_date, :match_status, @p_MatchId)"),
                {
                    "profile1_id": profile1_id,
                    "profile2_id": profile2_id,
                    "match_date": match_date,
                    "match_status": match_status
                }
            )
           Match_id = (await session.execute(text("SELECT @p_MatchId")))
           return Match_id