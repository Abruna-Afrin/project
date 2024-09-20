from sqlalchemy import create_engine, text
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_async_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine, class_=AsyncSession)

async def call_create_user_procedure(first_name: str, last_name: str, dob: str, gender: str, email: str, phone: int, address: str) -> int:
    async with SessionLocal() as session:
        async with session.begin():
            result = await session.execute(
                text("CALL CreateUser(:first_name, :last_name, :dob, :gender, :email, :phone, :address, @p_UserId); SELECT @p_UserId;"),
                {
                    "first_name": first_name,
                    "last_name": last_name,
                    "dob": dob,
                    "gender": gender,
                    "email": email,
                    "phone": phone,
                    "address": address
                }
            )
            user_id = result.scalar()
            return user_id
