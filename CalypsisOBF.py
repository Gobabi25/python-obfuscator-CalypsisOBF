import sys
import ast
import random
import string
import marshal
import zlib
import lzma
import base64
import binascii
import time
import os
import subprocess
import importlib

def install_dependencies():
    required_packages = ['colorama']
    for package in required_packages:
        try:
            importlib.import_module(package)
        except ImportError:
            subprocess.check_call([sys.executable, '-m', 'pip', 'install', package], 
                                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

try:
    install_dependencies()
    from colorama import init, Fore, Back, Style
    init()
except:
    class MockColorama:
        RESET = ''
        WHITE = ''
        BLACK = ''
        LIGHTBLACK_EX = ''
        LIGHTWHITE_EX = ''
    Fore = MockColorama()
    Style = MockColorama()

def get_gradient_color(progress):
    progress = max(0, min(1, progress))
    
    gray_levels = [
        (255, 255, 255),  # Pure white
        (230, 230, 230),  # Very light gray
        (205, 205, 205),  # Light gray
        (180, 180, 180),  # Light-medium gray
        (155, 155, 155),  # Medium gray
        (130, 130, 130),  # Medium-dark gray
        (105, 105, 105),  # Dark gray 
        (80, 80, 80),     # Darker gray
    ]
    
    index = progress * (len(gray_levels) - 1)
    lower_index = int(index)
    upper_index = min(lower_index + 1, len(gray_levels) - 1)
    
    if lower_index == upper_index:
        r, g, b = gray_levels[lower_index]
    else:
        fraction = index - lower_index
        r1, g1, b1 = gray_levels[lower_index]
        r2, g2, b2 = gray_levels[upper_index]
        
        r = int(r1 + (r2 - r1) * fraction)
        g = int(g1 + (g2 - g1) * fraction)
        b = int(b1 + (b2 - b1) * fraction)
    
    return f'\033[38;2;{r};{g};{b}m'

def clear_terminal():
    os.system('cls' if os.name == 'nt' else 'clear')

def create_gradient_text(text, width=80):
    lines = text.split('\n')
    result = []
    
    for line_index, line in enumerate(lines):
        if line.strip():
            progress = line_index / max(1, len(lines) - 1)
            gradient_line = apply_character_gradient(line, progress)
            padded_line = gradient_line.center(width + len(gradient_line) - len(line))
            result.append(padded_line)
        else:
            result.append(line.center(width))
    
    return '\n'.join(result)

def apply_character_gradient(text, start_progress=0, reverse=False):
    if not text.strip():
        return text
    
    gradient_chars = []
    non_space_chars = [i for i, char in enumerate(text) if char != ' ']
    
    if not non_space_chars:
        return text
    
    for char_index, char in enumerate(text):
        if char == ' ':
            gradient_chars.append(char)
        else:
            non_space_index = non_space_chars.index(char_index)
            progress = start_progress + (non_space_index / max(1, len(non_space_chars) - 1)) * 0.6
            
            if reverse:
                progress = 1 - progress
                
            color = get_gradient_color(progress)
            gradient_chars.append(color + char + '\033[0m')
    
    return ''.join(gradient_chars)

def apply_text_gradient(text, reverse=False):
    return apply_character_gradient(text, 0, reverse)

def display_header():
    banner_text = """
  /$$$$$$            /$$                               /$$            /$$$$$$  /$$$$$$$  /$$$$$$$$
 /$$__  $$          | $$                              |__/           /$$__  $$| $$__  $$| $$_____/
| $$  \__/  /$$$$$$ | $$ /$$   /$$  /$$$$$$   /$$$$$$$ /$$  /$$$$$$$| $$  \ $$| $$  \ $$| $$      
| $$       |____  $$| $$| $$  | $$ /$$__  $$ /$$_____/| $$ /$$_____/| $$  | $$| $$$$$$$ | $$$$$   
| $$        /$$$$$$$| $$| $$  | $$| $$  \ $$|  $$$$$$ | $$|  $$$$$$ | $$  | $$| $$__  $$| $$__/   
| $$    $$ /$$__  $$| $$| $$  | $$| $$  | $$ \____  $$| $$ \____  $$| $$  | $$| $$  \ $$| $$      
|  $$$$$$/|  $$$$$$$| $$|  $$$$$$$| $$$$$$$/ /$$$$$$$/| $$ /$$$$$$$/|  $$$$$$/| $$$$$$$/| $$      
 \______/  \_______/|__/ \____  $$| $$____/ |_______/ |__/|_______/  \______/ |_______/ |__/      
                         /$$  | $$| $$                                                            
                        |  $$$$$$/| $$                                                            
                         \______/ |__/                                                            
Python Script Obfuscator
========================
    """.strip()
    
    clear_terminal()
    gradient_banner = create_gradient_text(banner_text)
    print(gradient_banner)
    time.sleep(0.5)

def update_progress(current_step, total_steps, bar_length=60):
    progress_fraction = current_step / total_steps
    filled_length = int(progress_fraction * bar_length)
    
    progress_bar = []
    for position in range(bar_length):
        if position < filled_length:
            progress = position / max(1, bar_length - 1)
            color = get_gradient_color(progress)
            progress_bar.append(color + '█' + '\033[0m')
        else:
            progress_bar.append(get_gradient_color(0.3) + '░' + '\033[0m')
    
    bar_display = ''.join(progress_bar)
    percentage = progress_fraction * 100
    
    if percentage >= 100:
        status_text = apply_character_gradient("Complete")
    elif percentage >= 80:
        status_text = apply_character_gradient("Finalizing")
    elif percentage >= 40:
        status_text = apply_character_gradient("Processing")
    else:
        status_text = apply_character_gradient("Starting")
    
    progress_label = apply_character_gradient("Progress:")
    print(f'\r{progress_label} {bar_display} {percentage:.1f}% {status_text}', end='', flush=True)

def generate_variable_name(name_length=10):
    first_character = random.choice(string.ascii_letters + '_')
    remaining_characters = ''.join(random.choices(string.ascii_letters + string.digits + '_', k=name_length-1))
    return first_character + remaining_characters

class VariableRenamer(ast.NodeTransformer):
    def __init__(self):
        self.scope_stack = [{}]
        self.protected_names = set([
            'print', 'len', 'str', 'int', 'float', 'bool', 'list', 'dict', 'tuple', 'set',
            'range', 'enumerate', 'zip', 'map', 'filter', 'sorted', 'max', 'min', 'sum',
            'abs', 'round', 'pow', 'divmod', 'isinstance', 'issubclass', 'hasattr',
            'getattr', 'setattr', 'delattr', 'callable', 'iter', 'next', 'reversed',
            'slice', 'super', 'type', 'vars', 'dir', 'id', 'hash', 'repr', 'ascii',
            'ord', 'chr', 'bin', 'oct', 'hex', 'any', 'all', 'format', 'input',
            'open', 'exec', 'eval', 'compile', '__import__', 'globals', 'locals',
            'Exception', 'ValueError', 'TypeError', 'AttributeError', 'KeyError',
            'IndexError', 'NameError', 'ImportError', 'ModuleNotFoundError',
            'SyntaxError', 'IndentationError', 'TabError', 'UnicodeDecodeError',
            'requests', 'json', 'socket', 'platform', 'os', 'datetime', 
            'marshal', 'zlib', 'lzma', 'base64', 'binascii', 'sys', 'ast',
            'random', 'string', 'time'
        ])

    def enter_new_scope(self):
        self.scope_stack.append({})

    def exit_current_scope(self):
        self.scope_stack.pop()

    def lookup_name(self, original_name):
        if original_name in self.protected_names:
            return None
        for scope_dict in reversed(self.scope_stack):
            if original_name in scope_dict:
                return scope_dict[original_name]
        return None

    def register_name(self, original_name, new_name):
        if original_name not in self.protected_names:
            self.scope_stack[-1][original_name] = new_name

    def visit_FunctionDef(self, node):
        if node.name not in self.protected_names:
            existing_name = self.lookup_name(node.name)
            if not existing_name:
                existing_name = generate_variable_name()
                self.register_name(node.name, existing_name)
            node.name = existing_name

        self.enter_new_scope()
        for function_arg in node.args.args:
            if function_arg.arg not in self.protected_names:
                new_arg_name = generate_variable_name()
                self.register_name(function_arg.arg, new_arg_name)
                function_arg.arg = new_arg_name
        
        for keyword_arg in node.args.kwonlyargs:
            if keyword_arg.arg not in self.protected_names:
                new_keyword_name = generate_variable_name()
                self.register_name(keyword_arg.arg, new_keyword_name)
                keyword_arg.arg = new_keyword_name
        
        if node.args.vararg and node.args.vararg.arg not in self.protected_names:
            new_vararg_name = generate_variable_name()
            self.register_name(node.args.vararg.arg, new_vararg_name)
            node.args.vararg.arg = new_vararg_name
            
        if node.args.kwarg and node.args.kwarg.arg not in self.protected_names:
            new_kwarg_name = generate_variable_name()
            self.register_name(node.args.kwarg.arg, new_kwarg_name)
            node.args.kwarg.arg = new_kwarg_name
        
        self.generic_visit(node)
        self.exit_current_scope()
        return node

    def visit_Lambda(self, node):
        self.enter_new_scope()
        for lambda_arg in node.args.args:
            if lambda_arg.arg not in self.protected_names:
                new_lambda_arg = generate_variable_name()
                self.register_name(lambda_arg.arg, new_lambda_arg)
                lambda_arg.arg = new_lambda_arg
        self.generic_visit(node)
        self.exit_current_scope()
        return node

    def visit_ListComp(self, node):
        self.enter_new_scope()
        self.generic_visit(node)
        self.exit_current_scope()
        return node

    def visit_SetComp(self, node):
        self.enter_new_scope()
        self.generic_visit(node)
        self.exit_current_scope()
        return node

    def visit_DictComp(self, node):
        self.enter_new_scope()
        self.generic_visit(node)
        self.exit_current_scope()
        return node

    def visit_GeneratorExp(self, node):
        self.enter_new_scope()
        self.generic_visit(node)
        self.exit_current_scope()
        return node

    def visit_Name(self, node):
        if node.id in self.protected_names:
            return node
            
        if isinstance(node.ctx, ast.Store):
            replacement_name = self.lookup_name(node.id)
            if not replacement_name:
                replacement_name = generate_variable_name()
                self.register_name(node.id, replacement_name)
            node.id = replacement_name
        else:
            replacement_name = self.lookup_name(node.id)
            if replacement_name:
                node.id = replacement_name
        return node

class CodeNoiseInjector(ast.NodeTransformer):
    def generic_visit(self, node_element):
        if hasattr(node_element, 'body') and isinstance(node_element.body, list):
            for noise_iteration in range(random.randint(0, 2)):
                insertion_position = random.randint(0, len(node_element.body))
                noise_statement = self.create_noise_statement()
                node_element.body.insert(insertion_position, noise_statement)
        if hasattr(node_element, 'orelse') and isinstance(node_element.orelse, list):
            for else_noise_iteration in range(random.randint(0, 1)):
                else_insertion_position = random.randint(0, len(node_element.orelse))
                else_noise_statement = self.create_noise_statement()
                node_element.orelse.insert(else_insertion_position, else_noise_statement)
        if hasattr(node_element, 'handlers') and isinstance(node_element.handlers, list):
            for exception_handler in node_element.handlers:
                for handler_noise_iteration in range(random.randint(0, 1)):
                    handler_insertion_position = random.randint(0, len(exception_handler.body))
                    handler_noise_statement = self.create_noise_statement()
                    exception_handler.body.insert(handler_insertion_position, handler_noise_statement)
        if hasattr(node_element, 'finalbody') and isinstance(node_element.finalbody, list):
            for finally_noise_iteration in range(random.randint(0, 1)):
                finally_insertion_position = random.randint(0, len(node_element.finalbody))
                finally_noise_statement = self.create_noise_statement()
                node_element.finalbody.insert(finally_insertion_position, finally_noise_statement)
        return super().generic_visit(node_element)

    def create_noise_statement(self):
        noise_options = [
            ast.Assign(
                targets=[ast.Name(id=generate_variable_name(), ctx=ast.Store())],
                value=ast.Constant(value=random.randint(1, 100))
            ),
            ast.If(
                test=ast.Constant(value=False),
                body=[ast.Expr(value=ast.Call(
                    func=ast.Name(id='print', ctx=ast.Load()),
                    args=[ast.Constant(value=generate_variable_name())],
                    keywords=[]
                ))],
                orelse=[]
            ),
            ast.Assert(
                test=ast.Constant(value=True),
                msg=ast.Constant(value=generate_variable_name())
            ),
        ]
        return random.choice(noise_options)

if __name__ == "__main__":
    total_processing_steps = 11
    current_step = 0

    display_header()
    print(apply_text_gradient("Drag a Python (.py) file into this console window and press Enter."))
    print(apply_text_gradient("Or type the path to a Python file and press Enter:", reverse=True))
    input_file_path = input().strip()

    if not input_file_path:
        print(apply_text_gradient("Error: No file path provided."))
        input(apply_text_gradient("Press any key to exit...", reverse=True))
        sys.exit(1)

    cleaned_file_path = input_file_path.strip('"').strip("'")

    if not cleaned_file_path.endswith('.py'):
        display_header()
        print(apply_text_gradient("Error: Please provide a valid Python (.py) file."))
        input(apply_text_gradient("Press any key to exit...", reverse=True))
        sys.exit(1)

    if not os.path.exists(cleaned_file_path):
        display_header()
        print(apply_text_gradient(f"Error: File '{cleaned_file_path}' not found."))
        input(apply_text_gradient("Press any key to exit...", reverse=True))
        sys.exit(1)

    display_header()
    update_progress(current_step, total_processing_steps)

    current_step += 1
    update_progress(current_step, total_processing_steps)
    time.sleep(0.1)

    try:
        with open(cleaned_file_path, 'r', encoding='utf-8') as source_file:
            original_source_code = source_file.read()
    except UnicodeDecodeError:
        print(f"\n{apply_text_gradient(f'Error: Cannot decode {cleaned_file_path} with UTF-8 encoding.')}")
        print(apply_text_gradient("The file may use a different encoding (e.g., UTF-16, Latin-1)."))
        print(apply_text_gradient("Please convert the file to UTF-8 or check its encoding.", reverse=True))
        input(apply_text_gradient("Press any key to exit...", reverse=True))
        sys.exit(1)
    except Exception as file_error:
        print(f"\n{apply_text_gradient(f'Error: Failed to read {cleaned_file_path}: {str(file_error)}')}")
        input(apply_text_gradient("Press any key to exit...", reverse=True))
        sys.exit(1)

    current_step += 1
    update_progress(current_step, total_processing_steps)
    time.sleep(0.1)

    try:
        syntax_tree = ast.parse(original_source_code)
    except SyntaxError:
        print(f"\n{apply_text_gradient(f'Error: Invalid Python syntax in {cleaned_file_path}.')}")
        input(apply_text_gradient("Press any key to exit...", reverse=True))
        sys.exit(1)

    current_step += 1
    update_progress(current_step, total_processing_steps)
    time.sleep(0.1)

    variable_renamer = VariableRenamer()
    renamed_syntax_tree = variable_renamer.visit(syntax_tree)

    noise_injector = CodeNoiseInjector()
    obfuscated_tree = noise_injector.visit(renamed_syntax_tree)

    ast.fix_missing_locations(obfuscated_tree)
    obfuscated_source_code = ast.unparse(obfuscated_tree)

    current_step += 1
    update_progress(current_step, total_processing_steps)
    time.sleep(0.1)

    try:
        compiled_bytecode = compile(obfuscated_source_code, '<obfuscated>', 'exec')
    except SyntaxError as syntax_error:
        print(f"\n{apply_text_gradient(f'Error: Invalid syntax in obfuscated code: {str(syntax_error)}')}")
        print(apply_text_gradient("This may be due to invalid variable names or code modifications."))
        print(apply_text_gradient("Generated code snippet causing the error:", reverse=True))
        source_lines = obfuscated_source_code.split('\n')
        error_line_number = syntax_error.lineno - 1
        start_line = max(0, error_line_number - 2)
        end_line = min(len(source_lines), error_line_number + 3)
        for line_index, source_line in enumerate(source_lines[start_line:end_line], start=start_line+1):
            error_marker = ' <--- Error here' if line_index == syntax_error.lineno else ''
            print(apply_text_gradient(f"Line {line_index}: {source_line}{error_marker}"))
        input(apply_text_gradient("Press any key to exit...", reverse=True))
        sys.exit(1)

    current_step += 1
    update_progress(current_step, total_processing_steps)
    time.sleep(0.1)

    marshaled_bytecode = marshal.dumps(compiled_bytecode)
    current_step += 1
    update_progress(current_step, total_processing_steps)
    time.sleep(0.1)

    encryption_key = random.randint(1, 255)
    xor_encrypted_data = bytes(byte_value ^ encryption_key for byte_value in marshaled_bytecode)
    current_step += 1
    update_progress(current_step, total_processing_steps)
    time.sleep(0.1)

    hex_encoded_data = binascii.hexlify(xor_encrypted_data)
    base64_encoded_data = base64.b64encode(hex_encoded_data)
    zlib_compressed_data = zlib.compress(base64_encoded_data)
    lzma_compressed_data = lzma.compress(zlib_compressed_data)
    current_step += 1
    update_progress(current_step, total_processing_steps)
    time.sleep(0.1)

    output_file_path = cleaned_file_path.replace('.py', '_obfuscated.py')

    data_variable_name = generate_variable_name()
    key_variable_name = generate_variable_name()
    lzma_variable_name = generate_variable_name()
    zlib_variable_name = generate_variable_name()
    base64_variable_name = generate_variable_name()
    hex_variable_name = generate_variable_name()
    xor_variable_name = generate_variable_name()
    code_variable_name = generate_variable_name()

    decoder_template = f"""import marshal, zlib, lzma, base64, binascii

{data_variable_name} = {lzma_compressed_data!r}
{key_variable_name} = {encryption_key}

{lzma_variable_name} = lzma.decompress({data_variable_name})
{zlib_variable_name} = zlib.decompress({lzma_variable_name})
{base64_variable_name} = base64.b64decode({zlib_variable_name})
{hex_variable_name} = binascii.unhexlify({base64_variable_name})
{xor_variable_name} = bytes(b ^ {key_variable_name} for b in {hex_variable_name})
{code_variable_name} = marshal.loads({xor_variable_name})
exec({code_variable_name})
"""
    current_step += 1
    update_progress(current_step, total_processing_steps)
    time.sleep(0.1)

    try:
        with open(output_file_path, 'w', encoding='utf-8') as output_file:
            output_file.write(decoder_template)
    except Exception as write_error:
        print(f"\n{apply_text_gradient(f'Error: Failed to write obfuscated file {output_file_path}: {str(write_error)}')}")
        input(apply_text_gradient("Press any key to exit...", reverse=True))
        sys.exit(1)

    current_step += 1
    update_progress(current_step, total_processing_steps)
    time.sleep(0.2)
    
    current_step += 1
    update_progress(current_step, total_processing_steps)
    time.sleep(0.3)
    
    print(f"\n\n{apply_text_gradient('Obfuscation Complete')}")
    print(apply_text_gradient(f"Obfuscated script saved to: {output_file_path}"))
    print(apply_text_gradient("Your code is now protected with multi-layer obfuscation", reverse=True))
    print(apply_text_gradient("Layers applied: AST Transform + Noise + Marshal + XOR + Hex + Base64 + Zlib + LZMA"))
    input(f"\n{apply_text_gradient('Press any key to exit...', reverse=True)}")


