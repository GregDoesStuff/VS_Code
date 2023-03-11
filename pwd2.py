#!/usr/bin/python3
import random
import string
import datetime

MAX_TRIES = 5

# Function to generate a password of specified length
def generate_password(length):
    password = ''.join(random.choice(string.ascii_letters + string.digits + string.punctuation) for i in range(length))
    return password

# Prompt user for number of passwords to generate
tries = 0
while tries < MAX_TRIES:
    try:
        num_passwords = int(input("How many passwords do you need at this time?: "))
        break
    except ValueError:
        tries += 1
        print("Please enter a valid number for the number of passwords.")
        if tries == MAX_TRIES:
            print(f"Max tries ({MAX_TRIES}) exceeded. Exiting.")
            exit()

# Prompt user for length of password
tries = 0
while tries < MAX_TRIES:
    try:
        length = int(input("How many characters do you need your password(s) to be?: "))
        break
    except ValueError:
        tries += 1
        print("Please enter a valid number for the length of the password.")
        if tries == MAX_TRIES:
            print(f"Max tries ({MAX_TRIES}) exceeded. Exiting.")
            exit()

# Get the current date and time
now = datetime.datetime.now()

# Open a text file for writing
with open("passwords.txt", "w") as file:
    # Write the date and time to the file
    file.write(f"Generated on {now.strftime('%Y-%m-%d %H:%M:%S')}\n")

    # Loop to generate and write specified number of passwords
    for i in range(num_passwords):
        password = generate_password(length)
        file.write(f"Password {i+1}: {password}\n")

# Print a message indicating that the passwords are ready
print("Thank you! Your passwords are ready and have been saved to passwords.txt")
    
#33/5/23 - I added two while loops that allow the user to input values up to 5 times,
# and I also defined a MAX_TRIES variable to make it easy to change the maximum number of tries allowed.