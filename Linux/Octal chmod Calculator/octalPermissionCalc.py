
OctalToSymbol = {
    0: '---',
    1: '--x',
    2: '-w-',
    3: '-wx',
    4: 'r--',
    5: 'r-x',
    6: 'rw-',
    7: 'rwx',
}

def octal_to_symbolic(octal):
    """
    Convert an octal permission string to symbolic representation.
    
    Args:
        octal (str): A string representing the octal permissions (e.g., '755').
    
    Returns:
        str: The symbolic representation of the permissions (e.g., 'rwxr-xr-x').
    """
    if len(octal) != 3 or not octal.isdigit():
        raise ValueError("Octal permission must be a 3-digit string.")
    
    symbolic = ''
    for digit in octal:
        symbolic += OctalToSymbol[int(digit)]
    
    return symbolic

def symbolic_to_octal(symbolic):
    """
    Convert a symbolic permission string to octal representation.
    
    Args:
        symbolic (str): A string representing the symbolic permissions (e.g., 'rwxr-xr-x').
    
    Returns:
        str: The octal representation of the permissions (e.g., '755').
    """
    if len(symbolic) != 9 or any(c not in 'rwx-' for c in symbolic):
        raise ValueError("Symbolic permission must be a 9-character string.")
    
    octal = ''
    for i in range(0, 9, 3):
        part = symbolic[i:i+3]
        octal += str(sum(2**j for j, c in enumerate(part) if c == 'rwx'[j]))
    
    return octal

def main():
        while True:
            print("\nOctal Permission Calculator")
            print("1. Convert octal to symbolic")
            print("2. Convert symbolic to octal")
            print("3. Exit")
            
            choice = input("Enter your choice (1-3): ").strip()
            
            if choice == '1':
                try:
                    octal = input("Enter octal permission (e.g., 755): ").strip()
                    result = octal_to_symbolic(octal)
                    print(f"Symbolic: {result}")
                except ValueError as e:
                    print(f"Error: {e}")
            
            elif choice == '2':
                try:
                    symbolic = input("Enter symbolic permission (e.g., rwxr-xr-x): ").strip()
                    result = symbolic_to_octal(symbolic)
                    print(f"Octal: {result}")
                except ValueError as e:
                    print(f"Error: {e}")
            
            elif choice == '3':
                print("Goodbye!")
                break
            
            else:
                print("Invalid choice. Please enter 1, 2, or 3.")

if __name__ == "__main__":
        main()


