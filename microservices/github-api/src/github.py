import requests

def get_user(username: str) -> dict:
    response = requests.get(f"https://api.github.com/users/{username}")
    return response.json()

def get_user_repos(username: str) -> dict:
    response = requests.get(f"https://api.github.com/users/{username}/repos")
    return response.json()
