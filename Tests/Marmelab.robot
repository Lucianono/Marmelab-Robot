*** Settings ***
Resource    ../Resources/App.resource
Resource    ../Resources/CustomerPage.resource
Library    ../JsonAPI.py

Suite Setup    Initial Setups   
*** Variables ***
${URL}    https://marmelab.com/react-admin-demo/#/login
${USERNAME}    demo
${PASSWORD}    demo1ggvgvhjhhgvjcfgcfgfcg


*** Test Cases ***
TEST-001
    Create and Verify Users    5
    Go To Page    ${a_customers}
    Capture Page Screenshot

TEST-002
    Update Users    10    5
    Go To Page    ${a_customers}
    Capture Page Screenshot

TEST-003
    Log Customer Details Row    25

TEST-004
    Log Customers Spending    25
    