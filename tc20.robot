from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Set up WebDriver
driver_path = "C:\Users\entit\Downloads\chrome-win64\chrome-win64"  # Update with your driver path
driver = webdriver.Chrome(driver_path)

try:
    # Step 1: Launch browser and navigate to the URL
    driver.get("http://automationexercise.com")
    driver.maximize_window()
    time.sleep(3)

    # Step 2: Click on 'Products' button
    products_button = driver.find_element(By.LINK_TEXT, "Products")
    products_button.click()
    time.sleep(3)

    # Step 3: Verify navigation to ALL PRODUCTS page
    assert "All Products" in driver.page_source, "Failed to navigate to ALL PRODUCTS page"

    # Step 4: Search for a product
    search_box = driver.find_element(By.ID, "search_product")
    search_box.send_keys("dress")  # Change to any product name
    search_box.send_keys(Keys.RETURN)
    time.sleep(3)

    # Step 5: Verify 'SEARCHED PRODUCTS' is visible
    assert "SEARCHED PRODUCTS" in driver.page_source, "'SEARCHED PRODUCTS' section not visible"

    # Step 6: Verify searched products are visible
    searched_products = driver.find_elements(By.CLASS_NAME, "productinfo")
    assert len(searched_products) > 0, "No searched products found"

    # Step 7: Add all searched products to the cart
    add_buttons = driver.find_elements(By.CLASS_NAME, "add-to-cart")
    for button in add_buttons[:2]:  # Adding only first 2 products to the cart
        button.click()
        time.sleep(2)
        driver.find_element(By.XPATH, "//button[contains(text(), 'Continue Shopping')]").click()
        time.sleep(2)

    # Step 8: Click 'Cart' button and verify products in cart
    cart_button = driver.find_element(By.LINK_TEXT, "Cart")
    cart_button.click()
    time.sleep(3)

    cart_items = driver.find_elements(By.CLASS_NAME, "cart_description")
    assert len(cart_items) > 0, "Cart is empty before login"

    # Step 9: Click 'Signup / Login' and login
    login_button = driver.find_element(By.LINK_TEXT, "Signup / Login")
    login_button.click()
    time.sleep(3)

    driver.find_element(By.NAME, "email").send_keys("testuser@example.com")  # Update with valid email
    driver.find_element(By.NAME, "password").send_keys("password123")  # Update with valid password
    driver.find_element(By.XPATH, "//button[contains(text(), 'Login')]").click()
    time.sleep(3)

    # Step 10: Again, go to Cart page
    cart_button = driver.find_element(By.LINK_TEXT, "Cart")
    cart_button.click()
    time.sleep(3)

    # Step 11: Verify that products are still in the cart
    cart_items_after_login = driver.find_elements(By.CLASS_NAME, "cart_description")
    assert len(cart_items_after_login) > 0, "Cart is empty after login"

    print("Test Case Passed: Products are retained in the cart after login!")

except AssertionError as e:
    print(f"Test Case Failed: {e}")

finally:
    # Close the browser
    driver.quit()
*** Settings ***
Library    SeleniumLibrary

*** Test Cases ***
Verify Google Homepage
    Open Browser    https://www.google.com    chrome
    Close Browser
