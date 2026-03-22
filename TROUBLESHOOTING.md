# Troubleshooting

Common issues encountered when running this pipeline.

## BUSCO import errors (numpy conflict)

**Symptom:**
```
ImportError: cannot import name 'bool' from 'numpy'
```
or
```
AttributeError: module 'numpy' has no attribute 'bool'
```

**Cause:** BUSCO 5.x requires numpy 1.x. numpy 2.0 removed several deprecated aliases.

**Fix:** The `longread_assembly.yaml` environment file already pins `numpy<2`. If you built your environment without it:
```bash
conda install -c conda-forge "numpy<2"
```

---

## hifiasm runs but produces empty FASTA

**Symptom:** `primary.fasta` is empty or very small after the `awk` conversion.

**Cause:** The GFA file may be empty or the wrong file was converted.

**Fix:** Check which GFA files were produced:
```bash
ls -lh results/assembly/*.gfa
```
Then verify the primary contig GFA has sequence content:
```bash
grep "^S" results/assembly/candida_hifiasm.p_ctg.gfa | head -5
```
If S-lines are present, the awk command should work. If the file is empty, hifiasm may have failed silently — check the terminal output for memory errors (hifiasm needs ~32 GB RAM for this dataset).

---

## fasterq-dump / fastq-dump hangs or fails

**Symptom:** Download stalls or errors with network timeout.

**Fix:** Try prefetching first, then dumping:
```bash
prefetch SRR23724250
fasterq-dump SRR23724250 --outdir ../data/
```
Or use the `--split-files` flag to download in parts:
```bash
fasterq-dump SRR23724250 --split-files --outdir ../data/
```

---

## NanoPlot fails with "No reads passed the filter"

**Symptom:** NanoPlot exits with a warning that all reads were filtered.

**Cause:** NanoPlot applies a default minimum read length filter. For HiFi data with some short reads this can be too aggressive.

**Fix:** Disable the filter explicitly:
```bash
NanoPlot --fastq ../data/SRR23724250.fastq \
    --outdir ../results/qc/nanoplot_output \
    --prefix candida_hifi_ \
    --minlength 0
```

---

## QUAST fails with Glimmer errors

**Symptom:** QUAST errors on the `--glimmer` gene prediction step.

**Fix:** Run QUAST without Glimmer — the core assembly statistics don't require it:
```bash
quast.py ../results/assembly/primary.fasta \
    -o ../results/assembly/quast_results
```

---

## BUSCO takes very long or runs out of memory

**Note:** BUSCO on a 22 Mb assembly against `fungi_odb10` (758 genes) can take 1–3 hours depending on CPU speed. This is normal — it runs MetaEuk internally which is compute-intensive.

If you run out of memory, reduce the number of threads in `04_assessment.sh`:
```bash
busco ... --cpu 4
```
The script currently uses the default thread count; add `--cpu N` to limit it.

---

## Bandage won't load the GFA files

**Note:** The large GFA files (r_utg, p_utg) with 300+ edges can be slow to load. Give Bandage 30–60 seconds on first load. Use **Draw graph** after loading to render.

For the `.noseq.gfa` variant (no sequences, just topology), load times are much faster if you just want to explore graph structure without sequences.
