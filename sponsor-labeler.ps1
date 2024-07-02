$verbose = [bool]::Parse($env:SPONSOR_VERBOSE ?? "false")

# ensure labels exist
gh label create "$env:SPONSOR_LABEL" -c '#D4C5F9' -d 'Sponsor' || & { $global:LASTEXITCODE=0 }
gh label create "$env:SPONSOR_CONTRIB_LABEL" -c '#BFFFD3' -d 'Sponsor via contributions' || & { $global:LASTEXITCODE=0 }
gh label create "$env:SPONSOR_SILVER_LABEL" -c '#C0C0C0' -d 'Silver Sponsor' || & { $global:LASTEXITCODE=0 }
gh label create "$env:SPONSOR_GOLD_LABEL" -c '#FEF2C0' -d 'Gold Sponsor' || & { $global:LASTEXITCODE=0 }

$team = gh api graphql -f query='
query {
    viewer {
        organizations(first: 100) {
            nodes {
                login
                isVerified
                email
                websiteUrl
            }
        }
    }
}' --jq "[.data.viewer.organizations.nodes.[] | select(.login == `"$env:SPONSORABLE`")]" || $(throw "Failed to query GH GraphQL API")

if ($team -ne $null) {
    Write-Output "User $env:SPONSOR_SENDER_LOGIN belongs to the $env:SPONSORABLE organization."
    return
}

$owners = gh api graphql --paginate -f login=$env:SPONSOR_SENDER_LOGIN -f query='
query($login: String!, $endCursor: String) {
    user(login: $login) {
        repositoriesContributedTo(first: 5, includeUserRepositories: true, contributionTypes: [COMMIT], after: $endCursor) {
            nodes {
                nameWithOwner,
                owner {
                    login
                }
            }
            pageInfo {
                hasNextPage
                endCursor
            }
        }
    }
}' --jq '[.data.user.repositoriesContributedTo.nodes.[].owner.login]' | jq -s 'flatten | unique' || $(throw "Failed to query GH GraphQL API")

if (($owners | jq ".[] | select(. == `"$env:SPONSORABLE`")") -ne $null) {
    Write-Output "User $env:SPONSOR_SENDER_LOGIN is considered an implicit sponsor as a former contributor to the organization."
    Write-Output "Adding $env:SPONSOR_CONTRIB_LABEL label to #$env:SPONSOR_ISSUE."
    gh issue edit $env:SPONSOR_ISSUE --add-label "$env:SPONSOR_CONTRIB_LABEL"
    return
}

$sponsor = gh api graphql --paginate -f owner=$env:SPONSORABLE -f query='
query($owner:  String!, $endCursor: String) {
  organization (login: $owner) {
    sponsorshipsAsMaintainer (first: 100, after: $endCursor) {
      nodes { 
        sponsorEntity {
          ... on Organization { id, name }
          ... on User { id, name }
        }
        tier { monthlyPriceInDollars }
      }
      pageInfo { hasNextPage, endCursor }
    }
  }
}
' --jq ".data.organization.sponsorshipsAsMaintainer.nodes | map(select(.sponsorEntity.id == `"$env:SPONSOR_SENDER_ID`")) | .[]" || $(throw "Failed to query GH GraphQL API")
 
if ($sponsor -ne $null) {
  $amount = $sponsor | jq '.tier.monthlyPriceInDollars'
  if ($amount -eq $null) {
    # We have a sponsor, but we might not be able to get the tier amount if token 
    # isn't owner of the sponsorable. Asume regular sponsors in that case.
    $amount = 1
    Write-Warning "Sponsor tier couldn't be read. Make sure token belongs to an owner of $env:SPONSORABLE."
  }
}

if ($null -eq $amount) {
  # Try again with the organizations the user belongs to.
  $userorgs = gh api graphql --paginate -f user=$env:SPONSOR_SENDER_LOGIN -f query='
query ($user: String!, $endCursor: String) {
  user(login: $user) {
    organizations(first: 100, after: $endCursor) {
      nodes { id, login, name }
    }
  }
}
' --jq '[.data.user.organizations.nodes.[].id]' || $(throw "Failed to query GH GraphQL API")

  $orgs = gh api graphql --paginate -f owner=$env:SPONSORABLE -f query='
  query($owner:  String!, $endCursor: String) {
    organization (login: $owner) {
      sponsorshipsAsMaintainer (first: 100, after: $endCursor) {
        nodes { 
          sponsorEntity {
            ... on Organization { id, login, name }
          }
          tier { monthlyPriceInDollars }
        }
        pageInfo { hasNextPage, endCursor }
      }
    }
  }
  ' --jq '[.data.organization.sponsorshipsAsMaintainer.nodes[] | select(.sponsorEntity | has("id"))]' || $(throw "Failed to query GH GraphQL API")

  $sponsors = $orgs | jq "[.[] | select(.sponsorEntity.id as `$id | $userorgs | index(`$id))]"

  if (($sponsors | convertfrom-json | measure).count -ne 0) {
    $amount = $sponsors | jq '[.[] | .tier.monthlyPriceInDollars | select(. != null)] | sort' | select -last 1

    if ($amount -eq $null) {
        # We have at least one sponsor, but we might not be able to get the tier amount if token 
        # isn't owner of the sponsorable. Asume regular sponsors in that case.
        $amount = 1
        Write-Warning "Sponsor tier couldn't be read. Make sure token belongs to an owner of $env:SPONSORABLE."
    }
  }
    
  if ($null -eq $amount) {    
    Write-Output "User $env:SPONSOR_SENDER_LOGIN is not a sponsor of $env:SPONSORABLE and none of their organizations are."
    if ($verbose) {
      $user |
        ConvertFrom-Json |
        select @{ Name='nodes'; Expression={$_.data.user.organizations.nodes}} |
        select -ExpandProperty nodes 
        format-table
      
      Write-Output "`n$env:SPONSORABLE sponsoring organizations:"
      $orgs |
        ConvertFrom-Json |
        select @{ Name='nodes'; Expression={$_.data.organization.sponsorshipsAsMaintainer.nodes}} |
        select -ExpandProperty nodes |
        select -ExpandProperty sponsorEntity |
        format-table
    }

    return
  } else {
    Write-Output "User $env:SPONSOR_SENDER_LOGIN belongs to an organization sponsoring $env:SPONSORABLE."
  }
} else {
  Write-Output "User $env:SPONSOR_SENDER_LOGIN is a direct sponsor of $env:SPONSORABLE."
}



$gold = [int]$env:SPONSOR_GOLD_AMOUNT
$silver = [int]$env:SPONSOR_SILVER_AMOUNT
$label = if ([int]$amount -ge $gold) {
            $env:SPONSOR_GOLD_LABEL 
          } else { 
            if ([int]$amount -ge $silver) { 
              $env:SPONSOR_SILVER_LABEL 
            } else { 
              $env:SPONSOR_LABEL 
            }
          }

Write-Output "Adding $label label to #$env:SPONSOR_ISSUE."
gh issue edit $env:SPONSOR_ISSUE --add-label "$label"