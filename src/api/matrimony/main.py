from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1.UserController import router as user_router
from app.core.config import get_settings

settings = get_settings()

app = FastAPI(
    title="Matrimony API",
    description="API for matrimony application with user management",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS middleware configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(user_router, prefix="/api/v1/users", tags=["users"])

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host=settings.HOST, port=settings.PORT, reload=settings.DEBUG)
