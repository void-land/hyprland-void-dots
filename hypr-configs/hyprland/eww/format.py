import re

def format_yuck(input_file, output_file):
    def indent_line(line, indent_level):
        return "  " * indent_level + line.strip()

    def format_content(content):
        # Preserve strings and comments
        placeholders = {}
        def replace_with_placeholder(match):
            placeholder = f"__PLACEHOLDER_{len(placeholders)}__"
            placeholders[placeholder] = match.group(0)
            return placeholder

        content = re.sub(r'"(?:[^"\\]|\\.)*"', replace_with_placeholder, content)
        content = re.sub(r';.*', replace_with_placeholder, content)

        # Split content into lines, preserving newlines in the original content
        lines = content.split('\n')
        formatted_lines = []
        indent = 0
        
        for line in lines:
            line = line.strip()
            if not line:
                formatted_lines.append('')
                continue

            # Handle opening parentheses
            while '(' in line:
                parts = line.split('(', 1)
                if parts[0].strip():
                    formatted_lines.append(indent_line(parts[0], indent))
                formatted_lines.append(indent_line('(', indent))
                indent += 1
                line = parts[1]

            # Handle content and closing parentheses
            while line:
                if ')' in line:
                    parts = line.split(')', 1)
                    if parts[0].strip():
                        formatted_lines.append(indent_line(parts[0], indent))
                    indent -= 1
                    formatted_lines.append(indent_line(')', indent))
                    line = parts[1]
                else:
                    formatted_lines.append(indent_line(line, indent))
                    break

        # Restore placeholders
        formatted_content = '\n'.join(formatted_lines)
        for placeholder, original in placeholders.items():
            formatted_content = formatted_content.replace(placeholder, original)

        return formatted_content

    with open(input_file, 'r') as f:
        content = f.read()

    formatted_content = format_content(content)

    with open(output_file, 'w') as f:
        f.write(formatted_content)

format_yuck('./src/sidebar/main.yuck', 'output.yuck')
