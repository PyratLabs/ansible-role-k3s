#!/usr/bin/env bash
set -euo pipefail

ANSIBLE_RELEASE_FEED="$(curl -Ssl https://api.github.com/repos/ansible/ansible/tags?per_page=50)"
TMPDIR="$(mktemp -d /tmp/molecule.XXXXX)"

function ansible_releases {
    local RELEASE_LIST_ALL

    RELEASE_LIST_ALL="$(echo "${ANSIBLE_RELEASE_FEED}" | grep -E "\"name\": \"v[0-9]+\.[0-9]+\.[0-9]+\"")"

    for RELEASE in ${RELEASE_LIST_ALL} ; do
        echo "${RELEASE}" | grep -v "name" | sed -E 's/"v([0-9]+\.[0-9]+\.[0-9]+)",/\1/g' || true
    done
}

function build_requirements {
    local TEST_REQUIREMENTS
    local REQUIREMENTS
    local ANSIBLE_VERSION

    ANSIBLE_VERSION="${1:-true}"

    if [ "${ANSIBLE_VERSION}" == "true" ] ; then
        echo "Something went wrong!"
        exit 1
    fi

    TEST_REQUIREMENTS=$(<molecule/requirements.txt)
    REQUIREMENTS=$(echo "${TEST_REQUIREMENTS}" | grep -v "requirements.txt" || true)
    if [[ "${ANSIBLE_VERSION}" =~ "^v2\.10" ]] ; then
        echo -e "ansible==${ANSIBLE_VERSION}\nansible-base==${ANSIBLE_VERSION}\n${REQUIREMENTS}"
    else
        echo -e "ansible==${ANSIBLE_VERSION}\n${REQUIREMENTS}"
    fi
}

function make_venv {
    local MOLECULE_RESULT

    python3 -m venv "${TMPDIR}/${1:-ansible}"
    source "${TMPDIR}/${1:-ansible}/bin/activate"
    pip3 install -r "${TMPDIR}/version_requirements.txt" || true
    MOLECULE_RESULT=$(molecule test | grep -E "CRITICAL|fatal:" || echo ":heavy_check_mark:")
    if [ "${MOLECULE_RESULT}" != ":heavy_check_mark:" ] ; then
        MOLECULE_RESULT=":x:"
    fi
    deactivate

    echo -n "${MOLECULE_RESULT}" | tee -a /tmp/molecule_tests.md
}

function main {
    echo "| Version   | Result             |" | tee /tmp/molecule_tests.md
    echo "| --------- | ------------------ |" | tee -a /tmp/molecule_tests.md
    for TEST_ANSIBLE in $(ansible_releases) ; do
        echo -n "| ${TEST_ANSIBLE} | " | tee -a /tmp/molecule_tests.md
        build_requirements "${TEST_ANSIBLE}" > "${TMPDIR}/version_requirements.txt"
        make_venv "${TEST_ANSIBLE}"
        echo " |" | tee -a /tmp/molecule_tests.md
    done
}

main
