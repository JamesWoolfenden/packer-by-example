$packs=gci -filter *.json -recurse

foreach($pack in $packs)
{
   $json=packer fix -validate=true $($pack.FullName)
   $json|set-content $($pack.FullName)
}
