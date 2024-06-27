def find_unique_words(output_file, minus_file, difference_file):
    with open(output_file, 'r') as f_output, open(minus_file, 'r') as f_minus, open(difference_file,
                                                                                    'w') as f_difference:
        output_words = set(f_output.read().split())
        minus_words = set(f_minus.read().split())
        unique_words = output_words - minus_words
        f_difference.write("\n".join(unique_words))


output_file = "output.txt"
minus_file = "minus.txt"
difference_file = "difference.txt"
find_unique_words(output_file, minus_file, difference_file)
