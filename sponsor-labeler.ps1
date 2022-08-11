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
      pageInfo {
        hasNextPage
        endCursor
      }
    }
  }
}
'

$amount =
    $query |
    ConvertFrom-Json |
    select @{ Name='nodes'; Expression={$_.data.organization.sponsorshipsAsMaintainer.nodes}} |
    select -ExpandProperty nodes |
    where { $_.sponsorEntity.id -eq $env:SPONSOR_ACTOR } |
    select -ExpandProperty tier |
    select -ExpandProperty monthlyPriceInDollars

if ($null -eq $monthly) {
    return
}

# ensure labels exist
gh label create "$env:SPONSOR_GOLD_LABEL" -c '#FEF2C0' -d 'Gold Sponsor' || & { $global:LASTEXITCODE=0 }
gh label create "$env:SPONSOR_LABEL" -c '#D4C5F9' -d 'Sponsor' || & { $global:LASTEXITCODE=0 }

$gold = [int]$env:SPONSOR_GOLD_AMOUNT
$label = if ([int]$amount -ge $gold) { $env:SPONSOR_GOLD_LABEL } else { $env:SPONSOR_LABEL }

gh issue edit $env:SPONSOR_ISSUE --add-label "$label"