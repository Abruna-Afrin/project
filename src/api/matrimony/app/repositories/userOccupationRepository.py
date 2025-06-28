from sqlalchemy import create_engine, text
from sqlalchemy.ext.asyncio import AsyncSession,create_async_engine
from sqlalchemy.orm import sessionmaker
import os

from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_async_engine(DATABASE_URL, echo= True)
sessionLocal = sessionmaker(autocommit=False, bind= engine, class_= AsyncSession)

async def call_create_user_occupation_procedure(user_id: int, Occupation_Title: str, Occupation_Description: str, AverageSalary: str, DateAdded: str)-> int:
    async with sessionLocal() as session:
        async with session.begin():
            result = await session.execute(
                text("CALL createEducation(user_id, :Occupation_Title, :Occupation_Description, :AverageSalary, :DateAdded, @p_UserOccupationId)"),
                {
                    user_id: user_id,
                    "Occupation_Title": Occupation_Title, 
                    "Occupation_Description": Occupation_Description, 
                    "AverageSalary": AverageSalary, 
                    "DateAdded": DateAdded
                }
            )
            UserOccupation_Id = (await session.execute(text("select  @p_UserOccupationId")))
            return UserOccupation_Id
        