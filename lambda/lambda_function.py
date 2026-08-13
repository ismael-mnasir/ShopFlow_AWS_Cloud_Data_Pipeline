import json
import boto3

def lambda_handler(event, context):
    print("New file uploaded to S3!")
    
    # Initialize AWS Glue client
    glue = boto3.client('glue')
    
    # Get bucket and file info from S3 trigger event
    for record in event.get('Records', []):
        bucket_name = record['s3']['bucket']['name']
        file_key = record['s3']['object']['key']
        file_size = record['s3']['object']['size']
        
        print(f"Bucket: {bucket_name}")
        print(f"File:   {file_key}")
        print(f"Size:   {file_size} bytes")
        
        # Check if the file is a CSV
        if file_key.endswith('.csv'):
            print("CSV detected — ready for processing!")
            try:
                response = glue.start_job_run(JobName='sales-etl-job-v2')
                print(f"Successfully started Glue Job 'sales-etl-job-v2'. Job Run ID: {response['JobRunId']}")
            except Exception as e:
                print(f"Error starting Glue job: {e}")
        else:
            print("Not a CSV file — skippingGlue job trigger.")
            
    return {
        'statusCode': 200,
        'body': json.dumps('ShopFlow upload notifier completed successfully!')
    }