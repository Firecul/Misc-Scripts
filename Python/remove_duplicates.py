def remove_duplicates(input_file, output_file):
    with open(input_file, 'r') as file:
        content = file.read()
        word_list = content.split()

    unique_words = list(set(word_list))

    with open(output_file, 'w') as file:
        for word in unique_words:
            file.write(word + '\n')

    print("Duplicate words removed and unique words saved to", output_file)


# Example usage
input_file = 'input.txt'
output_file = 'output.txt'
remove_duplicates(input_file, output_file)
