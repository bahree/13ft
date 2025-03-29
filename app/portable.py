import requests
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from urllib.parse import urlparse

def bypass_paywall(url):
    """Main paywall bypass logic"""
    if is_cloudflare_site(url):
        return handle_cloudflare(url)
    else:
        return handle_standard(url)

def is_cloudflare_site(url):
    domain = urlparse(url).netloc.lower()
    return 'medium.com' in domain

def handle_standard(url):
    headers = {
        'User-Agent': 'Googlebot/2.1 (+http://www.google.com/bot.html)',
        'Referer': 'https://www.google.com/'
    }
    return requests.get(url, headers=headers).text

def handle_cloudflare(url):
    chrome_options = Options()
    chrome_options.add_argument("--headless=new")
    chrome_options.add_argument("--disable-blink-features=AutomationControlled")
    
    driver = webdriver.Chrome(options=chrome_options)
    driver.get(url)
    content = driver.page_source
    driver.quit()
    return content
