from django.urls import path, include
from .views import getPathes

urlpatterns = [
    path("getPathes", getPathes)
]