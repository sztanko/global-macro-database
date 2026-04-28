# Global Macro Database Dashboard Task

Objective: Analyze Global Macro Database data.

**What:** https://www.globalmacrodata.com/data.html

**How:** You will use the Global Macro Database to create a dashboard that visualizes insights from the data. The dashboard should be built using a free dashboarding framework called Evidence.dev, which allows you to create interactive and visually appealing dashboards using simple Markdown-like syntax with sql embedded.

**When:** You have one week to complete this task. Please ensure that you allocate enough time for data exploration, analysis, and dashboard creation.

**Who:** You, can use any kind of AI tool for this. But make sure you drive the analysis and not the AI.

**How we evaluate your report:**

- Correctness - the data you show should be cleaned up and correct. Do not demo incomplete or wrong data.
- Insights - the report you present should unveil something not evident and intereting otherwise.
- Presentation - dashboards should be aethetically pleasing and easy to read, not informationally overloaded.
- Communication - You should be able to create a story about it and present it in a way that is easy to understand.

Create an Evidence dashboard with one or more pages that highlights some interesting insights from the Global Macro Database. You can focus on any aspect of the data that you find intriguing, such as GDP trends, inflation rates, or other macroeconomic indicators. It is up to you what topic you choose to analyze. You can use the data as is, or you can enrich it with other data sources. You should use the data to create a dashboard that visualizes the insights you found.

Report has to be done in Evidence.dev, comitted to a public github repo and the generated static html page published to github pages. There is a Github action set up already that should publish your report on each commit. 
You can find the documentation about how to use Evidence here: https://docs.evidence.dev/components/all-components/
Information on deploying to GitHub pages is here: https://docs.evidence.dev/deployment/self-host/github-pages/

Once it is done, please sned us the link to the GitHub repo and the link to the published dashboard.

We will have a look at it and get back to you with feedback. If we like it, we will invite you to a follow-up interview where you can present your dashboard and discuss your approach.


# Workflow
- You need a github account to work on this task. Since the repository is going to be public, you might want to use a throwaway account.
- Fork this repository to your account: https://github.com/sztanko/global-macro-database
- use github codespaces to work on the report. It has all the tools you need preinstalled. In this way, you don't need to install anything on your local machine. All you need is a browser and a github account.
- run `npm run dev` to start the local development server and preview your dashboard. A preview of your dashboard will open in a separate tab.
- start editing `pages/index.md` and other md files you create under `pages` folder.  Any changes you make will be shown in the preview you have opened in the previous step. Documentation can be found here: https://docs.evidence.dev/
- Don't forget to commit and push your changes to the repo.
- you can browse the table structure and data in the DuckDB CLI, which is installed in the devcontainer. Just run `duckdb sources/gmd/gmd.duckdb --ui` in your command line.
- For your convenience, we have included evidence_prompt.md file. You can use it to supply some context to the AI tools you use. It is not required, but it might help you to get better results.
- GMD.csv is here for documentation reasons - you can see the data structure and the data. You can use it to understand the data better, but you should not use it in your report. The actual data is in the DuckDB database.
- there is some example code in the `pages/index.md` file. Feel free to overwrite it with your own code. You can also create new pages in the `pages` directory. See Evidence.dev documentation for more details on how to create pages and components.

## Using Codespaces


Or you can use the following commands to get started:

```bash
npm install
npm run sources
npm run dev -- --host 0.0.0.0
```

See [the CLI docs](https://docs.evidence.dev/cli/) for more command information.

**Note:** Codespaces is much faster on the Desktop app. After the Codespace has booted, select the hamburger menu → Open in VS Code Desktop.



## Learning More

- [Docs](https://docs.evidence.dev/)
- [Github](https://github.com/evidence-dev/evidence)
