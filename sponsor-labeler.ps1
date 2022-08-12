$query = gh api graphql --paginate -f owner=$env:SPONSORABLE -f query='
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
' || $(throw "Failed to query GH GraphQL API")

$sponsor = $query |
  ConvertFrom-Json |
  select @{ Name='nodes'; Expression={$_.data.organization.sponsorshipsAsMaintainer.nodes}} |
  select -ExpandProperty nodes |
  where { $_.sponsorEntity.id -eq $env:SPONSOR_SENDER_ID }
  
if ($sponsor -ne $null) {
  $amount = select -ExpandProperty tier | select -ExpandProperty monthlyPriceInDollars
  if ($amount -eq $null) {
    # We have a sponsor, but we might not be able to get the tier amount if token 
    # isn't owner of the sponsorable. Asume regular sponsors in that case.
    $amount = 1
    Write-Warning "Sponsor tier couldn't be read. Make sure token belongs to an owner of $env:SPONSORABLE."
  }
}

if ($null -eq $amount) {
  # Try again with the organizations the user belongs to.
  $user = gh api graphql --paginate -f user=$env:SPONSOR_SENDER_LOGIN -f query='
query ($user: String!, $endCursor: String) {
  user(login: $user) {
    organizations(first: 100, after: $endCursor) {
      nodes { id, login, name }
    }
  }
}
' || $(throw "Failed to query GH GraphQL API")

  $userorgs = $user |
    ConvertFrom-Json |
    select @{ Name='nodes'; Expression={$_.data.user.organizations.nodes}} |
    select -ExpandProperty nodes |
    select -ExpandProperty id

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
  ' || $(throw "Failed to query GH GraphQL API")

  $sponsor = $orgs |
    ConvertFrom-Json |
    select @{ Name='nodes'; Expression={$_.data.organization.sponsorshipsAsMaintainer.nodes}} |
    select -ExpandProperty nodes |
    where { $_.sponsorEntity.id -in $userorgs }

  if ($sponsor -ne $null) {
    $amount = select -ExpandProperty tier |
              sort-object -Property monthlyPriceInDollars -Descending |
              select -ExpandProperty monthlyPriceInDollars -First 1

    if ($amount -eq $null) {
        # We have a sponsor, but we might not be able to get the tier amount if token 
        # isn't owner of the sponsorable. Asume regular sponsors in that case.
        $amount = 1
        Write-Warning "Sponsor tier couldn't be read. Make sure token belongs to an owner of $env:SPONSORABLE."
    }
  }
    
  if ($null -eq $amount) {    
    Write-Output "User $env:SPONSOR_SENDER_LOGIN is not a sponsor of $env:SPONSORABLE and none of their organizations are:"
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

    return
  } else {
    Write-Output "User $env:SPONSOR_SENDER_LOGIN belongs to an organization sponsoring $env:SPONSORABLE."
  }
} else {
  Write-Output "User $env:SPONSOR_SENDER_LOGIN is a direct sponsor of $env:SPONSORABLE."
}

# ensure labels exist
gh label create "$env:SPONSOR_GOLD_LABEL" -c '#FEF2C0' -d 'Gold Sponsor' || & { $global:LASTEXITCODE=0 }
gh label create "$env:SPONSOR_LABEL" -c '#D4C5F9' -d 'Sponsor' || & { $global:LASTEXITCODE=0 }

$gold = [int]$env:SPONSOR_GOLD_AMOUNT
$label = if ([int]$amount -ge $gold) { $env:SPONSOR_GOLD_LABEL } else { $env:SPONSOR_LABEL }

Write-Output "Adding $label label to $env:SPONSOR_ISSUE."
gh issue edit $env:SPONSOR_ISSUE --add-label "$label"