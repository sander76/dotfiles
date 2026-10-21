#!/usr/bin/env zsh

pts_native() {
    local script_dir="${${(%):-%x}:A:h}"
    local query="${1:-}"
    local entry choice selected_test collection_output collection_status i
    local -a entries collected_tests

    while IFS= read -r entry; do
        [[ -z "$query" || "${(L)entry}" == *"${(L)query}"* ]] && entries+=("$entry")
    done < <("$script_dir/list_tests.sh" tests)

    if (( ${#entries} == 0 )); then
        print "No test files or directories found."
        return 1
    fi

    print "Available tests and directories:"
    for (( i = 1; i <= ${#entries}; i++ )); do
        printf '%d) %s\n' "$i" "${entries[i]}"
    done

    printf 'Select an entry number (or q to cancel): '
    IFS= read -r choice
    [[ "$choice" == q || "$choice" == Q ]] && return 0
    if [[ "$choice" != <-> ]] || (( choice < 1 || choice > ${#entries} )); then
        print "Invalid selection."
        return 1
    fi
    selected_test="${entries[choice]}"

    if [[ -f "$selected_test" ]]; then
        printf 'Collect individual tests from this file? [y/N] '
        IFS= read -r choice
        if [[ "$choice" == y || "$choice" == Y ]]; then
            collection_output=$(uv run pytest "$selected_test" --collect-only -q)
            collection_status=$?
            if (( collection_status != 0 )); then
                return "$collection_status"
            fi

            while IFS= read -r entry; do
                [[ "$entry" == *::* ]] && collected_tests+=("$entry")
            done <<< "$collection_output"

            if (( ${#collected_tests} == 0 )); then
                print "No individual tests were collected from $selected_test."
                return 1
            fi

            print "Collected tests:"
            for (( i = 1; i <= ${#collected_tests}; i++ )); do
                printf '%d) %s\n' "$i" "${collected_tests[i]}"
            done

            printf 'Select a test number (or q to cancel): '
            IFS= read -r choice
            [[ "$choice" == q || "$choice" == Q ]] && return 0
            if [[ "$choice" != <-> ]] || (( choice < 1 || choice > ${#collected_tests} )); then
                print "Invalid selection."
                return 1
            fi
            selected_test="${collected_tests[choice]}"
        fi
    fi

    print -z "uv run pytest ${(q)selected_test}"
}

pts_native "$@"
