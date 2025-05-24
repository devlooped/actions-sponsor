# 💜 sponsor

A GitHub Action that labels issues and pull requests if the creator is a sponsor, 
or belongs to an organization that is.

## Usage

```
- name: 💜 sponsor
  uses: devlooped/actions-sponsor@v1
  with:
    # The label to apply to the issue or pull request. 
    # Defaults to "sponsor 💜".
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
name: sponsor 💜
on: 
  issues:
    types: [opened, edited, reopened]
  pull_request:
    types: [opened, edited, synchronize, reopened]

jobs:
  sponsor:
    runs-on: ubuntu-latest
    if: ${{ !endsWith(github.event.sender.login, '[bot]') && !endsWith(github.event.sender.login, 'bot') }}      
    steps:
      - name: 🤘 checkout
        uses: actions/checkout@v2
    
      - name: 💜 sponsor 
        uses: devlooped/actions-sponsor@v1
        with:
          token: ${{ secrets.GH_TOKEN }}
```

> NOTE: you will typically want to skip running the workflow at all for bot accounts, hence the `if` above.

Full example overriding all values (and running on *all* issue/PR events):

```yml
name: sponsor 💜
on: [issues, pull_request]

jobs:
  sponsor:
    runs-on: ubuntu-latest
    if: ${{ !endsWith(github.event.sender.login, '[bot]') && !endsWith(github.event.sender.login, 'bot') }}      
    steps:
      - name: 🤘 checkout
        uses: actions/checkout@v2

      - name: 💜 sponsor 
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
[![MFB Technologies, Inc.](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/MFB-Technologies-Inc.png "MFB Technologies, Inc.")](https://github.com/MFB-Technologies-Inc)
[![Torutek](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/torutek-gh.png "Torutek")](https://github.com/torutek-gh)
[![DRIVE.NET, Inc.](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/drivenet.png "DRIVE.NET, Inc.")](https://github.com/drivenet)
[![Keith Pickford](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/Keflon.png "Keith Pickford")](https://github.com/Keflon)
[![Thomas Bolon](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/tbolon.png "Thomas Bolon")](https://github.com/tbolon)
[![Kori Francis](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/kfrancis.png "Kori Francis")](https://github.com/kfrancis)
[![Toni Wenzel](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/twenzel.png "Toni Wenzel")](https://github.com/twenzel)
[![Uno Platform](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/unoplatform.png "Uno Platform")](https://github.com/unoplatform)
[![Dan Siegel](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/dansiegel.png "Dan Siegel")](https://github.com/dansiegel)
[![Reuben Swartz](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/rbnswartz.png "Reuben Swartz")](https://github.com/rbnswartz)
[![Jacob Foshee](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/jfoshee.png "Jacob Foshee")](https://github.com/jfoshee)
[![](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/Mrxx99.png "")](https://github.com/Mrxx99)
[![Eric Johnson](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/eajhnsn1.png "Eric Johnson")](https://github.com/eajhnsn1)
[![David JENNI](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/davidjenni.png "David JENNI")](https://github.com/davidjenni)
[![Jonathan ](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/Jonathan-Hickey.png "Jonathan ")](https://github.com/Jonathan-Hickey)
[![Charley Wu](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/akunzai.png "Charley Wu")](https://github.com/akunzai)
[![Ken Bonny](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/KenBonny.png "Ken Bonny")](https://github.com/KenBonny)
[![Simon Cropp](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/SimonCropp.png "Simon Cropp")](https://github.com/SimonCropp)
[![agileworks-eu](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/agileworks-eu.png "agileworks-eu")](https://github.com/agileworks-eu)
[![sorahex](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/sorahex.png "sorahex")](https://github.com/sorahex)
[![Zheyu Shen](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/arsdragonfly.png "Zheyu Shen")](https://github.com/arsdragonfly)
[![Vezel](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/vezel-dev.png "Vezel")](https://github.com/vezel-dev)
[![ChilliCream](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/ChilliCream.png "ChilliCream")](https://github.com/ChilliCream)
[![4OTC](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/4OTC.png "4OTC")](https://github.com/4OTC)
[![Vincent Limo](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/v-limo.png "Vincent Limo")](https://github.com/v-limo)
[![Jordan S. Jones](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/jordansjones.png "Jordan S. Jones")](https://github.com/jordansjones)
[![domischell](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/DominicSchell.png "domischell")](https://github.com/DominicSchell)
[![Mauricio Scheffer](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/mausch.png "Mauricio Scheffer")](https://github.com/mausch)
[![Justin Wendlandt](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/jwendl.png "Justin Wendlandt")](https://github.com/jwendl)
[![Adrian Alonso](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/adalon.png "Adrian Alonso")](https://github.com/adalon)
[![Michael Hagedorn](https://raw.githubusercontent.com/devlooped/sponsors/main/.github/avatars/Eule02.png "Michael Hagedorn")](https://github.com/Eule02)


<!-- sponsors.md -->

[![Sponsor this project](https://raw.githubusercontent.com/devlooped/sponsors/main/sponsor.png "Sponsor this project")](https://github.com/sponsors/devlooped)
&nbsp;

[Learn more about GitHub Sponsors](https://github.com/sponsors)

<!-- https://github.com/devlooped/sponsors/raw/main/footer.md -->
