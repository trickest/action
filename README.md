<h1 align="center">Trickest Action <a href="https://twitter.com/intent/tweet?text=GitHub%20Action%20for%20Trickest%20Workflows%20https%3A%2F%2Fgithub.com%2Ftrickest%2Faction%20%23infosec%20%23recon%20%23bugbountytips%20%23redteam"><img src="https://img.shields.io/badge/Tweet--lightgrey?logo=twitter&style=social" alt="Tweet" height="20"/></a></h1>
<h3 align="center">GitHub Action for Trickest Workflows
</h3>


This action is using [Trickest Client](https://github.com/trickest/trickest-cli) execute function to manipulate the directory structures, execute the workflow, and download its output.

It can be used for various purposes such as 
* Vulnerability Scanning
* Misconfiguration Scanning
* Container Security
* Web Application Scanning
* Asset Discovery
* Network Scanning
* Fuzzing
* Static Code Analyis
* ... and a lot more

For more workflow examples, check out the [Trickest Store](https://trickest.io/dashboard/store).

[<img src="./banner.png" />](https://trickest-access.paperform.co/)

## Table of Contents

  - [Environment Variables](#environment-variables)
  - [Example Workflows](#example-workflows)
    - [For Remote Executions](#for-remote-executions)
    - [For Local Executions](#for-local-executions) (Coming soon!)
  - [License](#license)


## Environment Variables

Authentication token can be supplied as an environment variable TRICKEST_TOKEN.

## Available Inputs


| Key                 | Description                                                                                                             | Required |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------| -------- |
| `space`             | Space where the workflow will be executed                                                                               | true     |
| `workflow`          | Workflow name to be executed. If not present, it will be copied from the store. (https://trickest.io/dashboard/store )  | true     |
| `project`           | Project where workflow will be executed, not required.                                                                  | false    |
| `config_path`       | Configuration for the workflow. Example can be found at config.yaml.                                                    | false    |
| `workflow_new_name` | Executes a workflow from store and creates new one with data provided.                                                  | false    |
| `output_dir`        | Output directory for output files and folders                                                                           | false    |
| `show_params`       | Show parameters in the workflow tree                                                                                    | false    |
| `watch`             | Watch the execution in real time                                                                                        | false    |
| `output`            | Download specific node's outputs                                                                                        | false    |
| `create_structure`  | Create spaces and projects if they don't exist.                                                                         | false    |
| `max_machines`      | Use maximum number of machines for workflow execution                                                                   | false    |


## Example Workflows

### For Remote Executions 

Execute worfklows directly from the Store or already present workflows in your workspace.

```yml
---
name: Trickest Client

on:
  push:

jobs:         
  trickest-execute-workflow:
    runs-on: ubuntu-latest
    steps:

    - name: Check Out
      uses: actions/checkout@main

    - name: Trickest Execute
      id: trickest
      uses: trickest/action@main
      env:
        TRICKEST_TOKEN: "${{ secrets.TRICKEST_TOKEN }}"
      with:
        workflow: "Simple Visual Recon"
        space: "CI-CD"
        create_structure: true
        project: "v1.0"
        watch: true
        output_dir: reports
        #output_all: true
        output: "zip-to-out"
        config: config.yaml
```

`config.yaml`

```
inputs:   # List of input values for the particular workflow nodes.
  amass-1.domain: example.com # <node_id>.<parameter_name>: <parameter_value>
machines: # Machines configuration by type related to execution parallelisam.
  large:  1
outputs:  # List of nodes whose outputs will be downloaded.
  - zip-to-out
```

## License

- [MIT License](https://github.com/trickest/action/blob/main/LICENSE)

[<img src="./banner.png" />](https://trickest-access.paperform.co/)
