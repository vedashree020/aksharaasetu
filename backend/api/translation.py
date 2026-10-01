from fastapi import APIRouter

from schemas.translation import TranslationRequest
from services.translation_service import TranslationService


router = APIRouter(
    prefix="/api/translation",
    tags=["Translation"],
)

translation_service = TranslationService()


@router.post("")
def translate(request: TranslationRequest) -> dict:
    return translation_service.translate(request)