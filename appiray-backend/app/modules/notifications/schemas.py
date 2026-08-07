from datetime import datetime

from pydantic import BaseModel, ConfigDict

from app.core.enums import NotificationType


class NotificationRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    type: NotificationType
    payload: dict
    read_at: datetime | None
    created_at: datetime
