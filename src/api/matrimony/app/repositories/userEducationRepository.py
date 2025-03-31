from sqlalchemy import create_engine, text
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

load_dotenv()
DATABASE_URL= os.getenv("DATABASE_URL")

engine = create_async_engine(DATABASE_URL, echo = True)
sessionLocal = sessionmaker(autocommit=False, bind = engine, class_ = AsyncSession)

async def  call_create_user_education_procedure(user_id: int,degree: str, institution: str, fieldOfStudy: str, startDate: str, endDate: str, GPA: str) -> int:
    async with sessionLocal() as session:
        async with session.begin():
            result = await session.execute(
                text("CALL CreateEducation(:user_id, degree, :institution, :fieldOfStudy, :startDate, :endDate, :GPA, @p_UserEducationId)"),
                {
                    user_id: user_id,
                    "degree": degree, 
                    "institution":institution,
                    "fieldOfStudy" :fieldOfStudy,
                    "startDate" :startDate,
                    "endDate" :endDate
                }
            )

            UserEducation_Id = (await session.execute(text("select @UserEducationId"))).scalar
            return UserEducation_Id 