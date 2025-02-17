import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb', region_name='eu-west-1')  
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

