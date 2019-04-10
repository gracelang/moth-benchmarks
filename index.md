

This document gives an overview of the experimental setup to run benchmarks and produce results for our paper. Here:

- we first provide [brief setup instructions](#getting-started-guide) to facilitate re-execution of the benchmarks and replication of the results' figures,
- we then [reiterate our claims](#artifact-and-claims) and summarize how our artifact can be used to verify them.

Finally, we provide [step-by-step](#step-by-step) instructions that outline how to build our project from source.

<a name="getting-started-guide"></a>

## 1. Getting Started Guide

The artifact is provided as a VirtualBox image that has our experimental setup and its dependencies already installed. For separate source and data downloads, please see Section 3.

#### 1.1 Download

You can download the image using one of these mirrors:

- Download [Mirror 1][mirror_1]
- Download [Mirror 2][mirror_2]

Please verify that the MD5 check sum matches `d7ac6b99ba4f02efe2ac8f7685176a80`.

#### 1.2 Setup instructions

The VirtualBox image was created with [Vagrant][vagrant] (version ), using [Virtual Box][virutalbox] (version 5.2)

The image contains a Ubuntu 16.04 installation. As usual, booting the image launches a shell with a login prompt. Please login using the following credentials:

- username: `vagrant`
- password: `vagrant`

#### 1.3 Setting up a desktop environment (optional)

To reduce the size of the image, we do not include a desktop environment. We suggest copying figures to the host machine for viewing.

If a desktop environment is preferred we recommend installing Unity (the standard Ubuntu desktop). Unity can be installed by executing: `sudo apt-get install ubuntu-desktop`; an internet connection will be required to install the desktop environment. 

#### 1.4 Basic experiment execution

<a name="basicrun"></a>

We use [Rebench][rebench] to automate the execution of our benchmarks. Rebenchmark uses a configuration file to determine which benchmarks should be run on which virtual machines. The configution file can be found at `moth-benchmarks/codespeed.conf`. The file will tell rebench to run each of our benchmarks against a number of virtual machines: Java, NodeV8, Moth (without typing), Moth (with typing), and Higgs. As each execution completes, Rebench saves the results to `data/benchmark.data`. After rebench has finished, the performance results can be rendered using the R program at: `moth-benchmarks/somewhere.R`. The rendered figures can be found at `moth-benchmarks/results`.

To perform the steps above, the following commands should be used:

```bash
cd /home/vagrant/moth-benchmarks
rebench codespeed.conf
cp -r results hostmachine
```

Please refer to this [supplementary document][evaluation_supplementary] for further information on using the R program.

<a name="artifact-and-claims"></a>

## 2. The artifact and claims

The artifact provided with our paper are intended to enable others to verify our claims. Our claims are:

1. that our support for type checking does not occur significant overhead
2. that Moth's performance is comparable to that of NodeV8, for the given set of benchmark programs, and
3. that the size of our implementation for type checking is as stated by the paper.

To support verification of claims 1 and 2, we suggest first running the full benchmark set (see [Section 1.4][#basicrun]). The figures presented in our paper can be reproduced from the results of those benchmarks. Note that execution time will differ. Furthermore, benchmarks may be executed individually using the rebench tool (the process for doing this is outlined in Section 3).

Claim 3 can be verified by examining the code responsible for executing the type checking. As outlined by the paper, the support for type checing is primarily handled by the self-optimizing `TypeCheckNode` (170 lines). The types themselves are represented by the `SomStructuralType` class (205 lines). These implementation of these can be found at:

- `moth-benchmarks/implementations/Moth/som/interpreter/nodes/dispatch/TypeCheckNode.java
- `moth-benchmarks/implementations/Moth/som/vm/SomStructuralType.java

Beyond the above, minor changes have been to enable the above classes to be used during parsing and execution of the Grace program. The easiest way to identity these changes is to open our the source code in a Java IDE (we used [Eclipse Oxygen][eclipse_oxy]).



<a name="step-by-step"></a>

## 3. Step-by-step instructions

This section gives a detailed overview of how to download and build our project from source.

#### 3.1 Install dependencies

The core of Moth is [a fork of SOMns](https://github.com/gracelang/moth-somns). It uses Truffle and Graal, which implement Java's compiler interface. We use [Java SE 8][java8], along with the [Oracle Labs JDK 8][jvmci] that provides the compiler interface. *Note: Java >=9 provide the compiler interface, but have not be tested with Truffle and Graal as extensively as Java 8.*

Beyond Java, the following software is also required:

For build tools:

- Git
- Ant 
- Python 2.7 and pip 

For VMs

- `dmd`, provided as part of the D-compiler (Higgs only)
- `xbuild`, provided by mono-devel (Moth only)

For benchmark execution:

- ReBench, `pip install git+https://github.com/smarr/ReBench`

For rendering benchmarks:

- R 

#### 3.1 Source code

We provide two options to obtain the source code of our project repository and its submodules:

- download the [tarball][source_tarball] containing all source code, or
- clone the `paper-experiments` branch of our repository: `git clone --recursive -b paper-experiments git@github.com:gracelang/moth-benchmarks.git`.

#### 3.2 Build VMs

We provide a bash script to build each of the virtual machines. These scripts can be executed individually by navigating to the `moth-benchmarks/implementations` directory and running the scripts.

```bash
cd moth-benchmarks  # folder with the repository
cd implementations  # sources of each VM.
for f in build-*; do sh $f; done
```

This will build Moth, along with the other virtual machines: SOMns, Node, and Higgs. 

### 3.3 Execution and Rendering 

To execute the benchmarks, we use the [ReBench](https://github.com/smarr/ReBench) benchmarking tool. The experiments and all benchmark parameters are configured in the `codespeed.conf` file (inside the root directory). The file describes which benchmarks to run on which virtual machines. Note that the names used in the configuration file are post-processed for the paper in the R scripts used to generate graphs, thus, the configuration contains all necessary information to find the benchmark implementations in the repositories, but does not match exactly the names in the paper.

To use rebench, enter the following commands:

```bash
cd moth-benchmarks      # folder with the repository
rebench codespeed.conf  # runs with additional debug output
```

As rebench executes, it saves performance results into `data/benchmark.data`. If rebench is terminated and restarted, it will continue restart from the point where it was terminated (if terminated mid-execution, it will restart that benchmark).

Before the results can be rendered, a few R libraries have to be installed. For this step R might require superuser rights. See `scripts/libraries.R` for details. 

```
sudo Rscript scripts/libraries.R
```

After the libraries have been installed, the figures can be repliacted using the `Something.R` script. The figures are saved to `moth-benchmarks/figures`. 

## 4. Licensing

The material in this repository is licensed under the terms of the MIT License. Please note, the repository links in form of submodules to other repositories which are licensed under different terms.

[github]: https://gitlab.com/richard-roberts/moth-benchmarks
[vagrant]: https://vagrantup.com
[virutalbox]: https://www.virtualbox.org/
[mirror_1]: https://google.com
[mirror_2]: https://google.com
[original_data_set]: https://google.com
[source_tarball]: https://google.com
[evaluation_supplementary]: https://google.com
[rebench]: https://github.com/smarr/ReBench
[eclipse_oxy]: https://www.eclipse.org/oxygen/
[jvmci]: https://www.oracle.com/technetwork/oracle-labs/program-languages/downloads/index.html
[java8]: http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html#jdk-8u31-oth-JPR

