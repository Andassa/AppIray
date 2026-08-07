from datetime import datetime

from pydantic import BaseModel, ConfigDict

from app.core.enums import DevicePlatform, NotificationType


class NotificationRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    type: NotificationType
    payload: dict
    read_at: datetime | None
    created_at: datetime


class DeviceTokenCreate(BaseModel):
    token: str
    platform: DevicePlatform


class DeviceTokenRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    token: str
    platform: DevicePlatform
    created_at: datetime
    last_seen_at: datetime
