import random
import string

# Function to generate a password of specified length
def generate_password(length):
    password = ''.join(random.choice(string.ascii_letters + string.digits + string.punctuation) for i in range(length))
    return password

# Prompt user for length of password
length = int(input("How many characters do you need your password(s) to be?: "))

# Prompt user for number of passwords to generate
num_passwords = int(input("How many passwords do you need at this time?: "))

# Loop to generate and print specified number of passwords
for i in range(num_passwords):
    password = generate_password(length)
    print(f"Password {i+1}: {password}")