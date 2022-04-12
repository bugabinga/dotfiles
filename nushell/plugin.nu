register /home/oli/.cargo/bin/nu_plugin_gstat -e json  {
  "name": "gstat",
  "usage": "Get the git status of a repo",
  "extra_usage": "",
  "required_positional": [],
  "optional_positional": [
    {
      "name": "path",
      "desc": "path to repo",
      "shape": "Filepath",
      "var_id": null,
      "default_value": null
    }
  ],
  "rest_positional": null,
  "named": [
    {
      "long": "help",
      "short": "h",
      "arg": null,
      "required": false,
      "desc": "Display this help message",
      "var_id": null,
      "default_value": null
    }
  ],
  "is_filter": false,
  "creates_scope": false,
  "category": {
    "Custom": "Prompt"
  }
}

