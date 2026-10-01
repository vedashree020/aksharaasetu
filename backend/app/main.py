from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from api.translation import router as translation_router
from api.speech import router as speech_router
from api.auth import router as auth_router


app = FastAPI(
    title="AksharaaSetu API",
    description="Backend API for multilingual tribal-language learning",
    version="1.0.0",
)


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# API routers
app.include_router(translation_router)
app.include_router(speech_router)
app.include_router(auth_router)


@app.get("/")
def root():
    return {
        "app": "AksharaaSetu",
        "status": "running",
        "message": "AksharaaSetu backend is connected",
    }


@app.get("/api/health")
def health():
    return {
        "status": "healthy",
        "service": "aksharaasetu-backend",
    }