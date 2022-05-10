# Sealed Secrets 
##  Creating the Sealed Secrets Helm Release

In this step, you will learn how to create manifests using the `Flux CLI`, to define the `Sealed Secrets` Helm release. Then, `Flux` will trigger the `Sealed Secrets Controller` installation process for your `DOKS` cluster.

Please use the following steps, to create required manifests for the `Sealed Secrets` Helm release:

1. First, change directory where your `Flux CD` Git repository was cloned. Also, please check that the required directory structure for this tutorial is created, and that the `FLUXCD_HELM_MANIFESTS_PATH` environment variable is set (please refer to [Step 4 - Cloning the Flux CD Git Repository and Preparing the Layout](#step-4---cloning-the-flux-cd-git-repository-and-preparing-the-layout), for details).
2. Then, create the `Sealed Secrets` HelmRepository manifest for `Flux`:

    ```shell
    flux create source helm sealed-secrets \
      --url="https://bitnami-labs.github.io/sealed-secrets" \
      --interval="10m" \
      --export > "${FLUXCD_HELM_MANIFESTS_PATH}/repositories/sealed-secrets.yaml"
    ```

    Explanations for the above command:

    - `--url`: Helm repository address.
    - `--interval`: Source sync interval (default `1m0s`).
    - `--export`: Export in `YAML` format to stdout.

    The output looks similar to (you can notice that it has a similar structure as explained in [Using HelmRepository CRD to Define Helm Repositories](#using-helmrepository-crd-to-define-helm-repositories)):

    ```yaml
    ---
    apiVersion: source.toolkit.fluxcd.io/v1beta1
    kind: HelmRepository
    metadata:
      name: sealed-secrets
      namespace: flux-system
    spec:
      interval: 10m0s
      url: https://bitnami-labs.github.io/sealed-secrets
    ```

3. Next, fetch the `Starter Kit` values file for `Sealed Secrets`. Please make sure to inspect the values file first, and replace the `<>` placeholders where needed:

    ```shell
    SEALED_SECRETS_CHART_VERSION="2.1.6"

    curl "https://raw.githubusercontent.com/digitalocean/Kubernetes-Starter-Kit-Developers/main/08-kubernetes-sealed-secrets/assets/manifests/sealed-secrets-values-v${SEALED_SECRETS_CHART_VERSION}.yaml" > "sealed-secrets-values-v${SEALED_SECRETS_CHART_VERSION}.yaml"
    ```

4. Now, create the `Sealed Secrets` HelmRelease manifest for `Flux CD`. `Kubeseal` CLI expects by default to find the controller in the `kube-system` namespace and to be named `sealed-secrets-controller`, hence we override the release name via the `--release-name` and `--target-namespace` flags. This is not mandatory, but `kube-system` is usually accessible only to power users (administrators):

    ```shell
    SEALED_SECRETS_CHART_VERSION="2.1.6"

    flux create helmrelease "sealed-secrets-controller" \
      --release-name="sealed-secrets-controller" \
      --source="HelmRepository/sealed-secrets" \
      --chart="sealed-secrets" \
      --chart-version "$SEALED_SECRETS_CHART_VERSION" \
      --values="sealed-secrets-values-v${SEALED_SECRETS_CHART_VERSION}.yaml" \
      --target-namespace="flux-system" \
      --crds=CreateReplace \
      --export > "${FLUXCD_HELM_MANIFESTS_PATH}/releases/sealed-secrets-v${SEALED_SECRETS_CHART_VERSION}.yaml"
    ```

    Explanations for the above command:

    - `--release-name`: What name to use for the Helm release (defaults to `<target-namespace>-<HelmRelease-name>` otherwise).
    - `--source`: Source that contains the chart in the format `<kind>/<name>.<namespace>`, where kind must be one of: (`HelmRepository`, `GitRepository`, `Bucket`).
    - `--chart`: Helm chart name.
    - `--chart-version`: Helm chart version.
    - `--values`: Local path to values file.
    - `--target-namespace`: Namespace to install this release.
    - `--crds`: Upgrade CRDs policy, available options are: (`Skip`, `Create`, `CreateReplace`).
    - `--export`: Export in `YAML` format to stdout.

    The output looks similar to (you can observe that it has a similar structure as explained in [Using HelmRelease CRD to Install Helm Charts](#using-helmrelease-crd-to-install-helm-charts)):

    ```yaml
    ---
    apiVersion: helm.toolkit.fluxcd.io/v2beta1
    kind: HelmRelease
    metadata:
      name: sealed-secrets-controller
      namespace: flux-system
    spec:
      chart:
        spec:
          chart: sealed-secrets
          sourceRef:
            kind: HelmRepository
            name: sealed-secrets
          version: 2.1.6
      interval: 1m0s
      releaseName: sealed-secrets-controller
      targetNamespace: flux-system
      install:
        crds: Create
      upgrade:
        crds: CreateReplace
      values:
        ingress:
          enabled: false
    ```

5. Finally, commit `Git` changes to `remote` branch:

    ```shell
    SEALED_SECRETS_CHART_VERSION="2.1.6"

    git add "${FLUXCD_HELM_MANIFESTS_PATH}/repositories/sealed-secrets.yaml"

    git add "${FLUXCD_HELM_MANIFESTS_PATH}/releases/sealed-secrets-v${SEALED_SECRETS_CHART_VERSION}.yaml"

    git commit -am "Adding Sealed Secrets manifests for Flux CD"

    git push origin
    ```

After completing the above steps, `Flux CD` will start your `DOKS` cluster `reconciliation` (in about `one minute` or so, if using the `default` interval). If you don't want to wait, you can always `force` reconciliation via:

```shell
flux reconcile source git flux-system
```

After a few moments, please inspect the Flux CD `Sealed Secrets` Helm release:

```shell
flux get helmrelease sealed-secrets-controller
```
  
The output looks similar to:

```text
NAME                        READY   MESSAGE                                 REVISION        SUSPENDED 
sealed-secrets-controller   True    Release reconciliation succeeded        2.1.6          False 
```

Look for the `READY` column value - it should say `True`. Reconciliation status is displayed in the `MESSAGE` column, along with the `REVISION` number, which represents the `Helm` chart `version`. Please bear in mind that some releases take longer to complete (like `Prometheus` stack, for example), so please be patient.

**Hints:**

- The `MESSAGE` column will display `Reconciliation in progress`, as long as the `HelmController` is performing the installation for the specified `Helm` chart. If something goes wrong, you'll get another message stating the reason, so please make sure to check Helm release state.
- You can use the `--watch` flag for example: `flux get helmrelease <name> --wait`, to wait until the command finishes. Please bear in mind that in this mode, `Flux` will block your terminal prompt until the default timeout of `5 minutes` occurs (can be overridden via the `--timeout` flag).
- In case something goes wrong, you can search the `Flux` logs, and filter `HelmRelease` messages only:

    ```shell
    flux logs --kind=HelmRelease
    ```

### Exporting the Sealed Secrets Controller Public Key

To be able to `encrypt` secrets, you need the `public key` that was generated by the `Sealed Secrets Controller` when it was deployed by `Flux CD` in your `DOKS` cluster.

First, change directory where you cloned your `Flux CD` Git repository, and do the following 

```shell
kubeseal --controller-namespace=flux-system --fetch-cert > pub-sealed-secrets.pem
```

**Note:**

If for some reason the `kubeseal` certificate fetch command hangs (or you get an empty/invalid certificate file), you can use the following steps to work around this issue:

- First, open a new terminal window, and `expose` the `Sealed Secrets Controller` service on your `localhost` (you can use `CTRL - C` to terminate, after fetching the public key):

  ```shell
  kubectl port-forward service/sealed-secrets-controller 8080:8080 -n flux-system 
  ```

- Then, you can go back to your working terminal and fetch the public key

  ```shell
  curl --retry 5 --retry-connrefused localhost:8080/v1/cert.pem > pub-sealed-secrets.pem
  ```

Finally, `commit` the public key file to remote `Git` repository for later use (it's `safe` to do this, because the `public key` is useless without the `private key` which is stored in your `DOKS` cluster only). Please run bellow commands, and make sure to replace the `<>` placeholders accordingly:

```shell
git add pub-sealed-secrets.pem

git commit -m "Adding Sealed Secrets public key for cluster"

git push origin
```

**Important note:**

**In this tutorial the `flux-system` namespace is used to hold `Kubernetes Secrets`, so please make sure that it is `restricted` to regular users/ applications via `RBAC`.**

## Step 2 - Encrypting a Kubernetes Secret

In this step, you will learn how to encrypt a generic `Kubernetes` secret, using `kubeseal` CLI. Then, you will deploy it to your cluster and see how the `Sealed Secrets` controller `decrypts` it for your applications to use.

Suppose that you need to seal a generic secret for your application, saved in the following file: `your-app-secret.yaml`. Notice the `your-data` field which is `base64` encoded (it's `vulnerable` to attacks, because it can be very easily `decoded` using free tools):

```yaml
apiVersion: v1
data:
  your-data: ZXh0cmFFbnZWYXJzOgogICAgRElHSVRBTE9DRUFOX1RPS0VOOg== # base64 encoded application data
kind: Secret
metadata:
  name: your-app
```

Next, create a `sealed` file from the `Kubernetes` secret, using the `pub-sealed-secrets.pem` key:

```shell
kubeseal --format=yaml \
  --namespace=flux-system \
  --cert=pub-sealed-secrets.pem \
  --secret-file your-app-secret.yaml \
  --sealed-secret-file your-app-sealed.yaml
```

The new file defines a SealedSecret CRD:

```yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  creationTimestamp: null
  name: your-app
  namespace: flux-system
spec:
  encryptedData:
    your-data: AgCFNTLd+KD2IGZo3YWbRgPsK1dEhxT3NwSCU2Inl8A6phhTwMxKSu82fu0LGf/AoYCB35xrdPl0sCwwB4HSXRZMl2WbL6HrA0DQNB1ov8DnnAVM+6TZFCKePkf9yqVIekr4VojhPYAvkXq8TEAxYslQ0ppNg6AlduUZbcfZgSDkMUBfaczjwb69BV8kBf5YXMRmfGtL3mh5CZA6AAK0Q9cFwT/gWEZQU7M1BOoMXUJrHG9p6hboqzyEIWg535j+14tNy1srAx6oaQeEKOW9fr7C6IZr8VOe2wRtHFWZGjCL3ulzFeNu5GG0FmFm/bdB7rFYUnUIrb2RShi1xvyNpaNDF+1BDuZgpyDPVO8crCc+r2ozDnkTo/sJhNdLDuYgIzoQU7g1yP4U6gYDTE+1zUK/b1Q+X2eTFwHQoli/IRSv5eP/EAVTU60QJklwza8qfHE9UjpsxgcrZnaxdXZz90NahoGPtdJkweoPd0/CIoaugx4QxbxaZ67nBgsVYAnikqc9pVs9VmX/Si24aA6oZbtmGzkc4b80yi+9ln7x/7/B0XmyLNLS2Sz0lnqVUN8sfvjmehpEBDjdErekSlQJ4xWEQQ9agdxz7WCSCgPJVnwA6B3GsnL5dleMObk7eGUj9DNMv4ETrvx/ZaS4bpjwS2TL9S5n9a6vx6my3VC3tLA5QAW+GBIfRD7/CwyGZnTJHtW5f6jlDWYS62LbFJKfI9hb8foR/XLvBhgxuiwfj7SjjAzpyAgq
  template:
    data: null
    metadata:
      creationTimestamp: null
      name: your-app
      namespace: default
```

**Note:**

If you don't specify a `namespace`, the `default` one is assumed (use kubeseal `--namespace` flag, to change targeted namespace). Default `scope` used by `kubeseal` is `strict` - please refer to scopes in [Security Best Practices](#security-best-practices).

Next, you can delete the `Kubernetes` secret file, because it's not needed anymore:

```shell
rm -f your-app-secret.yaml
```

Finally, `deploy` the `sealed secret` to your cluster:

```shell
kubectl apply -f your-app-sealed.yaml
```

Check that the `Sealed Secrets Controller` decrypted your `Kubernetes` secret in the `flux-system` namespace:

```shell
kubectl get secrets -n flux-system
```

The output looks similar to:

```text
NAME                  TYPE                                  DATA   AGE
your-app              Opaque                                1      31s
```

Inspect the secret:

```shell
kubectl get secret your-app -o yaml -n flux-system
```

The output looks similar to (`your-data` key `value` should be `decrypted` to the original `base64` encoded `value`):

```yaml
apiVersion: v1
data:
  your-data: ZXh0cmFFbnZWYXJzOgogICAgRElHSVRBTE9DRUFOX1RPS0VOOg==
kind: Secret
metadata:
  creationTimestamp: "2021-10-05T08:34:07Z"
  name: your-app
  namespace: flux-system
  ownerReferences:
  - apiVersion: bitnami.com/v1alpha1
    controller: true
    kind: SealedSecret
    name: your-app
    uid: f6475e74-78eb-4c6a-9f19-9d9ceee231d0
  resourceVersion: "235947"
  uid: 7b7d2fee-c48a-4b4c-8f16-2e58d25da804
type: Opaque
```

## Step 4 - Sealed Secrets Controller Private Key Backup

If you want to perform a `manual backup` of the private and public keys, you can do so via:

```shell
kubectl get secret -n flux-system -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml > master.key
```

Then, store the `master.key` file somewhere safe. To restore from a backup after some disaster, just put that secret back before starting the controller - or if the controller was already started, replace the newly-created secrets and restart the controller:

```shell
kubectl apply -f master.key

kubectl delete pod -n flux-system -l name=sealed-secrets-controller
```


## Security Best Practices

In terms of security, `Sealed Secrets` allows you to `restrict` other users to decrypt your sealed secrets inside the cluster. There are three `scopes` that you can use (`kubeseal` CLI `--scope` flag):

1. `strict` (default): the secret must be sealed with `exactly` the same `name` and `namespace`. These `attributes` become `part` of the `encrypted data` and thus `changing name` and/or `namespace` would lead to **"decryption error"**.
2. `namespace-wide`: you can freely `rename` the sealed secret within a given `namespace`.
3. `cluster-wide`: the `secret` can be `unsealed` in any `namespace` and can be given any `name`.

Next, you can apply some of the best practices highlighted below:

- Make sure to change periodically **both** `secrets` (like passwords, tokens, etc), and the `private key` used for `encryption`. This way, if the `encryption key` is ever `leaked`, sensitive data doesn't get exposed. And even if it is, the secrets are not valid anymore. You can read more on the topic by referring to the [Secret Rotation](https://github.com/bitnami-labs/sealed-secrets#secret-rotation) chapter, from the official documentation.
- You can leverage the power of `RBAC` for your `Kubernetes` cluster to `restrict` access to `namespaces`. So, if you store all your Kubernetes secrets in a `specific namespace`, then you can `restrict` access to `unwanted users` and `applications` for that `specific namespace`. This is important, because plain `Kubernetes Secrets` are `base64` encoded and can be `decoded` very easy by anyone. `Sealed Secrets` provides an `encryption` layer on top of `encoding`, but in your `DOKS` cluster sealed secrets are transformed back to `generic` Kubernetes secrets.
- To avoid `private key leaks`, please make sure that the `namespace` where you deployed the `Sealed Secrets` controller is protected as well, via corresponding `RBAC` rules.

## Conclusion

In this tutorial, you learned how to use generic `Kubernetes secrets` in a `secure` way. You also learned that the `encryption key` is stored and secrets are `decrypted` in the `cluster` (the client doesn’t have access to the encryption key).

Then, you discovered how to use `kubeseal` CLI, to generate `SealedSecret` manifests that hold sensitive content `encrypted`. After `applying` the sealed secrets manifest file to your `DOKS` cluster, the `Sealed Secrets Controller` will recognize it as a new sealed secret resource, and `decrypt` it to generic `Kubernetes Secret` resource.

### Pros

- `Lightweight`, meaning implementation and management costs are low.
- `Transparent` integration with `Kubernetes Secrets`.
- `Decryption` happens `server side` (DOKS cluster).
- Works very well in a `GitOps` setup (`encrypted` files can be stored using `public Git` repositories).

### Cons

- For `each DOKS cluster` a separate `private` and `public key` pair needs to be `created` and `maintained`.
- `Private keys` must be `backed` up (e.g. using `Velero`) for `disaster` recovery.
- `Updating` and `re-sealing` secrets, as well as `adding` or `merging` new key/values is not quite straightforward.

Even though there are some cons to using `Sealed Secrets`, the `ease` of `management` and `transparent` integration with `Kubernetes` and `GitOps` flows makes it a good candidate in practice.

### Learn More

- [Upgrade](https://github.com/bitnami-labs/sealed-secrets#upgrade) steps and notes.
- [Sealed Secrets FAQ](https://github.com/bitnami-labs/sealed-secrets#faq), for frequently asked questions about `Sealed Secrets`.




 