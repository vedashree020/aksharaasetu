from datetime import datetime, timedelta
import hashlib
import secrets

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, EmailStr
from sqlalchemy.orm import Session

from database.auth_database import get_db
from database.user_model import User


router = APIRouter(
    prefix="/api/auth",
    tags=["Authentication"],
)


# --------------------------------------------------
# REQUEST MODELS
# --------------------------------------------------

class RegisterRequest(BaseModel):
    name: str
    email: EmailStr
    password: str
    role: str = "teacher"


class LoginRequest(BaseModel):
    email: EmailStr
    password: str
    role: str = "teacher"


class ForgotPasswordRequest(BaseModel):
    email: EmailStr


class ResetPasswordRequest(BaseModel):
    token: str
    new_password: str


# --------------------------------------------------
# PASSWORD HELPERS
# --------------------------------------------------

def hash_password(password: str) -> str:
    return hashlib.sha256(
        password.encode("utf-8")
    ).hexdigest()


def verify_password(
    password: str,
    password_hash: str,
) -> bool:
    return hash_password(password) == password_hash


# --------------------------------------------------
# REGISTER
# --------------------------------------------------

@router.post("/register")
def register(
    request: RegisterRequest,
    db: Session = Depends(get_db),
):
    email = request.email.lower().strip()
    role = request.role.lower().strip()

    if role not in {"teacher", "admin"}:
        raise HTTPException(
            status_code=400,
            detail="Invalid role.",
        )

    if len(request.password) < 6:
        raise HTTPException(
            status_code=400,
            detail="Password must contain at least 6 characters.",
        )

    existing_user = (
        db.query(User)
        .filter(User.email == email)
        .first()
    )

    if existing_user:
        raise HTTPException(
            status_code=409,
            detail="An account with this email already exists.",
        )

    user = User(
        name=request.name.strip(),
        email=email,
        password_hash=hash_password(
            request.password
        ),
        role=role,
    )

    db.add(user)
    db.commit()
    db.refresh(user)

    return {
        "success": True,
        "message": "Account created successfully.",
        "user": {
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "role": user.role,
        },
    }


# --------------------------------------------------
# LOGIN
# --------------------------------------------------

@router.post("/login")
def login(
    request: LoginRequest,
    db: Session = Depends(get_db),
):
    email = request.email.lower().strip()
    role = request.role.lower().strip()

    user = (
        db.query(User)
        .filter(User.email == email)
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=401,
            detail="No account found with this email.",
        )

    if not verify_password(
        request.password,
        user.password_hash,
    ):
        raise HTTPException(
            status_code=401,
            detail="Incorrect password.",
        )

    if user.role != role:
        raise HTTPException(
            status_code=403,
            detail="Selected role does not match this account.",
        )

    return {
        "success": True,
        "message": "Login successful.",
        "user": {
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "role": user.role,
        },
    }


# --------------------------------------------------
# FORGOT PASSWORD
# --------------------------------------------------

@router.post("/forgot-password")
def forgot_password(
    request: ForgotPasswordRequest,
    db: Session = Depends(get_db),
):
    email = request.email.lower().strip()

    user = (
        db.query(User)
        .filter(User.email == email)
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="No registered account found with this email.",
        )

    token = secrets.token_urlsafe(32)

    user.reset_token = token
    user.reset_token_expires = (
        datetime.utcnow() + timedelta(minutes=30)
    )

    db.commit()

    # Email sending will be connected in the next step.
    # Never display the reset token in the production app.

    return {
        "success": True,
        "message": "Password reset request created.",
        "email": user.email,
    }


# --------------------------------------------------
# RESET PASSWORD
# --------------------------------------------------

@router.post("/reset-password")
def reset_password(
    request: ResetPasswordRequest,
    db: Session = Depends(get_db),
):
    if len(request.new_password) < 6:
        raise HTTPException(
            status_code=400,
            detail="Password must contain at least 6 characters.",
        )

    user = (
        db.query(User)
        .filter(
            User.reset_token == request.token
        )
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=400,
            detail="Invalid or expired reset token.",
        )

    if (
        user.reset_token_expires is None
        or user.reset_token_expires < datetime.utcnow()
    ):
        raise HTTPException(
            status_code=400,
            detail="Invalid or expired reset token.",
        )

    user.password_hash = hash_password(
        request.new_password
    )

    user.reset_token = None
    user.reset_token_expires = None

    db.commit()

    return {
        "success": True,
        "message": "Password reset successfully.",
    }