from rest_framework import serializers

class PathDetail:
    def __init__(self,pathdetails):
        self.pathdetails = pathdetails 



class PathDetailSerializer(serializers.Serializer):
    pathdetails = serializers.ListField()
    

