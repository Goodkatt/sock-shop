import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb', region_name='eu-west-1') 
table = dynamodb.Table('adservice_version') 

def put_version(version_key, version_value):
    try:
        response = table.put_item(
            Item={
                'adservice_version': version_key,  
                'value': version_value             
            }
        )
        print("PutItem succeeded:", response)
    except ClientError as e:
        print(f"Error inserting item: {e}")

put_version('version_number', '0.0.1')
