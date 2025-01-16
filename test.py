import glob
import os
import subprocess

subprocess.run("make")

# dir = "mrjp-tests/good/basic/"
dir = "lattests/good/"
latte_files = f"{dir}*.lat"
print(f"latte files {latte_files}")
latte_files = glob.glob(latte_files)
output_files = f"{dir}*.output"
output_files = glob.glob(output_files)

good = 0
all = 0
for latte in sorted(latte_files):
    try:
        base = os.path.splitext(latte)[0]
        bc = f"{base}.bc"
        output: str = f"{base}.output"
        input = f"{base}.input"

        instr = f"./checker {latte} && chmod +x {bc}"
        instr2 = f"./{bc}"
        try: 
            with open(input) as input_file:
                instr2 += f" < {input}"
        except: pass 

        out1 = subprocess.run(instr, shell=True, capture_output=True)
        print(instr2)
        out = subprocess.run(instr2, shell=True, capture_output=True)
        out = out.stdout.decode("utf-8")

        with open(output) as outfile:
            exp = outfile.read()
            if exp == out:
                print(f"file {latte} GOOD")
                good += 1
            else:
                print(f"\n\n\nfile {latte} FAILED")
                print(out1)
                print("EXPECTED")
                print(exp)
                print("GOT")
                print(out)
                print("\n\n\n")
    except Exception as e:
        print(f"exception {e}")
    all += 1

print(f"got {good}/{all}")
