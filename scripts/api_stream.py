import requests
import json
import time

# URL and headers for the API request
url = 'http://192.168.86.28:5000/v1/completions'
headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json'
}

# Data payload for the API request
data = {
    "prompt": "List the planets in the solar system in order from closest to farthest from the Sun. Provide each planet's name and a brief fact about it.\n1.",
    "stop": ["###"],
    "max_tokens": 512,
    "temperature": 0.5,
    "top_p": 0.9,
    "frequency_penalty": 0.5,
    "presence_penalty": 0.5,
    "stream": "true"
}

def stream_response_as_paragraph(url, headers, data):
    paragraph = ""
    with requests.post(url, headers=headers, data=json.dumps(data), stream=True) as response:
        if response.status_code == 200:
            for line in response.iter_lines():
                if line:
                    # Decode and parse the JSON response line
                    decoded_line = line.decode('utf-8').strip()
                    if decoded_line.startswith("data: "):
                        try:
                            json_data = json.loads(decoded_line[6:])
                            if "choices" in json_data:
                                for choice in json_data["choices"]:
                                    new_text = choice.get("text", "")
                                    paragraph += new_text
                                    print("\033c", end="")  # Clear the terminal (works on Unix-based systems)
                                    print(paragraph.strip())
                                    time.sleep(0.1)  # small delay to allow for readable streaming
                        except json.JSONDecodeError:
                            print("Error decoding JSON:", decoded_line)
        else:
            print(f"Request failed with status code {response.status_code}")

if __name__ == "__main__":
    stream_response_as_paragraph(url, headers, data)
