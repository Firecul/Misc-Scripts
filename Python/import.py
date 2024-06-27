import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
from concurrent.futures import ThreadPoolExecutor
import threading

# Configure the maximum number of threads
MAX_THREADS = 20

# Semaphore to control the number of concurrent threads
thread_semaphore = threading.Semaphore(MAX_THREADS)

def download_media(media_url, download_folder, downloaded, skipped):
    media_name = os.path.basename(media_url)
    media_path = os.path.join(download_folder, media_name)

    if not os.path.exists(media_path):
        with open(media_path, 'wb') as media_file:
            media_file.write(requests.get(media_url).content)
        print(f"Downloaded: {media_name}")
        downloaded.append(media_name)
    else:
        print(f"Skipped: {media_name} (already exists)")
        skipped.append(media_name)

def download_media_files(url, download_folder=None):
    if download_folder is None:
        download_folder = os.getcwd()

    os.makedirs(download_folder, exist_ok=True)

    response = requests.get(url)

    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        img_tags = soup.find_all('img')
        a_tags = soup.find_all('a')

        total_media = 0
        downloaded_media = []
        skipped_media = []

        media_types = {'.jpg', '.jpeg', '.png', '.gif', '.mp4', '.mkv', '.webp', '.webm'}

        with ThreadPoolExecutor(max_workers=MAX_THREADS) as executor:
            for img_tag in img_tags:
                img_url = img_tag.get('src')
                if img_url:
                    ext = os.path.splitext(img_url)[-1].lower()
                    if ext in media_types:
                        img_url = urljoin(url, img_url)
                        with thread_semaphore:
                            executor.submit(download_media, img_url, download_folder, downloaded_media, skipped_media)
                        total_media += 1

            for a_tag in a_tags:
                a_url = a_tag.get('href')
                if a_url:
                    ext = os.path.splitext(a_url)[-1].lower()
                    if ext in media_types:
                        a_url = urljoin(url, a_url)
                        with thread_semaphore:
                            executor.submit(download_media, a_url, download_folder, downloaded_media, skipped_media)
                        total_media += 1

        print(f"Total media files found: {total_media}")
        print(f"Media files downloaded: {len(downloaded_media)}")
        print(f"Media files skipped: {len(skipped_media)}")
    else:
        print(f"Failed to fetch URL: {url}")

if __name__ == "__main__":
    url = input("Enter the URL of the webpage containing media files: ")
    download_folder = input("Enter the folder where you want to save the media files (leave empty to use the current directory): ")

    if download_folder.strip() == "":
        download_folder = None  # Use the current directory

    download_media_files(url, download_folder)
