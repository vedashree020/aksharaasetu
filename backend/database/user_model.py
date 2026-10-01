from sqlalchemy import Column, Integer, String, DateTime
from datetime import datetime

from database.auth_database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)

    name = Column(
        String(100),
        nullable=False,
    )

    email = Column(
        String(255),
        unique=True,
        index=True,
        nullable=False,
    )

    password_hash = Column(
        String(255),
        nullable=False,
    )

    role = Column(
        String(20),
        nullable=False,
        default="teacher",
    )

    created_at = Column(
        DateTime,
        default=datetime.utcnow,
    )

    reset_token = Column(
        String(255),
        nullable=True,
    )

    reset_token_expires = Column(
        DateTime,
        nullable=True,
    )