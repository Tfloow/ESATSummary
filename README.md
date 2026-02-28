[![Build](https://github.com/Tfloow/ESATSummary/actions/workflows/build.yml/badge.svg)](https://github.com/Tfloow/ESATSummary/actions/workflows/build.yml)

# ESATSummary
A summary tool for quick and clean summaries

- [ESATSummary](#esatsummary)
  - [Summary Available](#summary-available)
    - [Master 1](#master-1)
    - [Master 2](#master-2)
  - [What is this ?](#what-is-this-)
  - [Compilation](#compilation)
    - [Pro tip](#pro-tip)
  - [Contributing](#contributing)
  - [License](#license)
  
## Summary Available

### Master 1

#### Semester 1

| Short Name         | Description                            |                 Location                 | Percentage complete |
| :----------------- | :------------------------------------- | :--------------------------------------: | ------------------: |
| DDP                | Design of Digital Platform             |        [link](/PDF/M1S1_DDP.pdf)         |                   ✅ |
| DSP_EXAM_August_AI | Gemini answer of DSP questions         | [link](/PDF/M1S1_DSP_EXAM_August_AI.pdf) |                   ✅ |
| DSP_EXAM_BLANK     | Previous DSP questions with blank      |   [link](/PDF/M1S1_DSP_EXAM_BLANK.pdf)   |                   ✅ |
| DSP_EXAM_TRAINING  | Exam I did for DSP                     | [link](/PDF/M1S1_DSP_EXAM_TRAINING.pdf)  |                   ✅ |
| DSP_EXAM           | All previous exam questions until 2025 |      [link](/PDF/M1S1_DSP_EXAM.pdf)      |                   ✅ |
| DSP_script         | DSP lecture text-to-speech             |     [link](/PDF/M1S1_DSP_script.pdf)     |                   ✅ |


#### Semester 2

| Short Name                          | Description                            |                         Location                          | Percentage complete |
| :---------------------------------- | :------------------------------------- | :-------------------------------------------------------: | ------------------: |
| Computer_Architecture               | Computer Architecture summary          |        [link](/PDF/M1S2_Computer_Architecture.pdf)        |                     |
| DAMSIC_Questions                    | Gemini answer of DSP questions         |          [link](/PDF/M1S2_DAMSIC_Questions.pdf)           |                   ✅ |
| DAMSIC                              | Previous DSP questions with blank      |               [link](/PDF/M1S2_DAMSIC.pdf)                |                     |
| Design_of_Digital_IC                | Exam I did for DSP                     |        [link](/PDF/M1S2_Design_of_Digital_IC.pdf)         |                     |
| ecodesign                           | All previous exam questions until 2025 |              [link](/PDF/M1S2_ecodesign.pdf)              |                     |
| Hardware_Security                   | DSP lecture text-to-speech             |          [link](/PDF/M1S2_Hardware_Security.pdf)          |                     |
| Technology_of_Microelectronic_EXTRA | Important values                       | [link](/PDF/M1S2_Technology_of_Microelectronic_EXTRA.pdf) |                   ✅ |

### Master 2

#### Semester 1

| Short Name  | Description                    |             Location              | Percentage complete |
| :---------- | :----------------------------- | :-------------------------------: | ------------------: |
| AI_CPAEP    | AI summary of papers           |  [link](/PDF/M2S1_AI_CPAEP.pdf)   |                   ✅ |
| CAD_IC      | Gemini answer of DSP questions |   [link](/PDF/M2S1_CAD_IC.pdf)    |                40%❌ |
| ComputeAI   | Compute AI summary             |  [link](/PDF/M2S1_ComputeAI.pdf)  |                   ✅ |
| EMI         | EMI summary                    |     [link](/PDF/M2S1_EMI.pdf)     |                   ✅ |
| Measurement | Measurement systems summary    | [link](/PDF/M2S1_Measurement.pdf) |                60%❌ |
| mm_Wave     | mm-Wave summary                |   [link](/PDF/M2S1_mm_Wave.pdf)   |                70%❌ |

#### Semester 2

| Short Name     | Description                            |               Location               | Percentage complete |
| :------------- | :------------------------------------- | :----------------------------------: | ------------------: |
| SW_RT          | Software for Real Time Control summary |     [link](/PDF/M2S2_SW_RT.pdf)      |                   ❌ |
| Image_Analysis | Image Analysis summary                 | [link](/PDF/M2S2_Image_Analysis.pdf) |                   ❌ |
| Religion       | Religion summary                       |    [link](/PDF/M2S2_Religion.pdf)    |                   ❌ |
## What is this ?

It is a small collection of summaries I am making for my classes this semester. For classes that do not have a lot of equation, I prefer using markdown compiled in pdf with pandoc. It is faster than simply using $\LaTeX$ on overleaf.

It gets compiled automatically by github and pushed on main after ~5 minutes so be sure to always 

```
git pull
```

or 

```
git pull -f
```

If needed.

## Compilation

You can clone this repo and compile locally with the `make` command. You will need **[docker](https://docs.docker.com/engine/install/)** installed. This allows that everyone is compiling on the same platform with little requirements (first compilation may take some times to pull the image).

```
make
```

Will compile all of the summaries locally.

You can also simply grabbed the already compiled pdf that gets compiled each time someone push to the main branch. 

Each pdf's are located at:

```
https://raw.githubusercontent.com/Tfloow/ESATSummary/main/PDF/FOLDER_NAME.pdf
```

Like this https://raw.githubusercontent.com/Tfloow/ESATSummary/main/PDF/M2S1_ComputeAI.pdf.

### Pro tip

If you tend to forget pulling before commiting, you can create a new branch like "working" and add all of your summaries, the bot won't compile summaries that aren't on main. And once you are ready to fully compile everything you can merge in main (I just advise you to run locally `make` first to make sure everything is in order).

## Contributing

Thank you for contributing summaries — the process is simple and designed
to keep contributions consistent and easy to build.

- **Fork and Clone the repo:**
  
  First, fork the repository.

  ```pwsh
  git clone https://github.com/YOUR_USERNAME/ESATSummary.git
  cd ESATSummary
  ```

- **Create a new summary scaffold:**

  Use the `make` helper to create a new summary folder and boilerplate. Replace
  the placeholders with your values (folder name, semester, title and author):

  ```pwsh
  make create_summary DIR='os' SEMESTER='M1S2' TITLE='Operating Systems' AUTHOR='Your Name'
  ```

  - `DIR` — short folder name used for file paths (lowercase, no spaces).
  - `SEMESTER` — semester identifier (e.g. `M1S2`), used to place the summary
    in the correct top-level folder.
  - `TITLE` — human-readable title used in the PDF metadata.
  - `AUTHOR` — author name to be shown in the document.

- **Edit your summary:**

  - Write content in `summary.md` (or the LaTeX file provided by the template).
  - Add images under the `img/` folder inside the summary directory.
  - Keep each summary self-contained and avoid committing large binaries.

- **Build locally (recommended):**

  The project uses Docker for deterministic builds. Install Docker and then run:

  ```pwsh
  make
  ```

  This builds all summaries and produces PDFs in the `PDF/` directory. Running
  `make` locally helps catch formatting issues before pushing.

## License

All summaries are based on class given by Professors at KU Leuven. If a professor or a TA desire to take offline a summary, they can do so by opening a [new issue](https://github.com/Tfloow/ESATSummary/issues/new?template=takedown_notice.yml) with the "Take down notice" template.

---

[my website](https://thomas.debelle.be)