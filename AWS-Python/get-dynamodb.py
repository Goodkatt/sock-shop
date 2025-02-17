import boto3
import os
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb', 
                          aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
                          aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
                          region_name=os.getenv('AWS_REGION'))  
table = dynamodb.Table('adservice_versions')  

def get_version(version_key):
    try:
        response = table.get_item(
            Key={
                'adservice_version': 'version_number'  
            }
        )

        if 'Item' in response:
            return response['Item']['value']
        else:
            print("Item not found.")
            return None
    except ClientError as e:
        print(f"Error getting item: {e}")
        return None

version = get_version('adservice_version')
print(version)

