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

def download_image(img_url, download_folder, downloaded, skipped):
    img_name = os.path.basename(img_url)
    img_path = os.path.join(download_folder, img_name)

    if not os.path.exists(img_path):
        with open(img_path, 'wb') as img_file:
            img_file.write(requests.get(img_url).content)
        print(f"Downloaded: {img_name}")
        downloaded.append(img_name)
    else:
        print(f"Skipped: {img_name} (already exists)")
        skipped.append(img_name)

def download_images(url, download_folder=None):
    if download_folder is None:
        download_folder = os.getcwd()

    os.makedirs(download_folder, exist_ok=True)

    response = requests.get(url)

    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        img_tags = soup.find_all('img')

        total_images = len(img_tags)
        downloaded_images = []
        skipped_images = []

        with ThreadPoolExecutor(max_workers=MAX_THREADS) as executor:
            for img_tag in img_tags:
                img_url = img_tag.get('src')
                if img_url:
                    img_url = urljoin(url, img_url)
                    # Use the semaphore to control the number of threads
                    with thread_semaphore:
                        executor.submit(download_image, img_url, download_folder, downloaded_images, skipped_images)

        print(f"Total images found: {total_images}")
        print(f"Images downloaded: {len(downloaded_images)}")
        print(f"Images skipped: {len(skipped_images)}")
    else:
        print(f"Failed to fetch URL: {url}")

if __name__ == "__main__":
    url = input("Enter the URL of the webpage containing images: ")
    download_folder = input("Enter the folder where you want to save the images (leave empty to use the current directory): ")

    if download_folder.strip() == "":
        download_folder = None  # Use the current directory

    download_images(url, download_folder)
