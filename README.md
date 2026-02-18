
<!-- README.md is generated from README.Rmd. Please edit README.Rmd -->

# zipAuditR

<img src="man/figures/zipAuditR_hex.png" align="right" alt="" width="200" />

**Lightweight tools for auditing and comparing ZIP archives — without
extracting them.**

## What problem does zipAuditR solve?

Most people who work with ZIP archives eventually face one or more of
these painful questions:

- What files are actually inside this ZIP file — without unzipping
  several gigabytes?
- Which files appear in multiple archives (same name + same size)?
- How much total uncompressed data do I really have across 50 backup
  ZIPs?
- Are there obvious filename collisions or redundant copies across
  different archives?

Common existing solutions are either:

- slow and disk-intensive (full extraction + comparison)
- heavyweight (extra heavy packages like {archive}, {7z}, Java bridges…)
- single-archive focused (no easy batch comparison)

**zipAuditR** provides a minimal, fast, read-only way to:

- list file metadata from one or many ZIP files
- detect potential duplicates by filename + uncompressed size
- get quick summary statistics across multiple archives

All with very few dependencies and **no extraction step**.

## Installation

You can install the development version like this:

``` r
# Install from GitHub (development version)
# install.packages("remotes"), if not already installed
remotes::install_github("abiyug/zipAuditR")
```

## Quick examples

### 1. See what’s inside a single archive

``` r
z1 <- system.file("extdata", "sample1.zip", package = "zipAuditR")

list_zip_contents(z1)
#> # A tibble: 3 × 3
#>   filename  size date               
#>   <chr>    <dbl> <dttm>             
#> 1 big.txt   1200 2026-02-17 13:12:00
#> 2 a.txt       20 2026-02-17 13:10:00
#> 3 dup1.txt    13 2026-02-17 13:12:00
```

### 2. Find files that appear in multiple archives

``` r
z2 <- system.file("extdata", "sample2.zip", package = "zipAuditR")

detect_duplicates(c(z1, z2))
#> # A tibble: 2 × 4
#>   filename  size date                archive    
#>   <chr>    <dbl> <dttm>              <chr>      
#> 1 big.txt   1200 2026-02-17 13:12:00 sample1.zip
#> 2 big.txt   1200 2026-02-17 13:12:00 sample2.zip
```

> At the moment the sample files contain no exact filename + size
> matches — hence 0 rows.  
> When real duplicates exist, you get one row per matching file (grouped
> by filename & size).

### 3. Get a summary table across several ZIPs

``` r
summarize_zip(c(z1, z2))
#> # A tibble: 2 × 5
#>   archive     n_files total_bytes largest_file_b n_dupe_filenames
#>   <chr>         <int>       <dbl>          <dbl>            <int>
#> 1 sample2.zip       4        2235           1200                0
#> 2 sample1.zip       3        1233           1200                0
```

## Main functions at a glance

| Function | What it does | Main columns / output |
|----|----|----|
| `list_zip_contents()` | List files + metadata from one ZIP | filename, size (uncompressed), date |
| `detect_duplicates()` | Find files with identical name + size across ZIPs | filename, size, date, archive (one row per match) |
| `summarize_zip()` | Overview statistics for one or many archives | archive, n_files, total_bytes, largest_file_b, n_dupe_filenames |

All functions return tibbles and accept one or more paths.

## Current limitations

- Only **uncompressed** size is available (base `utils::unzip()`
  limitation)  
- Duplicate detection is based on **filename + uncompressed size** — not
  content hash  
- No support for password-protected or split ZIP files  
- Very large ZIPs with thousands of entries may be slow to list (but
  still much faster than extraction)

Future ideas (if there is interest):

- optional content hashing via {digest} (Suggests)
- real compressed size via temporary extraction or {zip} package
- folder scanning (`fs::dir_ls(regexp = "\\.zip$")`)

## Why this package exists

It was built for people who need to **quickly audit** ZIP collections —
data scientists, archivists, backup managers, researchers dealing with
shared datasets, sysadmins checking download folders, etc. — without
turning their disk into a temporary unzipped mess.

## License

MIT © dataRecode
