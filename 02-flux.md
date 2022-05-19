# Chapter 2 - Build a GitOps Pipeline with Flux

## Rationale 

`GitOps` is  a set of practices that focuses around the main idea of having `Git` as the single source of truth. It means you keep all your Kubernetes configuration manifests stored in a `Git` repository. Then, a GitOps tool (such as [Flux CD](https://fluxcd.io) or [Argo CD](https://argoproj.github.io/cd/)) fetches current configuration from the Git repository, and applies required changes to your Kubernetes cluster to maintain desired state.

The GitOps tool continuously watches the current system state (your Kubernetes cluster) and Git repository state. If there's a difference (or deviation) between the two, it will take the appropriate actions to match Git repository state. It means, whenever someone applies manual changes (via `kubectl`) those will be overwritten, and your Kubernetes applications state reverted to reflect current configuration from Git repository. In other words, the Git repository always wins, hence the statement - Git as the single source of truth. This approach has a tremendous advantage, because it eliminates issues due to manual system changes which cannot be tracked or audited.

Flux CD helps you synchronize the state of your infrastructure using Git as the source of truth, thus following GitOps principles. Flux also helps you implement continuous delivery for your applications. It knows how to handle Helm releases as well, thus you can control application deployment and lifecycle via the standard package manager for Kubernetes.

The process of synchronizing your cluster state with a Git repositor is called reconciliation. Reconciliation makes sure that your applications state match a desired state declaratively defined somewhere (can be a Git repository, Helm repository or a S3 bucket).

In this chapter, you will use Helm to install FluxCD which will synchronize with a Github repo. 

![image](https://raw.githubusercontent.com/digitalocean/Kubernetes-Starter-Kit-Developers/main/15-continuous-delivery-using-gitops/assets/images/fluxcd_overview.png)


### Prerequisites
- [A Github account](https://github.com/signup)
- [Flux CLI](https://fluxcd.io/docs/installation/#install-the-flux-cli)

## Instructions 

### Step 1 - Bootstrap Flux CD

`Flux CD` provides a `CLI` binary which you can use for provisioning `Flux CD` itself, as well as for main system interaction. Using the `flux bootstrap` subcommand, you can install Flux on a Kubernetes cluster and configure it to manage itself from a Git repository.

If the Flux components are present on the cluster, the bootstrap command will perform an upgrade if needed. The bootstrap is idempotent and it is safe to run the command as many times as you want.

Bootstrapping Flux CD on your existing DOKS cluster:

1. Generate a [GitHub personal access token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line) that can create repositories by checking all permissions under `repo`.
2. Export your GitHub personal access token as an environment variable (make sure to replace the `<>` placeholders accordingly):

    ```shell
    export GITHUB_TOKEN=<YOUR_PERSONAL_ACCESS_TOKEN_HERE>
    ```

3. Run the bootstrap command to create a repository on your personal GitHub account (make sure to replace the `<>` placeholders accordingly):

    ```shell
    flux bootstrap github \
      --owner=<YOUR_GITHUB_USER> \
      --repository=kubecon-workshop \
      --path=clusters/dev \
      --personal
    ```
      
Explanations for the above command:

- `--owner`: Holds your GitHub user name.
- `--repository`: Git repository to use by Flux CD (the repository will be created if it doesn't exist).
- `--path`: Directory path to use inside the repository to store all manifests (the directory path will be created if it doesn't exist). This argument is important, because Flux CD will monitor all changes happening under the directory path you define here.

The flux bootstrap command will create the specified GitHub repository if it doesn't exist, and will start the provisioning process for Flux CD. In the end, you should have a bunch of YAML manifests created in your Git repository, as well as all Kubernetes resources required by Flux CD to work.

Next, check that flux is working:

```shell
flux check
```

The output looks similar to the following:

```text
► checking prerequisites
✔ Kubernetes 1.22.8 >=1.20.6-0
► checking controllers
✔ helm-controller: deployment ready
► ghcr.io/fluxcd/helm-controller:v0.17.2
✔ kustomize-controller: deployment ready
► ghcr.io/fluxcd/kustomize-controller:v0.21.1
✔ notification-controller: deployment ready
► ghcr.io/fluxcd/notification-controller:v0.22.3
✔ source-controller: deployment ready
► ghcr.io/fluxcd/source-controller:v0.21.2
✔ all checks passed
```

Then, inspect all `Flux CD` resources via:

```shell
flux get all
```

The output looks similar to the following (you can notice the `gitrepository/flux-system` component fetching the latest revision from your main branch, as well as the `kustomization/flux-system` component):

```text
NAME                            READY   MESSAGE                         REVISION        SUSPENDED 
gitrepository/flux-system       True    Fetched revision: main/6e9b41b  main/6e9b41b    False 

NAME                            READY   MESSAGE                         REVISION        SUSPENDED 
kustomization/flux-system       True    Applied revision: main/6e9b41b  main/6e9b41b    False  
```

In case you need to perform some troubleshooting, and see what `Flux CD` is doing, you can access the logs via:

```shell
flux logs
```

The output looks similar to the following:

```text
...
2022-03-17T10:47:21.976Z info Kustomization/flux-system.flux-system - server-side apply completed 
2022-03-17T10:47:22.662Z info Kustomization/flux-system.flux-system - server-side apply completed 
2022-03-17T10:47:22.702Z info Kustomization/flux-system.flux-system - Reconciliation finished in 9.631064885s, next run in 10m0s 
2022-03-17T10:47:19.167Z info GitRepository/flux-system.flux-system - Discarding event, no alerts found for the involved object 
2022-03-17T10:47:22.691Z info Kustomization/flux-system.flux-system - Discarding event, no alerts found for the involved object 
2022-03-17T10:47:22.709Z info Kustomization/flux-system.flux-system - Discarding event, no alerts found for the involved object 
2022-03-17T10:47:19.168Z info GitRepository/flux-system.flux-system - Reconciliation finished in 7.79283477s, next run in 1m0s 
2022-03-17T10:48:20.594Z info GitRepository/flux-system.flux-system - Reconciliation finished in 1.424279853s, next run in 1m0s 
...
```

Finally, check that `Flux CD` points to your `Git` repository:

```shell
kubectl get gitrepositories.source.toolkit.fluxcd.io -n flux-system
```

The output looks similar to (notice the `URL` column value - should point to your `Git` repository, and the `READY` state set to `True`):

```text
NAME         URL                                                       READY  STATUS                             AGE
flux-system  ssh://git@github.com/test-starterkit/starterkit_fra1.git  True   Fetched revision: main/6e9b41b...  9m59s
```

You should also see a bunch of Flux CD system manifests present in your Git repository as well:

![This](https://raw.githubusercontent.com/digitalocean/Kubernetes-Starter-Kit-Developers/main/15-continuous-delivery-using-gitops/assets/images/fluxcd_git_components.png)

In the next step, you will prepare the `Git` repository layout for use in this tutorial. Flux CD is watching for changes present in the `--path` argument that you passed to the `flux bootstrap` command. This instance of Flux is using the `clusters/dev` directory path. You can create any directory structure under the `clusters/dev` path to keep things organized. Flux CD will perform a recursive search for all manifests under the `clusters/dev` path.

You can throw all the manifests under the Flux CD sync path (e.g. `clusters/dev`), but it's best practice to keep things organized and follow naming conventions as much as possible to avoid frustration in the future.

## Step 2 - Cloning the Flux CD Git Repository and Preparing the Layout

In this step, you will learn how to organize your `Git` repository used by `Flux CD` to sync your `DOKS` cluster `state`. For simplicity, this tutorial is based on a `monorepo` structure, and is using a `single environment` to hold all your manifests (e.g. `clusters/dev`). You can check the official Flux CD documentation for some guidance on how to setup your [Git repository structure](https://fluxcd.io/docs/guides/repository-structure).

Please make sure that the following steps are performed in order:

1. First, clone your Flux CD Git repository. This is the `main repository` used for your `DOKS` cluster `reconciliation` (please replace the `<>` placeholders accordingly):

   ```shell
   git clone https://github.com/<YOUR_GITHUB_USER>/<YOUR_GITHUB_REPOSITORY_NAME>.git
   ```

    Explanations for the above command:

    - `<YOUR_GITHUB_USER>` - your GitHub `username` as defined by the `--owner` argument of the flux bootstrap command.
    - `<YOUR_GITHUB_REPOSITORY_NAME>` - GitHub repository name used for your `DOKS` cluster `reconciliation` as defined by the `--repository` argument of the flux bootstrap command.

2. Next, change directory where your Flux CD `Git` repository was cloned, and checkout the correct branch (usually `main`).
3. Now, create the `directory structure` to store Flux CD `HelmRepository`, `HelmRelease` and `SealedSecret` manifests for each component. Please replace the `FLUXCD_SYNC_PATH` variable value with your `Flux CD` cluster sync directory path, as defined by the `--path` argument of the flux bootstrap command.

    ```shell
    FLUXCD_SYNC_PATH="clusters/dev"
    FLUXCD_HELM_MANIFESTS_PATH="${FLUXCD_SYNC_PATH}/helm"

    mkdir -p "${FLUXCD_HELM_MANIFESTS_PATH}/repositories" 
    
    mkdir -p "${FLUXCD_HELM_MANIFESTS_PATH}/releases" 
    
    mkdir -p "${FLUXCD_HELM_MANIFESTS_PATH}/secrets"
    ```

4. Finally, add the `.gitignore` file to `avoid` committing `unencrypted` Helm value files in your repository, that may contain sensitive data. Using your favorite `text editor`, paste the following:

    ```text
    # Ignore all YAML files containing the `-values-` string.
    *-values-*.yaml

    # Do not ignore sealed YAML files.
    !*-sealed.yaml
    ```

### Learn More 
- [Flux Documentation](https://fluxcd.io/docs/)
- [GitOps and Continuous Delivery with FluxCD or ArgoCD](https://github.com/digitalocean/Kubernetes-Starter-Kit-Developers/blob/main/15-continuous-delivery-using-gitops)