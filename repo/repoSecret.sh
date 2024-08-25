REPO="git@github.com:edens-angel"
TYPE="git"
SSH=$(cat ~/.ssh/personal-argo)

secretname="argocd-github-credentials-template"
kubectl create secret generic $secretname --from-literal="type=$TYPE" --from-literal="url=$REPO" --from-literal="sshPrivateKey=$SSH"
kubectl annotate secret $secretname "argocd.argoproj.io/secret-type"="repo-creds"
