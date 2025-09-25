*** Settings ***
Library    SeleniumLibrary
Variables    ../Variables/variables.py

*** Variables ***
${USERS}
@{INPUT_FIELDS_CUSTOMERS}    ${input_firstname}    ${input_lastname}    ${input_email}    ${input_bday}    ${input_passwd}    ${input_confirmpasswd}    ${textarea_address}    ${input_city}    ${input_state}    ${input_zipcode}

*** Keywords ***
Go To Page
    [Arguments]    ${locator_btn}
    Wait Until Element Is Visible    ${locator_btn}  
    Click Element    ${locator_btn}

Create Customer
    [Arguments]    ${input_fields}    ${input_values}

    Wait Until Element Is Visible    ${input_firstname}

    FOR    ${index}    ${element}    IN ENUMERATE    @{input_fields}
        Input Text    ${element}    ${input_values}[${index}]
        # Log To Console    ${input_values}[${index}]
    END
    
    Click Button    ${btn_submit}
    Wait Until Element Is Visible    ${div_customerCreated}

Update Customer
    [Arguments]    ${input_fields}    ${input_values}

    Wait Until Element Is Visible    ${input_firstname}

    FOR    ${index}    ${element}    IN ENUMERATE    @{input_fields}
        IF    ${index} != 3
            Press Keys    ${element}    CTRL+A    BACKSPACE
        END
        Input Text    ${element}    ${input_values}[${index}]
        # Log To Console    ${input_values}[${index}]
    END
    
    Click Button    ${btn_submit}
    Wait Until Element Is Visible    ${div_customerUpdated}


Verify User Is Added
    [Arguments]    ${user}
    Click Button    ${btn_refreshcustomer}
    ${test_name}    Get Text    ${td_firstusernameadded}
    IF    "\\n" in """${test_name}"""
        ${test_name}    Evaluate    """${test_name}""".replace("\\n","")[1:]
    END
    ${user}    Evaluate    " ".join("""${user}""".split(" ")[0:2])
    Log To Console    ${test_name}
    Should Be Equal As Strings    ${test_name}    ${user}

Verify Details
    [Arguments]    ${input_fields}    ${input_values}

    Wait Until Element Is Visible    ${input_firstname}        
    
    FOR    ${index}    ${element}    IN ENUMERATE    @{input_fields}
        ${input_value}    Get Element Attribute    ${element}    value
        Should Be Equal As Strings    ${input_value}    ${input_values}[${index}]
    END
    
Create and Verify Users
    [Arguments]    ${end}    ${start}=0    

    FOR    ${i}    IN    @{USERS}[${start}:${end}]
        Go To Page    ${a_customers}
        Go To Page    ${a_customers_create}
        ${list_inputs}    Create List    ${i["name"].split(" ")[0]}    ${i["name"].split(" ")[1]}    ${i["email"]}    ${i["birthday"]}    ${i["password"]}    ${i["password"]}    ${i["address"]["street"]}    ${i["address"]["city"]}    ${i["address"]["state"]}    ${i["address"]["zipcode"]}
        Create Customer    ${INPUT_FIELDS_CUSTOMERS}    ${list_inputs}
        Go To Page    ${a_customers}
        Verify User Is Added   ${i["name"]}
        ${list_inputs}[3]    Evaluate    "-".join(["${list_inputs}[3][4:8]","${list_inputs}[3][0:2]","${list_inputs}[3][2:4]"])
        Go To Page    ${a_firstusernameadded}
        Verify Details    ${INPUT_FIELDS_CUSTOMERS}    ${list_inputs}
    END
    
Update Users
    [Arguments]    ${end}    ${start}=0    

    FOR    ${index}    ${i}    IN ENUMERATE    @{USERS}[${start}:${end}]
        Go To Page    ${a_customers}
        ${row_index}    Evaluate    ${index} + ${start} + 1
        Go To Page    //tr[${row_index}]/td[2]
        ${list_inputs}    Create List    ${i["name"].split(" ")[0]}    ${i["name"].split(" ")[1]}    ${i["email"]}    ${i["birthday"]}    ${i["password"]}    ${i["password"]}    ${i["address"]["street"]}    ${i["address"]["city"]}    ${i["address"]["state"]}    ${i["address"]["zipcode"]}
        Update Customer    ${INPUT_FIELDS_CUSTOMERS}    ${list_inputs}
    END

