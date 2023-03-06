import random
import string
import datetime

# Function to generate a password of specified length
def generate_password(length):
    password = ''.join(random.choice(string.ascii_letters + string.digits + string.punctuation) for i in range(length))
    return password

# Prompt user for number of passwords to generate
num_passwords = int(input("How many passwords do you need at this time?: "))

# Prompt user for length of password
length = int(input("How many characters do you need your password(s) to be?: "))

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

except ValueError:
    print("Please enter a valid number for the number of passwords and length")
except Exception as e:
    print("An unexpected error occurred: ", e)
    
#3/5/23 - In this modified code, we have added try-except blocks to catch two types of errors:
#ValueError: This exception will be raised if the user inputs an invalid value for the number of passwords or the length of the password. If this exception is caught, the code will print a message asking the user to enter a valid input.
#Exception: This exception will catch any other unexpected errors that may occur during the execution of the code. If this exception is caught, the code will print a message indicating that an unexpected error has occurred and display the error message.
#By adding these try-except blocks, we can improve the robustness and reliability of the code by handling errors gracefully and preventing the code from crashing due to invalid inputs or unexpected errors.