function New-KubeConfig {
    param (
        [string]$outputFolder,
        [string]$k8sUrl,
        [string]$k8sToken
    )

    Set-Content -Path "$outputFolder/kubeconfig" -Value @"
    {
        "apiVersion": "v1",
        "clusters": [
            {
                "cluster": {
                    "server": "$k8sUrl",
                    "insecure-skip-tls-verify": true
                },
                "name": "kubernetes-cluster"
            }
        ],
        "contexts": [
            {
                "context": {
                    "cluster": "kubernetes-cluster",
                    "user": "kubernetes-admin"
                },
                "name": "kubernetes-cluster"
            }
        ],
        "current-context": "kubernetes-cluster",
        "kind": "Config",
        "users": [
            {
                "name": "kubernetes-admin",
                "user": {
                    "token": "$k8sToken"
                }
            }
        ]
    }
"@
}

function Get-HostedTenants
{
    param (
        [string]$kubectl,
        [string]$kubeConfig
    )

    return & $kubectl get namespaces --selector purpose=hostedInstance -o json --kubeconfig="$kubeConfig" |
            ConvertFrom-Json |
            Select -ExpandProperty items |
            ? { -not ($_.metadata.labels.dnsPrefix -in $excludedInstances) }
}