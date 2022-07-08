#!/usr/bin/env bash
COMMIT=$(git rev-parse --verify HEAD --short=8)
REPO_NAME=$(basename $(git rev-parse --show-toplevel))
BRAND_NAME=$(git branch | grep \* | cut -d ' ' -f2)
IMAGE_NAME=techainer1t/${REPO_NAME}:${BRAND_NAME}-${COMMIT}
DEPLOYMENT_NAME=${REPO_NAME}
NAME_SPACE=horus-new-ai
err() {
    echo $* >&2
}

usage() {
    err "$(basename $0): [build|push|bp|run|play|exec|login|logs]"
}

clean() {
    # kubectl delete deployment horus-backend -n ${NAME_SPACE}
    echo "Nothing to clean"
}

build_docker() {
    docker build -t ${IMAGE_NAME} . -f docker-build/Dockerfile
}

push_docker() {
    docker push ${IMAGE_NAME}
    echo "====================================================================================================="
    echo ""
    echo "😎😎😎 IMAGE NAME: ${IMAGE_NAME} SUCCESS PUSH TO DOCKERHUB  😎😎😎"
    echo ""
    echo "====================================================================================================="
    # Copy IMAGE_NAME to clipboard
    echo ${IMAGE_NAME} | pbcopy
}

launch() {
    kubectl set image deployment.v1.apps/${DEPLOYMENT_NAME} -n ${NAME_SPACE} ${DEPLOYMENT_NAME}=${IMAGE_NAME}
    kubectl rollout status deployment/${DEPLOYMENT_NAME} -n ${NAME_SPACE}
}

exec() {
    kubectl exec -it $(kubectl get pods -n ${NAME_SPACE} | grep ${DEPLOYMENT_NAME} | awk '{print $1}') -n ${NAME_SPACE} -- /bin/bash
}

logs() {
    kubectl logs $(kubectl get pods -n ${NAME_SPACE} -l app=${DEPLOYMENT_NAME} -o jsonpath="{.items[0].metadata.name}") -n ${NAME_SPACE}
}
execute() {
    local task=${1}
    case ${task} in
        build)
            echo "Copyed ${IMAGE_NAME} to clipboard !!!"
            echo ${IMAGE_NAME} | pbcopy
            clean
            build_docker
            ;;
        push)
            echo "Copyed ${IMAGE_NAME} to clipboard !!!"
            echo ${IMAGE_NAME} | pbcopy
            clean
            push_docker
            ;;
        bp)
            echo "Copyed ${IMAGE_NAME} to clipboard !!!"
            echo ${IMAGE_NAME} | pbcopy
            clean
            build_docker
            push_docker
            ;;
        run)
            launch
            ;;
        exec)
            exec
            ;;
        logs)
            logs 
            ;;
        play) // Hàm để thực hiện clean, build và chạy docker
            clean
            build_docker
            launch
            ;;
        *)
            err "invalid task: ${task}"
            usage
            exit 1
            ;;
    esac
}

main() {
    [ $# -ne 1 ] && { usage; exit 1; }
    local task=${1}
    execute ${task}
}

main $@
