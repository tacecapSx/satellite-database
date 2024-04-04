import random

def make_id(number):
    s = str(number)
    return f"{'0' * (8 - len(s))}{s}"

employee_total = 103
mission_total = 8

connections = 40

participation_list = []

for i in range(connections):
    participation_list.append(f"('{make_id(random.randint(0,employee_total - 1))}', '{make_id(random.randint(0,mission_total - 1))}'),")

for p in participation_list:
    print(p)