from selenium import webdriver

browser = webdriver.Firefox()
browser.get('http://plugin-runner/checkout/cart')
browser.quit()
