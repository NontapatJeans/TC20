*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    http://automationexercise.com
${BROWSER}    chrome
${SEARCH_TERM}    dress
${EMAIL}    testuser@example.com
${PASSWORD}    password123

*** Test Cases ***
Test Case 20: Search Products and Verify Cart After Login
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains    Home

    Click Link    Products
    Wait Until Page Contains    All Products

    Input Text    id=search_product    ${SEARCH_TERM}
    Press Keys    id=search_product    ENTER
    Wait Until Page Contains    SEARCHED PRODUCTS

    ${products}    Get WebElements    class=productinfo
    Should Not Be Empty    ${products}    No searched products found

    # Add first two products to cart
    ${add_buttons}    Get WebElements    xpath=//a[contains(@class, 'add-to-cart')]
    Click Element    ${add_buttons}[0]
    Sleep    2s
    Click Button    //button[contains(text(), 'Continue Shopping')]
    Click Element    ${add_buttons}[1]
    Sleep    2s
    Click Button    //button[contains(text(), 'Continue Shopping')]

    Click Link    Cart
    Wait Until Page Contains    Shopping Cart
    ${cart_items}    Get WebElements    class=cart_description
    Should Not Be Empty    ${cart_items}    Cart is empty before login

    Click Link    Signup / Login
    Wait Until Element Is Visible    name=email
    Input Text    name=email    ${EMAIL}
    Input Text    name=password    ${PASSWORD}
    Click Button    //button[contains(text(), 'Login')]

    Click Link    Cart
    Wait Until Page Contains    Shopping Cart
    ${cart_items_after_login}    Get WebElements    class=cart_description
    Should Not Be Empty    ${cart_items_after_login}    Cart is empty after login

    Close Browser
