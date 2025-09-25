*** Settings ***
Library    SeleniumLibrary
Library    ../JsonAPI.py
Variables    ../Variables/variables.py

*** Keywords ***
Launch Browser 
    [Arguments]    ${url}=${URL}    ${locator_xpath}=${btn_submit}
    Open Browser    ${url}    chrome    options=add_argument("--start-maximized")  
    Wait Until Keyword Succeeds    5x    .5s    Wait Until Element Is Visible    ${locator_xpath}

Login User
    [Arguments]    ${username}=${USERNAME}    ${password}=${PASSWORD}
    Input Text    ${input_username}    ${username}
    Input Text    ${input_passwd}    ${password}
    Click Button    ${btn_submit}

Setup Users
    ${USERS}    Get Random Users
    Set Suite Variable    ${USERS}

Initial Setups
    Setup Users
    Launch Browser
    Login User

