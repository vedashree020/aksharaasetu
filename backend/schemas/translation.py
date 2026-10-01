from enum import Enum
from typing import Optional

from pydantic import BaseModel


class TranslationMode(str, Enum):
    text = "text"
    speech_to_text = "speech_to_text"
    text_to_speech = "text_to_speech"
    speech_to_speech = "speech_to_speech"


class TranslationRequest(BaseModel):
    source_language: str
    target_language: str
    mode: TranslationMode
    text: str
    lesson_id: Optional[str] = None