function Build-PrometheusMetrics {
    param (
        [Parameter(Mandatory=$true)]
        [string]$metricName,
        [Parameter(Mandatory=$true)]
        $labels,
        [Parameter(Mandatory=$true)]
        $metricValue
    )
    
    # Check to see if the labels variable is a hashtable or PSCustomObject
    if ($labels -is [hashtable]) {
        $keyValuePairs = $labels.GetEnumerator() | ForEach-Object {
            "$($_.Name)=`"$($labels.$($_.Name))`","
        }
    } elseif ($labels -is [PSCustomObject]) {
        $keyValuePairs = $labels | Get-Member -MemberType Properties | ForEach-Object {
            "$($_.Name)=`"$($labels.$($_.Name))`","
        }
    } else {
        throw "Labels is not a hashtable or PSCustomObject"
    }

    # Create the metric for later use
    $fileText = "$metricName{$($keyValuePairs)}"

    $fileText = $fileText.Replace(',}', '}')

    if (($metricValue) -or ($metricValue -eq 0)) {
        $fileText = $fileText + " " + $metricValue + "`r`n"
    } else {
        $fileText = "$fileText`r`n"
    }

    return $fileText
}