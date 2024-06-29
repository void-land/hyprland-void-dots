import sys

def format_fennel(code):
    # Remove leading/trailing whitespace
    code = code.strip()
    
    # Split the code into lines
    lines = code.split('\n')
    
    # Initialize variables
    formatted_lines = []
    indent_level = 0
    
    for line in lines:
        # Remove leading/trailing whitespace from each line
        line = line.strip()
        
        # Decrease indent for closing parentheses at the start of a line
        while line.startswith(')'):
            indent_level = max(0, indent_level - 1)
            line = line[1:].lstrip()
        
        # Add the formatted line
        formatted_lines.append('  ' * indent_level + line)
        
        # Increase indent for opening parentheses
        indent_level += line.count('(') - line.count(')')
        
        # Ensure indent level doesn't go negative
        indent_level = max(0, indent_level)
    
    # Join the formatted lines
    formatted_code = '\n'.join(formatted_lines)
    
    return formatted_code

def main():
    if len(sys.argv) != 2:
        print("Usage: python fennel_formatter.py <input_file>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    
    try:
        with open(input_file, 'r') as file:
            fennel_code = file.read()
    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found.")
        sys.exit(1)
    except IOError:
        print(f"Error: Unable to read file '{input_file}'.")
        sys.exit(1)
    
    formatted_code = format_fennel(fennel_code)
    print(formatted_code)

if __name__ == "__main__":
    main()