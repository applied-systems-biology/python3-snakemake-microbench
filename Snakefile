import os

import algorithms

print("Input read from " + config["input"])
print("Output written to " + config["output"])

if not config["input"].endswith("/"):
    config["input"] += "/"
if not config["output"].endswith("/"):
    config["output"] += "/"

if not os.path.exists(config["output"]):
    os.makedirs(config["output"])

# Collect sample information
samples = {}

for sample_name in os.listdir(config["input"]):
    sample_path = config["input"] + "/" + sample_name
    output_path = config["output"] + "/" + sample_name
    if not os.path.isdir(sample_path):
        continue

    samples[sample_name] = {}

    print("Sample " + sample_name)

rule all:
    input: expand(config["output"] + "{sample}/runtime.csv", sample=list(samples.keys()))

rule microbenchmark:
    input: config["input"] + "{sample}/in/data.tif"
    output: config["output"] + "{sample}/runtime.csv"
    run:
        algorithms.microbench(input_file=input[0], output_folder=config["output"] + wildcards["sample"])


rule input_files:
    output: config["input"] + "{sample}/in/data.tif"