import random

def get_random_line(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()
        return random.choice(lines).strip()

def make_id(number):
    s = str(number)
    return f"{'0' * (8 - len(s))}{s}"

start_id = 0
agency_max = 6
employee_amount = 100

employee_list = []

for i in range(employee_amount):
    title = random.choice(['Engineer', 'Technician', 'Researcher', 'Astrophysicist'])
    salary = random.randint(1,100) * 500
    gender = random.randint(0,1)
    full_name = f"{(get_random_line('male_first_name.txt') if gender == 0 else get_random_line('female_first_name.txt'))} {get_random_line('last_names.txt')}"
    _id = make_id(i + start_id)
    agency_id = make_id(random.randint(0,agency_max))
    employee_list.append(f"('{_id}', '{agency_id}', '{full_name}', {salary}, '{title}'),")

for e in employee_list:
    print(e)