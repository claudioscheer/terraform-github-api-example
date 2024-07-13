import os
import json
from git import Repo
import boto3


s3 = boto3.client("s3")
files_limit = 500


def handler(event, context):
    print("event ->", event)

    body = event["Records"][0]["body"]
    body = json.loads(body)
    repo_url = body["repo_url"]
    print("repo_url ->", repo_url)

    extension = body["extension"]
    print("extension ->", extension)
    
    repo_name = repo_url.split("/")[-1].replace(".git", "")
    local_path = f"/tmp/{repo_name}"
    print("local_path ->", local_path)

    Repo.clone_from(repo_url, local_path, depth=1)
    copy_to_s3(local_path, repo_name, extension)

    return event

def copy_to_s3(local_path, repo_name, extension):
    bucket = os.environ["S3_BUCKET"]
    count = 0

    for root, dirs, files in os.walk(local_path):
        if ".git" in dirs:
            dirs.remove(".git")

        for file in files:
            if extension and not file.endswith(extension):
                continue

            if count >= files_limit:
                print(f"Files limit reached. Skipping {root}/{file}")
                break

            file_path = os.path.join(root, file)
            s3_path = file_path.replace(local_path, f"{repo_name}")
            print(f"Uploading {file_path} to s3://{bucket}{s3_path}")
            s3.upload_file(file_path, bucket, s3_path)

            count += 1


if __name__ == "__main__":
    event = {
        "Records": [
            {
                "messageId": "dbd56de1-a392-477d-8dfe-83f812497864",
                "receiptHandle": "AQEB91JBHSwxpeAMS06lt3fFoMwKSEIt8jITXuv4OdNMEj7GZAPTrhrnGsWVPCxmLKy7FE1NJ7otVIlJg9Ti1+xJlqTQv6F8y95z+7bJ6km2b4KFdSX08Hrr4jnmB1hQlpPrkzZ/JYs9djUgSLzlDxkRjq1oa5eataBLMXyCzyHDWSFvHh2ZwA8Mm1/RsMNeneARhBoXI49yKWxVAdp5jHrhwgx4LOws2iebYx1ISm6KjrNgLYEKvM8aAHuAR7dsiZ3E9+gLhN8IYDUbr5acm5nU3MJpi3ftZYGBL/2XSG0hLIjVMDoMwp/qm2g/EooFBjTamw6MOy/FcyrXluHDXvSlarow9hovU+TCG5BKN6p/xtTbnfHV+z7A+2C0PzPaoE9aaWzKD1GgYMK+TTZkkYykEA==",
                "body": '{"repo_url": "https://github.com/golang/tools"}',
                "attributes": {
                    "ApproximateReceiveCount": "1",
                    "SentTimestamp": "1720830440843",
                    "SenderId": "941652505371",
                    "ApproximateFirstReceiveTimestamp": "1720830440854",
                },
                "messageAttributes": {},
                "md5OfBody": "84c856fedd4b1abf82fd3c11bcc5c5f1",
                "eventSource": "aws:sqs",
                "eventSourceARN": "arn:aws:sqs:us-east-1:941652505371:github-repos-to-fork",
                "awsRegion": "us-east-1",
            }
        ]
    }

    handler(event, None)
