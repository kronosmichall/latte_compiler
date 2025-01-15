import glob
import os
import subprocess

subprocess.run("make")

dir = "mrjp-tests/good/basic/"
latte_files = f"{dir}*.lat"
print(f"latte files {latte_files}")
latte_files = glob.glob(latte_files)
output_files = f"{dir}*.output"
output_files = glob.glob(output_files)

good = 0
all = 0
for latte in latte_files:
    try:
        base = os.path.splitext(latte)[0]
        bc = f"{base}.bc"
        output: str = f"{base}.output"
        input = f"{base}.input"

        instr = f"./checker {latte} && chmod +x {bc} && ./{bc}"
        print("running", instr)
        # if os.path.exists(input):
        #     with open(input) as input_file:
        #         instr += f" << {input_file.read()}"
        out = subprocess.run(instr, shell=True, capture_output=True)
        out = out.stdout.decode("utf-8")

        with open(output) as outfile:
            if outfile.read() == out:
                print(f"file {latte} GOOD")
                good += 1
            else:
                print(f"\n\n\nfile {latte} FAILED")
                print("EXPECTED")
                print(outfile.read())
                print("GOT")
                print(out)
                print("\n\n\n")
    except Exception as e:
        print(f"exception {e}")
    all += 1

print(f"got {good}/{all}")
