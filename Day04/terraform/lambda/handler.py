from datetime import datetime, timezone


def handler(event, context):
    timestamp = datetime.now(timezone.utc).isoformat()

    print("=== Scheduled Lambda Executed ===")
    print(f"Timestamp: {timestamp}")
    print(f"Event: {event}")

    return {
        "statusCode": 200,
        "message": "Lambda executed successfully",
        "timestamp": timestamp
    }