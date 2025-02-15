from sqlalchemy import create_engine, text
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from app.core.config import get_settings
from typing import Dict, List, Optional

settings = get_settings()

engine = create_async_engine(settings.DATABASE_URL, echo=settings.DEBUG)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine, class_=AsyncSession)

async def call_create_user_procedure(
    first_name: str,
    last_name: str,
    dob: str,
    gender: str,
    email: str,
    phone: str,
    address: str
) -> int:
    async with SessionLocal() as session:
        async with session.begin():
            result = await session.execute(
                text("CALL CreateUser(:first_name, :last_name, :dob, :gender, :email, :phone, :address, @p_UserId)"),
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
            user_id = (await session.execute(text("SELECT @p_UserId"))).scalar()
            return user_id

async def get_user_by_id_db(user_id: int) -> Optional[Dict]:
    async with SessionLocal() as session:
        result = await session.execute(
            text("SELECT * FROM Users WHERE user_id = :user_id"),
            {"user_id": user_id}
        )
        user = result.mappings().first()
        return dict(user) if user else None

async def update_user_db(user_id: int, update_data: Dict) -> Dict:
    async with SessionLocal() as session:
        async with session.begin():
            result = await session.execute(
                text("CALL UpdateUser(:user_id, :first_name, :last_name, :dob, :gender, :email, :phone, :address, @p_Errors)"),
                {
                    "user_id": user_id,
                    "first_name": update_data.get("first_name"),
                    "last_name": update_data.get("last_name"),
                    "dob": update_data.get("dob"),
                    "gender": update_data.get("gender"),
                    "email": update_data.get("email"),
                    "phone": update_data.get("phone"),
                    "address": update_data.get("address")
                }
            )
            errors = (await session.execute(text("SELECT @p_Errors"))).scalar()
            if errors:
                raise DatabaseException(errors)
            
            # Fetch and return updated user
            result = await session.execute(
                text("SELECT * FROM Users WHERE user_id = :user_id"),
                {"user_id": user_id}
            )
            return dict(result.mappings().first())

async def delete_user_db(user_id: int) -> None:
    async with SessionLocal() as session:
        async with session.begin():
            result = await session.execute(
                text("CALL Delete_User(:user_id, @p_Errors)"),
                {"user_id": user_id}
            )
            errors = (await session.execute(text("SELECT @p_Errors"))).scalar()
            if errors:
                raise DatabaseException(errors)

async def get_users_db() -> List[Dict]:
    async with SessionLocal() as session:
        result = await session.execute(text("SELECT * FROM Users"))
        users = result.mappings().all()
        return [dict(user) for user in users]