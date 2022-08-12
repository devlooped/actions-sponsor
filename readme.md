# ❤️ sponsor

A GitHub Action that labels issues and pull requests if the creator is a sponsor, 
or belongs to an organization that is.

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
    # Typically set to ${{ secrets.GH_TOKEN }}.
    token: ''
```

> NOTE: in order to detect the sponsorship tier to trigger gold sponsor labeling, 
> the token must be an owner of the sponsorable organization. Otherwise, only   
> base sponsoring is detected.

## Example

Minimal example, using default labels, repo owner and gold label threshold:

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
          token: ${{ secrets.GITHUB_TOKEN }}
```

Full example overriding all values:


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
          label: sponsor
          gold-label: gold sponsor
          gold-amount: 1000
          sponsorable: moq
          token: ${{ secrets.MOQ_TOKEN }}
```

Note: the provided token must have access to retrieve sponsorships for 
the sponsorable account.

<!-- include https://github.com/devlooped/sponsors/raw/main/footer.md -->
# Sponsors 

<!-- sponsors.md -->
[![Clarius Org](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/clarius.png "Clarius Org")](https://github.com/clarius)
[![Christian Findlay](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/MelbourneDeveloper.png "Christian Findlay")](https://github.com/MelbourneDeveloper)
[![C. Augusto Proiete](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/augustoproiete.png "C. Augusto Proiete")](https://github.com/augustoproiete)
[![Kirill Osenkov](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/KirillOsenkov.png "Kirill Osenkov")](https://github.com/KirillOsenkov)
[![MFB Technologies, Inc.](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/MFB-Technologies-Inc.png "MFB Technologies, Inc.")](https://github.com/MFB-Technologies-Inc)
[![Amazon Web Services](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/aws.png "Amazon Web Services")](https://github.com/aws)
[![SandRock](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/sandrock.png "SandRock")](https://github.com/sandrock)


<!-- sponsors.md -->

[![Sponsor this project](https://raw.githubusercontent.com/devlooped/sponsors/main/sponsor.png "Sponsor this project")](https://github.com/sponsors/devlooped)
&nbsp;

[Learn more about GitHub Sponsors](https://github.com/sponsors)

<!-- https://github.com/devlooped/sponsors/raw/main/footer.md -->
