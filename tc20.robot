from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Setup WebDriver
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))
driver.maximize_window()

try:
    # Step 1: Launch browser and navigate to the URL
    driver.get("http://automationexercise.com")

    wait = WebDriverWait(driver, 10)

    # Step 2: Click on 'Products' button
    products_button = wait.until(EC.element_to_be_clickable((By.LINK_TEXT, "Products")))
    products_button.click()

    # Step 3: Verify navigation to ALL PRODUCTS page
    assert "All Products" in driver.page_source, "Failed to navigate to ALL PRODUCTS page"

    # Step 4: Search for a product
    search_box = wait.until(EC.presence_of_element_located((By.ID, "search_product")))
    search_box.send_keys("dress")
    search_box.send_keys(Keys.RETURN)

    # Step 5: Verify 'SEARCHED PRODUCTS' is visible
    assert "SEARCHED PRODUCTS" in driver.page_source, "'SEARCHED PRODUCTS' section not visible"

    # Step 6: Verify searched products are visible
    searched_products = wait.until(EC.presence_of_all_elements_located((By.CLASS_NAME, "productinfo")))
    assert len(searched_products) > 0, "No searched products found"

    # Step 7: Add all searched products to the cart
    add_buttons = wait.until(EC.presence_of_all_elements_located((By.XPATH, "//a[contains(@class, 'add-to-cart')]")))

    for button in add_buttons[:2]:  # Adding only first 2 products to the cart
        driver.execute_script("arguments[0].click();", button)  # Using JS click
        wait.until(EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'Continue Shopping')]"))).click()

    # Step 8: Click 'Cart' button and verify products in cart
    cart_button = wait.until(EC.element_to_be_clickable((By.LINK_TEXT, "Cart")))
    cart_button.click()

    cart_items = wait.until(EC.presence_of_all_elements_located((By.CLASS_NAME, "cart_description")))
    assert len(cart_items) > 0, "Cart is empty before login"

    # Step 9: Click 'Signup / Login' and login
    login_button = wait.until(EC.element_to_be_clickable((By.LINK_TEXT, "Signup / Login")))
    login_button.click()

    wait.until(EC.presence_of_element_located((By.NAME, "email"))).send_keys("testuser@example.com")
    wait.until(EC.presence_of_element_located((By.NAME, "password"))).send_keys("password123")
    wait.until(EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'Login')]"))).click()

    # Step 10: Again, go to Cart page
    cart_button = wait.until(EC.element_to_be_clickable((By.LINK_TEXT, "Cart")))
    cart_button.click()

    # Step 11: Verify that products are still in the cart
    cart_items_after_login = wait.until(EC.presence_of_all_elements_located((By.CLASS_NAME, "cart_description")))
    assert len(cart_items_after_login) > 0, "Cart is empty after login"

    print("✅ Test Case Passed: Products are retained in the cart after login!")

except AssertionError as e:
    print(f"❌ Test Case Failed: {e}")

finally:
    # Close the browser
    driver.quit()
