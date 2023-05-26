import os
import pickle
import statsd
from googleapiclient.errors import HttpError
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build

# If modifying these scopes, delete the file token.pickle.
SCOPES = ["https://www.googleapis.com/auth/drive.metadata.readonly"]

GDRIVE_SIZE_APP_CLIENT_SECRETS_ENV = "GDRIVE_SIZE_CLIENT_SECRETS"

GDRIVE_USER_CREDS_PATH = "/tmp/zpeng.gdrive.user.creds.json"


def get_service():
    """Shows basic usage of the Drive v3 API.
    Prints the names and ids of the first 10 files the user has access to.
    """
    creds = None
    # The file token.pickle stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists(GDRIVE_USER_CREDS_PATH):
        with open(GDRIVE_USER_CREDS_PATH, "rb") as token:
            creds = pickle.load(token)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                os.environ[GDRIVE_SIZE_APP_CLIENT_SECRETS_ENV], SCOPES
            )
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open(GDRIVE_USER_CREDS_PATH, "wb") as token:
            pickle.dump(creds, token)

    service = build("drive", "v3", credentials=creds)

    return service


def main():
    s = statsd.StatsClient("localhost", 8125)
    try:
        service = get_service()
        results = service.about().get(fields="storageQuota").execute()
        keys = ["limit", "usage", "usageInDrive", "usageInDriveTrash"]
        for k in keys:
            value = int(results.get("storageQuota").get(k))
            print(k, value)
            s.gauge(f"gdrive.{k}", value)
    except HttpError as error:
        # TODO: send error metrics
        pass


if __name__ == "__main__":
    main()
