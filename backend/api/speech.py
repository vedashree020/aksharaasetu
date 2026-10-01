from pathlib import Path
from tempfile import NamedTemporaryFile

from fastapi import APIRouter, File, Form, HTTPException, UploadFile

from api.translation import translation_service


router = APIRouter(
    prefix="/api",
    tags=["Speech"],
)


@router.post("/speech-to-speech")
async def speech_to_speech(
    audio: UploadFile = File(...),
    source_language: str = Form(...),
    target_language: str = Form(...),
):
    """
    Speech -> IndicConformer -> text -> IndicTrans2 -> translated text.

    TTS is not loaded locally because the current machine
    does not have enough memory for the TTS model.
    """

    allowed_types = {
        "audio/wav",
        "audio/x-wav",
        "audio/mpeg",
        "audio/mp3",
        "audio/webm",
        "audio/ogg",
        "application/octet-stream",
    }

    if audio.content_type not in allowed_types:
        raise HTTPException(
            status_code=400,
            detail=f"Unsupported audio type: {audio.content_type}",
        )

    source_language = source_language.strip().lower()
    target_language = target_language.strip().lower()

    if source_language not in {
        "hindi",
        "hi",
        "santali",
        "sat",
        "sat_olck",
    }:
        raise HTTPException(
            status_code=400,
            detail="Unsupported source language.",
        )

    if target_language not in {
        "hindi",
        "hi",
        "santali",
        "sat",
        "sat_olck",
    }:
        raise HTTPException(
            status_code=400,
            detail="Unsupported target language.",
        )

    if source_language in {"hindi", "hi"}:
        source_language = "hindi"
    else:
        source_language = "santali"

    if target_language in {"hindi", "hi"}:
        target_language = "hindi"
    else:
        target_language = "santali"

    if source_language == target_language:
        raise HTTPException(
            status_code=400,
            detail="Source and target languages must be different.",
        )

    temp_path = None

    try:
        suffix = Path(
            audio.filename or "audio.wav"
        ).suffix

        if not suffix:
            suffix = ".wav"

        with NamedTemporaryFile(
            delete=False,
            suffix=suffix,
        ) as temp_file:

            temp_path = temp_file.name

            while True:
                chunk = await audio.read(1024 * 1024)

                if not chunk:
                    break

                temp_file.write(chunk)

        result = translation_service.speech_to_translation(
            audio_path=temp_path,
            source_language=source_language,
            target_language=target_language,
        )

        return result

    except ValueError as e:
        raise HTTPException(
            status_code=400,
            detail=str(e),
        )

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e),
        )

    finally:
        if temp_path:
            try:
                Path(temp_path).unlink(
                    missing_ok=True
                )
            except Exception:
                pass