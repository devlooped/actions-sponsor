# ❤️ sponsor

A GitHub Action that labels issues and pull requests if the creator is a sponsor.

## Usage

```
- name: ❤️ sponsor
  uses: devlooped/actions-sponsor@v1
  with:
    # The label to apply to the issue or pull request. 
    # Defaults to "sponsor ❤️".
    label: ''

    # The label to apply when sponsor amount is above the gold-amount. 
    # Defaults to "sponsor 💛".
    gold-label: ''

    # Sponsors over this amount are labeled with gold-label instead. 
    # Defaults to 100.
    gold-amount: ''

    # The account to check for sponsorship. 
    # Defaults to the repository owner `${{ github.repository.owner }}`
    sponsorable: ''

    # The token to use for querying the GitHub API for sponsorship information. 
    # Typically set to ${{ secrets.GITHUB_TOKEN }}.
    token: ''
```

## Example

```yml
name: sponsor ❤️
on: [issues, pull_request]

jobs:
  sponsor:
    runs-on: ubuntu-latest
    steps:
      - name: ❤️ sponsor 
        uses: devlooped/actions-sponsor@v1
        with:
          sponsorable: devlooped
          token: ${{ secrets.GITHUB_TOKEN }}
```

<!-- include docs/footer.md -->
## Sponsors 

<!-- sponsors.md -->
[![Kirill Osenkov](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/KirillOsenkov.png "Kirill Osenkov")](https://github.com/KirillOsenkov)
[![C. Augusto Proiete](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/augustoproiete.png "C. Augusto Proiete")](https://github.com/augustoproiete)
[![SandRock](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/sandrock.png "SandRock")](https://github.com/sandrock)
[![Amazon Web Services](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/aws.png "Amazon Web Services")](https://github.com/aws)
[![Christian Findlay](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/MelbourneDeveloper.png "Christian Findlay")](https://github.com/MelbourneDeveloper)
[![Clarius Org](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/clarius.png "Clarius Org")](https://github.com/clarius)
[![MFB Technologies, Inc.](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/MFB-Technologies-Inc.png "MFB Technologies, Inc.")](https://github.com/MFB-Technologies-Inc)


<!-- sponsors.md -->

[![Sponsor this project](https://raw.githubusercontent.com/devlooped/sponsors/main/sponsor.png "Sponsor this project")](https://github.com/sponsors/devlooped)
&nbsp;

[Learn more about GitHub Sponsors](https://github.com/sponsors)

<!-- docs/footer.md -->
