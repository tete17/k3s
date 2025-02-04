# Grabs the last 5 commit SHA's from the given branch, then purges any commits that do not have a passing CI build
curl -s -H 'Accept: application/vnd.github.v3+json' "https://api.github.com/repos/k3s-io/k3s/commits?per_page=5&sha=$1" | jq -r '.[] | .sha'  &> $2
curl -s --fail https://storage.googleapis.com/k3s-ci-builds/k3s-$(head -n 1 $2).sha256sum
while [ $? -ne 0 ]; do
    sed -i 1d $2
    curl -s --fail https://storage.googleapis.com/k3s-ci-builds/k3s-$(head -n 1 $2).sha256sum
done