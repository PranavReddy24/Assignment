stg = input()

result = ""
for lett in stg:
    if lett not in result:
        result += lett

print(result)