Log Customer Details Row
    [Arguments]    ${size}    
    
    Go To Page    ${a_customers}
    Click Button    ${btn_refreshcustomer}


    FOR    ${index}    IN RANGE    ${size}
        ${row_index}    Evaluate    ${index} + 1
        ${row_locator}    Set Variable    //tr[${row_index}]

        ${status}    Run Keyword And Return Status    Element Should Be Visible    ${row_locator}
        Exit For Loop If    ${status} == False

        Log To Console    ""
        Log To Console    "======= Customer ${row_index} ======="

        ${row_name}    Get Text    ${row_locator}//td[2]/a/div
        ${row_lastseen}    Get Text    ${row_locator}//td[3]
        ${row_orders}     Get Text    ${row_locator}//td[4]
        ${row_spent}    Get Text    ${row_locator}//td[5]
        ${row_purchase}    Get Text    ${row_locator}//td[6]
        ${row_news}    Get Element Attribute    ${row_locator}//td[7]/span/*[local-name()="svg"]   aria-label
        ${status}    Run Keyword And Return Status    Element Should Be Visible    ${row_locator}//td[8]//span

        IF    ${status}
            ${row_segments}    Get Text    ${row_locator}//td[8]/div

            IF    "\\n" in """${row_segments}"""
            ${row_segments}    Evaluate    """${row_segments}""".replace("\\n",",")
            END
        ELSE
            ${row_segments}    Set Variable    "None"
        END

        
        IF    "\\n" in """${row_name}"""
            ${row_name}    Evaluate    """${row_name}""".replace("\\n","")[1:]
        END
        
        

        Log To Console    "Name : ${row_name}"
        Log To Console    "Last Seen : ${row_lastseen}"
        Log To Console    "Orders : ${row_orders}"
        Log To Console    "Total Spent : ${row_spent}"
        Log To Console    "Latest Purchase : ${row_purchase}"
        Log To Console    "Has News : ${row_news}"
        Log To Console    "Segment : ${row_segments}"

        Log To Console    "=========================="
    END

Log Customers Spending
    [Arguments]    ${size}  

    Go To Page    ${a_customers}
    Click Button    ${btn_refreshcustomer}
    # Go To Page    ${th_spent}
    # Go To Page    ${th_spent}
    # Click Button    ${btn_refreshcustomer}

    ${total_spent}    Set Variable    0
    ${spending_customer_ctr}    Set Variable    1
    
    Log To Console    ""
    Log To Console    "=========================="

    FOR    ${index}    IN RANGE    ${size}
        ${row_index}    Evaluate    ${index} + 1
        ${row_locator}    Set Variable    //tr[${row_index}]

        ${status}    Run Keyword And Return Status    Element Should Be Visible    ${row_locator}
        Exit For Loop If    ${status} == False

        ${row_name}    Get Text    ${row_locator}//td[2]/a/div
        ${row_spent}    Get Text    ${row_locator}//td[5]
        IF    "\\n" in """${row_name}"""
            ${row_name}    Evaluate    """${row_name}""".replace("\\n","")[1:]
        END

        IF    '${row_spent}' != '$0.00'
            
            Log To Console    "${spending_customer_ctr}. ${row_name}: ${row_spent}"
            ${spending_customer_ctr}    Evaluate    ${spending_customer_ctr}+1
            ${row_spent}    Evaluate    """${row_spent}""".replace(",","")[1:]
            ${total_spent}    Evaluate    ${total_spent} + ${row_spent}
        END


    END

    ${total_spent}    Evaluate    "{:.2f}".format(${total_spent})

    Log To Console    "=========================="
    Log To Console    Total Customers Spent : $${total_spent}
    Log To Console    "=========================="


    IF    ${total_spent} < 3500
        Fail    "FAIL: Total spending is $${total_spent} is below minimum threshold $3,500"
    ELSE
        Log To Console    PASS: Total spending is $${total_spent} meets minimum threshold $3,500"

    END