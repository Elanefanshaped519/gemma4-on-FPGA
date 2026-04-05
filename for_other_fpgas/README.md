# Other FPGA Pack

This folder groups the core artifacts needed for bring-up on other FPGA targets.

Included:
- omni_titan_agi_top.bit
- weights_int4_FINAL.bin.part01
- weights_int4_FINAL.bin.part02
- weights_int4_FINAL.bin.part03
- model_contract.json
- tokenizer/
- SHA256SUMS
- BASE_L2_ANCHORING.md
- base_l2_anchor_receipt.json

Important:
- The `.bit` file is board-specific and may not run on different FPGA boards without a new build/port.
- The weights are split into 3 parts to fit GitHub upload limits.
- Reassembled `weights_int4_FINAL.bin` must match SHA-256:
  - `7ba5c0c5b350a8b0c50c7ec7fe30b64064bee4f13ce6d588eeb826d84d3644ce`

Reassemble:
- Linux/macOS:
  - `cat weights_int4_FINAL.bin.part01 weights_int4_FINAL.bin.part02 weights_int4_FINAL.bin.part03 > weights_int4_FINAL.bin`
  - `sha256sum weights_int4_FINAL.bin`
- PowerShell:
  - `$parts = 'weights_int4_FINAL.bin.part01','weights_int4_FINAL.bin.part02','weights_int4_FINAL.bin.part03'`
  - `$out = [System.IO.File]::Create('weights_int4_FINAL.bin'); foreach($p in $parts){ $in=[System.IO.File]::OpenRead($p); $in.CopyTo($out); $in.Dispose() }; $out.Dispose()`
  - `Get-FileHash -Algorithm SHA256 .\\weights_int4_FINAL.bin`

Anchoring:
- Hashes for `.bit` and `.bin` are anchored on Ethereum L2 Base.
- See `BASE_L2_ANCHORING.md` for tx links and `base_l2_anchor_receipt.json` for machine-readable proof.
