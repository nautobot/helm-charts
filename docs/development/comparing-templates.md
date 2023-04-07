# Comparing Helm Templates

If you would like to compare any deltas between 1 version of the helm chart and another or just exactly what a certain value changes you can run the following:

## Get Values

If you don't have a `values.yaml` file handy or you would like to use a deployed helm chart, get the values from a live deployment:

```no-highlight
helm get values nautobot -o yaml > values.yaml
```

## Versions

To list available helm chart versions run `helm search repo nautobot --versions --devel`

## Template Source

Generate the templates from the source version:

```no-highlight
helm template nautobot/nautobot --version 1.3.1 -f ~/values.yaml > source.yaml
```

## Template Destination

Generate the templates from the destination version:

```no-highlight
helm template nautobot/nautobot --version 1.3.14 -f ~/values.yaml > destination.yaml
```

You can use the local repo as well:

```no-highlight
helm template charts/nautobot -f ~/values.yaml > destination.yaml
```

## Compare

Use your favorite diff utility to compare `source.yaml` and `destination.yaml`.  You can also use the `--output-dir source` and `--output-dir destination` to output the templates in multiple directories if you would like.
