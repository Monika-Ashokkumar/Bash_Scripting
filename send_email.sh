#!/bin/bash

# Function to send an email
send_email() {
    local recipient="monikaashokkumar@gmail.com"   
    local subject="Test Email"               
    local body="This is a test email."       

    echo "$body" | mail -s "$subject" "$recipient"
}

# Call the function to send the email
send_email

