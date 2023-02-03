import random
import string

# Define the set of characters that can be included in the password
characters = string.ascii_letters + string.digits + string.punctuation

# Generate a random password
def generate_password():
        # Define the length of the password

        password_length = 24

        # Use the random.choices function to generate a list of random characters
        password = ''.join(random.choices(characters, k=password_length))

        # Return the generated password
        return password

# Call the generate_password function and store the result in the password variable
password = generate_password()

# Print the generated password
print(password)