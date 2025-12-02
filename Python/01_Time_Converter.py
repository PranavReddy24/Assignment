def minutes_conversion(minutes):
    hr = minutes//60
    mi = minutes%60
    return f"{hr} hrs {mi} minutes"

input_time = int(input(""))
print(minutes_conversion(input_time))