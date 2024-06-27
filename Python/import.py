import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin


def download_images(url, download_folder):
    # Create the download folder if it doesn't exist
    os.makedirs(download_folder, exist_ok=True)

    # Send an HTTP request to the URL
    response = requests.get(url)

    if response.status_code == 200:
        # Parse the HTML content of the page
        soup = BeautifulSoup(response.text, 'html.parser')

        # Find all image tags in the HTML
        img_tags = soup.find_all('img')

        # Download each image
        for img_tag in img_tags:
            img_url = img_tag.get('src')
            if img_url:
                # Create an absolute URL if the image URL is relative
                img_url = urljoin(url, img_url)

                # Get the image file name
                img_name = os.path.basename(img_url)

                # Download the image and save it to the download folder
                with open(os.path.join(download_folder, img_name), 'wb') as img_file:
                    img_file.write(requests.get(img_url).content)

                print(f"Downloaded: {img_name}")
    else:
        print(f"Failed to fetch URL: {url}")


if __name__ == "__main__":
    url = input("Enter the URL of the webpage containing images: ")
    download_folder = input("Enter the folder where you want to save the images: ")

    download_images(url, download_folder)
